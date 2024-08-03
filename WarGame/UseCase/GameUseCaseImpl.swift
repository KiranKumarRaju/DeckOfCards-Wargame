//
//  GameUseCaseImpl.swift
//  WarGame
//
//  Created by Kiran_Koneti on 04/08/24.
//

import Foundation
import DeckOfCards

class GameUseCaseImpl: GameUseCase {
  
  private let deckOfCardsGateway: DeckOfCardsGateway
  private let numberOfPlayers: Int
  private var deckId: String = ""
  private(set) var players: [Player] = []
  private(set) var roundResult: String = ""
  
  init(deckOfCardsGateway: DeckOfCardsGateway, numberOfPlayers: Int) {
    self.deckOfCardsGateway = deckOfCardsGateway
    self.numberOfPlayers = numberOfPlayers
  }
  
  func startNewGame(completion: @escaping (Result<Void, Error>) -> Void) {
    deckOfCardsGateway.createNewDeck(jokersEnabled: false) { result in
      switch result {
      case .success(let deck):
        self.deckId = deck.deckId
        self.createPlayerPiles(deckId: deck.deckId, completion: completion)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  private func createPlayerPiles(deckId: String, completion: @escaping (Result<Void, Error>) -> Void) {
    players = (1...numberOfPlayers).map { Player(name: "Player \($0)", pileName: "pile\($0)") }
    distributeCardsToPiles(deckId: deckId, completion: completion)
  }
  
  private func distributeCardsToPiles(deckId: String, completion: @escaping (Result<Void, Error>) -> Void) {
    deckOfCardsGateway.drawCards(deckID: deckId, count: 52) { result in
      switch result {
      case .success(let cards):
        let cardsPerPlayer = cards.cards.count / self.players.count
        for (index, player) in self.players.enumerated() {
          let playerCards = Array(cards.cards[index * cardsPerPlayer..<((index + 1) * cardsPerPlayer)])
          self.deckOfCardsGateway.addToPile(deckID: deckId, pileName: player.pileName, cards: playerCards) { result in
            if index == self.players.count - 1 {
              completion(.success(()))
            }
          }
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func playRound(completion: @escaping (Result<Void, Error>) -> Void) {
    var drawnCards: [(index: Int, card: Card)] = []
    let dispatchGroup = DispatchGroup()
    
    for (index, player) in players.enumerated() {
      dispatchGroup.enter()
      deckOfCardsGateway.drawCardFromPile(deckID: deckId, pileName: player.pileName, count: 1) { result in
        switch result {
        case .success(let cards):
          if let card = cards.cards.first {
            drawnCards.append((index: index, card: card))
            self.players[index].drawnCardImageURL = card.image
          }
          
        case .failure(let error):
          completion(.failure(error))
        }
        dispatchGroup.leave()
      }
    }
    
    dispatchGroup.notify(queue: .main) {
      self.processDrawnCards(drawnCards, completion: completion)
    }
  }
  
  private func processDrawnCards(_ drawnCards: [(index: Int, card: Card)], completion: @escaping (Result<Void, Error>) -> Void) {
    guard let maxCardValue = drawnCards.map({ $0.card.cardValue() }).max() else {
      completion(.failure(NSError(domain: "com.wargame", code: -1, userInfo: [NSLocalizedDescriptionKey: "No cards drawn"])))
      return
    }
    
    var winningPlayers = drawnCards.filter { $0.card.cardValue() == maxCardValue }
    
    if winningPlayers.count > 1 {
      // Check for the player with the most cards in their pile
      winningPlayers.sort { players[$0.index].hand.count > players[$1.index].hand.count }
      let maxPileCount = players[winningPlayers.first!.index].hand.count
      winningPlayers = winningPlayers.filter { players[$0.index].hand.count == maxPileCount }
      
      // If there's still a tie, select a random player from the tied players
      if winningPlayers.count > 1 {
        winningPlayers.shuffle()
      }
    }
    
    guard let winnerIndex = winningPlayers.first?.index else {
      completion(.failure(NSError(domain: "com.wargame", code: -1, userInfo: [NSLocalizedDescriptionKey: "No winning player found"])))
      return
    }
    
    // The winner takes all drawn cards
    let cardsWon = drawnCards.map { $0.card }
    deckOfCardsGateway.addToPile(deckID: deckId, pileName: players[winnerIndex].pileName, cards: cardsWon) { result in
      switch result {
      case .success:
        self.players[winnerIndex].battlesWon += 1
        
        DispatchQueue.main.async {
          self.roundResult = "\(self.players[winnerIndex].name) wins this round"
          
          // Check if any player has won 10 battles
          if self.players[winnerIndex].battlesWon >= 10 {
            self.roundResult = "\(self.players[winnerIndex].name) wins the game!"
          }
        }
        
        
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
