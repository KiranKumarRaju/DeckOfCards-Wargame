import Foundation

protocol GameUseCase {
  func startNewGame(completion: @escaping (Result<Void, Error>) -> Void)
  func playRound(completion: @escaping (Result<Void, Error>) -> Void)
  var players: [Player] { get }
  var roundResult: String { get }
}
