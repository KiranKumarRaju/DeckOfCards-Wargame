//
//  GameViewController.swift
//  WarGame
//
//  Created by Kiran_Koneti on 02/08/24.
//

import UIKit

class GameViewController: UIViewController {
  
  @IBOutlet weak var playRoundButton: UIButton!
  @IBOutlet weak var roundResultLabel: UILabel!
  @IBOutlet weak var playersTableView: UITableView!
  @IBOutlet weak var playerViewHeight: NSLayoutConstraint!
  
  private var gameUseCase: GameUseCase!
  
  var numberOfPlayers: Int = 2
  private let placeholderImage = UIImage(named: "PlaceHolderDeck")
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    setup()
    let apiGateway = DeckOfCardsGatewayImpl()
    gameUseCase = GameUseCaseImpl(deckOfCardsGateway: apiGateway, numberOfPlayers: numberOfPlayers)
    startNewGame()
  }
  
  private func setup() {
    self.title = "War Game"
    playersTableView.rowHeight = UITableView.automaticDimension
    playersTableView.estimatedRowHeight = 156
    self.playRoundButton.isEnabled = false
  }
  
  private func startNewGame() {
    gameUseCase.startNewGame { result in
      switch result {
      case .success:
        self.updatePlayerLabels()
      case .failure(let error):
        print("Error shuffling deck: \(error)")
        DispatchQueue.main.async {
          self.showAlert(title: "Network Error", message: "Failed to shuffle the deck. Please try again later.")
        }
      }
    }
  }
  
  private func updatePlayerLabels() {
    DispatchQueue.main.async {
      dump("Players Cards:\(self.gameUseCase.players)")
      self.playersTableView.reloadData()
      self.playRoundButton.isEnabled = true
    }
  }
  
  @IBAction func playRoundButtonTapped(_ sender: UIButton) {
    gameUseCase.playRound { result in
      switch result {
      case .success:
        self.updatePlayerLabels()
        DispatchQueue.main.async {
          self.roundResultLabel.text = self.gameUseCase.roundResult
          if self.gameUseCase.roundResult.contains("wins the game") {
            self.playRoundButton.isEnabled = false
          }
        }
      case .failure(let error):
        if error.localizedDescription == "Unable to draw" { //handling input error
          DispatchQueue.main.async {
            self.playRoundButton.isEnabled = true
            self.showAlert(title: "Input Error", message: error.localizedDescription)
          }
        }
      }
    }

  }
  
  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    self.playRoundButton.isEnabled = true
  }
  
  override func viewWillLayoutSubviews() {
    super.updateViewConstraints()
    self.playerViewHeight.constant = self.playersTableView.contentSize.height
  }
}

extension GameViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return gameUseCase.players.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
    let player = gameUseCase.players[indexPath.row]
    cell.playerNameLabel.text = "\(player.name)"
    cell.battlesCounterLabel.text = "Battles won: \(player.battlesWon)"
    cell.cardImageView.image = placeholderImage
    if let imageURL = player.drawnCardImageURL, let url = URL(string: imageURL) {
      loadImage(from: url) { image in
        DispatchQueue.main.async {
          cell.cardImageView.image = image ?? self.placeholderImage
        }
      }
    } else {
      cell.cardImageView.image = placeholderImage
    }
    return cell
  }
  
  private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        completion(image)
      } else {
        completion(nil)
      }
    }
  }
}
