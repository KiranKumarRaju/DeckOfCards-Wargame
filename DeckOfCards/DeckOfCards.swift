//
//  DeckOfCards.swift
//  DeckOfCards
//
//  Created by Kiran_Koneti on 01/08/24.
//

import Foundation

@objc
public class DeckOfCards: NSObject {
  
  internal static var server: ServiceGateway?
  
  public static func initialise() throws {
    
    guard let buildConfiguration = try? BuildConfigurations.fetchConfiguration() else {
      throw SDKError.initialize(message: "Failed to fetch build configuration")
    }
    
    guard let serverUrl = URL(string: buildConfiguration.serverUrl) else {
      throw SDKError.initialize(message: "Failed to parse server URL")
    }
    self.server = APIGatewayImpl(serverUrl: serverUrl)
  }
  
  /// Create a new deck
  public static func createNewDeck(jokersEnabled: Bool?, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    self.server?.createNewDeck(jokersEnabled: jokersEnabled ?? false, completion: completion)
  }
  
  /// Shuffle an existing deck
  public static func shuffleDeck(deckID: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    self.server?.shuffleDeck(deckID: deckID, completion: completion)
  }
  
  /// Draw a card from a deck
  public static func drawCards(deckID: String, count: Int, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void) {
    self.server?.drawCards(deckID: deckID, count: count, completion: completion)
  }
  
  /// Add cards to a pile
  public static func addToPile(deckID: String, pileName: String, cards: [Card], completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    self.server?.addToPile(deckID: deckID, pileName: pileName, cards: cards, completion: completion)
  }
  
  /// Shuffle a pile
  public static func shufflePile(deckID: String, pileName: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    self.server?.shufflePile(deckID: deckID,pileName: pileName, completion: completion)
  }
  
  /// List cards in a pile
  public static func listCardsInPile(deckID: String, pileName: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    self.server?.listCardsInPile(deckID: deckID, pileName: pileName, completion: completion)
  }
  
  /// Draw cards from a pile
  public static func drawCardFromPile(deckID: String, pileName: String, count: Int, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void) {
    self.server?.drawCardFromPile(deckID: deckID, pileName: pileName, count: count, completion: completion)
  }
  
}
