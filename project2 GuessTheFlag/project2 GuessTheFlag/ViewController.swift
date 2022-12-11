//
//  ViewController.swift
//  project2 GuessTheFlag
//
//  Created by nikita on 11.12.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonThree: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        countries.append("estonia")
        countries.append("ireland")
        countries.append("france")
        countries.append("germany")
        countries.append("monaco")
        countries.append("italy")
        countries.append("nigeria")
        countries.append("poland")
        countries.append("russia")
        countries.append("spain")
        countries.append("uk")
        countries.append("us")
        
        buttonOne.layer.borderWidth = 1
        buttonTwo.layer.borderWidth = 1
        buttonThree.layer.borderWidth = 1
        
        buttonOne.layer.borderColor = UIColor.lightGray.cgColor
        buttonTwo.layer.borderColor = UIColor.lightGray.cgColor
        buttonThree.layer.borderColor = UIColor.lightGray.cgColor

        
        askQuestion()
    }
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        buttonOne.setImage(UIImage(named: countries[0]), for: .normal)
        buttonTwo.setImage(UIImage(named: countries[1]), for: .normal)
        buttonThree.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
}

