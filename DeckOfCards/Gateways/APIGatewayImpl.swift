//
//  ServerGatewayImpl.swift
//  DeckOfCards
//
//  Created by Kiran_Koneti on 01/08/24.
//

import Foundation

internal class APIGatewayImpl: ServiceGateway {
  
  internal let serverUrl: URL
  private let maxRetries = 3
  private let session: URLSession
  
  init(serverUrl: URL, session: URLSession = .shared) {
    self.serverUrl = serverUrl
    self.session = session
  }
  
  // Create a new deck
  func createNewDeck(jokersEnabled: Bool, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    var urlComponents = URLComponents(url: serverUrl.appendingPathComponent("/deck/new/"), resolvingAgainstBaseURL: false)!
    urlComponents.queryItems = [URLQueryItem(name: "jokers_enabled", value: "\(jokersEnabled)")]
    
    guard let url = urlComponents.url else {
      completion(.failure(.invalidURL))
      return
    }
    performRequest(with: url, retries: maxRetries, completion: completion)
  }
  
  // Shuffle the cards in the deck
  func shuffleDeck(deckID: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    let url = serverUrl.appendingPathComponent("/deck/\(deckID)/shuffle/")
    performRequest(with: url, retries: maxRetries, completion: completion)
  }
  
  // Draw a card from a deck
  func drawCards(deckID: String, count: Int, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void) {
    var urlComponents = URLComponents(url: serverUrl.appendingPathComponent("/deck/\(deckID)/draw/"), resolvingAgainstBaseURL: false)!
    urlComponents.queryItems = [URLQueryItem(name: "count", value: "\(count)")]
    
    guard let url = urlComponents.url else {
      completion(.failure(.invalidURL))
      return
    }
    
    performRequest(with: url, retries: maxRetries, completion: completion)
  }
  
  // Add cards to a pile
  func addToPile(deckID: String, pileName: String, cards: [Card], completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    let cardCodes = cards.map { $0.code }
    let cardsString = cardCodes.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    var urlComponents = URLComponents(url: serverUrl.appendingPathComponent("/deck/\(deckID)/pile/\(pileName)/add/"), resolvingAgainstBaseURL: false)!
    urlComponents.queryItems = [URLQueryItem(name: "cards", value: cardsString)]
    
    guard let url = urlComponents.url else {
      completion(.failure(.invalidURL))
      return
    }
    
    performRequest(with: url, retries: maxRetries, completion: completion)
  }
  
  // Shuffle a pile
  func shufflePile(deckID: String, pileName: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    let url = self.serverUrl.appendingPathComponent("/deck/\(deckID)/pile/\(pileName)/shuffle/")
    performRequest(with: url, retries: maxRetries, completion: completion)
  }
  
  // List cards in a pile
  func listCardsInPile(deckID: String, pileName: String, completion: @escaping (Result<Deck, DeckOfCardsError>) -> Void) {
    let url = self.serverUrl.appendingPathComponent("/deck/\(deckID)/pile/\(pileName)/list/")
    performRequest(with: url, retries: maxRetries, completion: completion)
  }
  
  // Draw card(s) from a pile
  func drawCardFromPile(deckID: String, pileName: String, count: Int?, completion: @escaping (Result<Cards, DeckOfCardsError>) -> Void) {
    var urlComponents = URLComponents(url: self.serverUrl.appendingPathComponent("/deck/\(deckID)/pile/\(pileName)/draw/"), resolvingAgainstBaseURL: false)!
    
    var queryItems = [URLQueryItem]()
    if let count = count {
      queryItems.append(URLQueryItem(name: "count", value: "\(count)"))
    }
    
    urlComponents.queryItems = queryItems
    
    guard let url = urlComponents.url else {
      completion(.failure(.invalidURL))
      return
    }
    
    performRequest(with: url, retries: maxRetries, completion: completion)
  }
  
  // Helper Method
  private func performRequest<T: Decodable>(with url: URL, retries: Int, completion: @escaping (Result<T, DeckOfCardsError>) -> Void) {
    let task = session.dataTask(with: url) { data, response, error in
      
      guard let httpResponse = response as? HTTPURLResponse else {
        if retries > 0 {
          self.performRequest(with: url, retries: retries - 1, completion: completion)
        } else {
          completion(.failure(.unknownError))
        }
        return
      }
      
      guard let data = data else {
        if retries > 0 {
          self.performRequest(with: url, retries: retries - 1, completion: completion)
        } else {
          completion(.failure(.noDataReceived))
        }
        return
      }
      
      print(httpResponse.statusCode)
      
      switch httpResponse.statusCode {
      case 200...299:
        do {
          let result = try JSONDecoder().decode(T.self, from: data)
          completion(.success(result))
        } catch {
          self.decodeServerError(from: data, completion: completion)
        }
      case 400...499:
        do {
          let clientError = try JSONDecoder().decode(ClientDataError.self, from: data)
          completion(.failure(.clientDataError(message: clientError.error)))
        } catch {
          completion(.failure(.clientDataError(message: "Client Data error")))
        }
      case 500...599:
        self.decodeServerError(from: data, completion: completion)
      default:
        if retries > 0 {
          self.performRequest(with: url, retries: retries - 1, completion: completion)
        } else {
          completion(.failure(.unknownError))
        }
      }
    }
    task.resume()
  }
  
  private func decodeServerError<T>(from data: Data, completion: @escaping (Result<T, DeckOfCardsError>) -> Void) {
    do {
      let serverError = try JSONDecoder().decode(ServerError.self, from: data)
      completion(.failure(.serverError(code: serverError.code, message: serverError.message)))
    } catch {
      completion(.failure(.unknownError))
    }
  }
}
