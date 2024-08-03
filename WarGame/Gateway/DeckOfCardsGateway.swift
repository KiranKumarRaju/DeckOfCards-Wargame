//
//  DeckOfCardsGateway.swift
//  WarGame
//
//  Created by Kiran_Koneti on 04/08/24.
//

import Foundation
import DeckOfCards

protocol DeckOfCardsGateway {
  func createNewDeck(jokersEnabled: Bool, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void)
  func shuffleDeck(deckID: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void)
  func drawCards(deckID: String, count: Int, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void)
  func addToPile(deckID: String, pileName: String, cards: [Card], completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void)
  func drawCardFromPile(deckID: String, pileName: String, count: Int?, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void)
}

class DeckOfCardsGatewayImpl: DeckOfCardsGateway {
  
  func createNewDeck(jokersEnabled: Bool, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    DeckOfCards.createNewDeck(jokersEnabled: jokersEnabled, completion: completion)
  }
  
  func shuffleDeck(deckID: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    DeckOfCards.shuffleDeck(deckID: deckID, completion: completion)
  }
  
  func drawCards(deckID: String, count: Int, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void) {
    DeckOfCards.drawCards(deckID: deckID, count: count, completion: completion)
  }
  
  func addToPile(deckID: String, pileName: String, cards: [Card], completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    DeckOfCards.addToPile(deckID: deckID, pileName: pileName, cards: cards, completion: completion)
  }
  
  func drawCardFromPile(deckID: String, pileName: String, count: Int?, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void) {
    DeckOfCards.drawCardFromPile(deckID: deckID, pileName: pileName, count: count ?? 1, completion: completion)
  }
}
