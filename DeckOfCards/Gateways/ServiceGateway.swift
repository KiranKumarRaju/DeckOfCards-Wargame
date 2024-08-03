//
//  ServerGateway.swift
//  DeckOfCards
//
//  Created by Kiran_Koneti on 01/08/24.
//

import Foundation

protocol ServiceGateway {
  func createNewDeck(jokersEnabled: Bool, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void)
  func shuffleDeck(deckID: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void)
  func drawCards(deckID: String, count:Int, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void)
  func addToPile(deckID: String, pileName: String, cards: [Card], completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void)
  func shufflePile(deckID: String, pileName: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void)
  func listCardsInPile(deckID: String, pileName: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void)
  func drawCardFromPile(deckID: String, pileName: String, count: Int?, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void)
}
