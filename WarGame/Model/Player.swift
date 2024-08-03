//
//  Player.swift
//  WarGame
//
//  Created by Kiran_Koneti on 03/08/24.
//

import Foundation
import DeckOfCards

public struct Player {
  public var name: String
  public var hand: [Card] = []
  public var battlesWon: Int = 0
  public var pileName: String
  public var drawnCardImageURL: String?
  
  public init(name: String, pileName: String) {
    self.name = name
    self.pileName = pileName
  }
}

extension Card {
  public func cardValue() -> Int {
    switch self.value {
    case "ACE":
      return 14
    case "KING":
      return 13
    case "QUEEN":
      return 12
    case "JACK":
      return 11
    default:
      return Int(self.value) ?? 0
    }
  }
}
