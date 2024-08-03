//
//  Card.swift
//  DeckOfCards
//
//  Created by Kiran_Koneti on 01/08/24.
//

import Foundation

// Card Model
public struct Card: Codable {
  public let code: String
  public let image: String
  public let suit: String
  public let value: String
}

// Cards Model (Array of Cards)
public struct Cards: Codable {
  public let cards: [Card]
}
