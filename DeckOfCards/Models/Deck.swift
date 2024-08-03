//
//  Deck.swift
//  DeckOfCards
//
//  Created by Kiran_Koneti on 01/08/24.
//

import Foundation

public struct Deck: Codable {
  public let success: Bool
  public let error: String?
  public let deckId: String
  public let shuffled: Bool?
  public let remaining: Int
  public let cards: [Card]?
  
  enum CodingKeys: String, CodingKey {
    case deckId = "deck_id"
    case success
    case error
    case shuffled
    case remaining
    case cards
  }
  
}
