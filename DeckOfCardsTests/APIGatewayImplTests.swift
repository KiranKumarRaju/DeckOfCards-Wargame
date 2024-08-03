//
//  APIGatewayImplTests.swift
//  DeckOfCardsTests
//
//  Created by Kiran_Koneti on 04/08/24.
//

import Foundation

import XCTest
@testable import DeckOfCards

class APIGatewayImplTests: XCTestCase {
  
  var apiGateway: APIGatewayImpl!
  let baseURL = URL(string: "https://deckofcardsapi.com/api")!
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    apiGateway = nil
    super.tearDown()
  }
  
  func testCreateNewDeck() {
    let expectedDeck = Deck(success: true, error: nil, deckId: "newdeck123", shuffled: false, remaining: 52, cards: nil)
    let responseData = try! JSONEncoder().encode(expectedDeck)
    let mockSession = MockURLSession.configureMockSession { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, responseData)
    }
    
    apiGateway = APIGatewayImpl(serverUrl: baseURL, session: mockSession)
    
    let expectation = self.expectation(description: "Create new deck")
    
    apiGateway.createNewDeck(jokersEnabled: false) { result in
      switch result {
      case .success(let deck):
        XCTAssertEqual(deck.deckId, expectedDeck.deckId)
        XCTAssertEqual(deck.shuffled, expectedDeck.shuffled)
        XCTAssertEqual(deck.remaining, expectedDeck.remaining)
      case .failure:
        XCTFail("Expected to succeed, but failed")
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testShuffleDeck() {
    let expectedDeck = Deck(success: true, error: nil, deckId: "deck123", shuffled: true, remaining: 52, cards: nil)
    let responseData = try! JSONEncoder().encode(expectedDeck)
    let mockSession = MockURLSession.configureMockSession { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, responseData)
    }
    
    apiGateway = APIGatewayImpl(serverUrl: baseURL, session: mockSession)
    
    let expectation = self.expectation(description: "Shuffle deck")
    
    apiGateway.shuffleDeck(deckID: "deck123") { result in
      switch result {
      case .success(let deck):
        XCTAssertEqual(deck.deckId, expectedDeck.deckId)
        XCTAssertEqual(deck.shuffled, expectedDeck.shuffled)
        XCTAssertEqual(deck.remaining, expectedDeck.remaining)
      case .failure:
        XCTFail("Expected to succeed, but failed")
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testDrawCards() {
    let expectedCards = Cards(cards: [Card(code: "5", image: "http://example.com/5H.png", suit: "HEARTS", value: "5H")])
    let responseData = try! JSONEncoder().encode(expectedCards)
    let mockSession = MockURLSession.configureMockSession { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, responseData)
    }
    
    apiGateway = APIGatewayImpl(serverUrl: baseURL, session: mockSession)
    
    let expectation = self.expectation(description: "Draw cards")
    
    apiGateway.drawCards(deckID: "deck123", count: 1) { result in
      switch result {
      case .success(let cards):
        XCTAssertEqual(cards.cards.count, expectedCards.cards.count)
        XCTAssertEqual(cards.cards.first?.code, expectedCards.cards.first?.code)
      case .failure:
        XCTFail("Expected to succeed, but failed")
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testAddToPile() {
    let expectedDeck = Deck(success: true, error: nil, deckId: "deck123", shuffled: false, remaining: 24, cards: nil)
    let responseData = try! JSONEncoder().encode(expectedDeck)
    let mockSession = MockURLSession.configureMockSession { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, responseData)
    }
    
    apiGateway = APIGatewayImpl(serverUrl: baseURL, session: mockSession)
    
    let cards = [Card(code: "5", image: "HEARTS", suit: "5H", value: "http://example.com/5H.png")]
    let expectation = self.expectation(description: "Add to pile")
    
    apiGateway.addToPile(deckID: "deck123", pileName: "pile1", cards: cards) { result in
      switch result {
      case .success(let deck):
        XCTAssertEqual(deck.deckId, expectedDeck.deckId)
      case .failure:
        XCTFail("Expected to succeed, but failed")
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testDrawCardFromPile() {
    let expectedCards = Cards(cards: [Card(code: "5", image: "http://example.com/5H.png", suit: "HEARTS", value: "5H")])
    let responseData = try! JSONEncoder().encode(expectedCards)
    let mockSession = MockURLSession.configureMockSession { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, responseData)
    }
    
    apiGateway = APIGatewayImpl(serverUrl: baseURL, session: mockSession)
    
    let expectation = self.expectation(description: "Draw card from pile")
    
    apiGateway.drawCardFromPile(deckID: "deck123", pileName: "pile1", count: 1) { result in
      switch result {
      case .success(let cards):
        XCTAssertEqual(cards.cards.count, expectedCards.cards.count)
        XCTAssertEqual(cards.cards.first?.code, expectedCards.cards.first?.code)
      case .failure:
        XCTFail("Expected to succeed, but failed")
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
  }
}
