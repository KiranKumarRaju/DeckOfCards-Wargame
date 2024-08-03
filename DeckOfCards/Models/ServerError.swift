//
//  Error.swift
//  DeckOfCards
//
//  Created by Kiran_Koneti on 01/08/24.
//

import Foundation

public struct ServerError : Error,Codable {
  public let code: Int
  public let message: String
}

struct ClientDataError : Error,Codable {
  let success: Bool
  let error: String
}

enum SDKError: LocalizedError {
    case initialize(message: String)
}

public enum DeckOfCardsError: Error {
  case invalidURL
  case noDataReceived
  case unknownError
  case serverError(code: Int, message: String)
  case clientDataError(message: String)
  
  var localizedDescription: String {
    switch self {
    case .invalidURL:
      return "Invalid URL"
    case .noDataReceived:
      return "No data received"
    case .unknownError:
      return "Unknown error occurred"
    case .serverError(_, let message):
      return message
    case .clientDataError(let message):
      return message
    }
  }
}
