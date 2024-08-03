//
//  ViewController.swift
//  WarGame
//
//  Created by Kiran_Koneti on 01/08/24.
//

import UIKit
class SetupViewController: UIViewController {

  @IBOutlet weak var numberofPlayersControl: UISegmentedControl!
  @IBOutlet weak var startGameButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func startGameButtonTapped(_ sender: UIButton) {
    if let numberOfPlayersTitle = numberofPlayersControl.titleForSegment(at:numberofPlayersControl.selectedSegmentIndex),
        let numberOfPlayers = Int(numberOfPlayersTitle) {
      let gameViewController = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
      gameViewController.numberOfPlayers = numberOfPlayers
      navigationController?.pushViewController(gameViewController, animated: true)
    }
  }
}

