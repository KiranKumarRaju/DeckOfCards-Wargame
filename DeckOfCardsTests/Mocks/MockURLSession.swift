//
//  MockURLSession.swift
//  DeckOfCardsTests
//
//  Created by Kiran_Koneti on 04/08/24.
//

import Foundation

class MockURLSession {
  static func configureMockSession(with handler: @escaping (URLRequest) throws -> (HTTPURLResponse, Data?)) -> URLSession {
    MockURLProtocol.requestHandler = handler
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
  }
}
