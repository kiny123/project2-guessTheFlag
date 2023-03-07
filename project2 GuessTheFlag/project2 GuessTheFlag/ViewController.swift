//
//  ViewController.swift
//  project2 GuessTheFlag
//
//  Created by nikita on 11.12.2022.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var track = 0
    var highScore = 0
    var keyHigh = "highScore"
    let maxTrack = 10
    var isGameOver = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerLocal()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(scoreAlert))
    
        
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let userDefaults = UserDefaults.standard
                 highScore = userDefaults.object(forKey: keyHigh) as? Int ?? 0
                 print("Current top score", highScore)

        askQuestion()
        scheduleLocal()
        
    }
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "Which - \(countries[correctAnswer].uppercased())?"
        
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            track += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag]) "
            score -= 1
            track += 1
            
            Alert()
        }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = .identity
        })
        
        if track == 10 {
            title = "Nice! You answered 10 questions! Your final score is \(score)"
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
        
        
       
    }
    func gameOver() {
        isGameOver = true
             let finalScore = score
             var message = "Your score is \(finalScore)"

             if score > highScore {
                 message += "\n\nNew Highest Score\nPrevious highest: \(highScore)"
                 highScore = score
             }

             score = 0
             correctAnswer = 0
             track = 0
             let userDefaults = UserDefaults.standard
             userDefaults.set(highScore, forKey: keyHigh)

             let ac = UIAlertController(title: "Game over!", message: message, preferredStyle: .alert)

             ac.addAction(UIAlertAction(title: "Start new game", style: .default, handler: askQuestion))

             present(ac, animated: true)
        
         }
    
    @objc func scoreAlert() {
        let score1 = UIAlertController(title: "Your score is \(score)", message: nil, preferredStyle: .actionSheet)
        score1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(score1, animated: true)
    }
    
    @objc func saveHighScore() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(highScore, forKey: keyHigh)
    }
    
    func Alert() {
        
        if track < maxTrack {
            askQuestion()
        } else {
            gameOver()
        }
        
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]){ granted, error in
            if granted{
                print("Yay")
            } else {
                print("Oops")
            }
            
        }
    }
    
    
     func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Hey! Let's choose flags!"
        content.body = "Game is need you"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "Show", title: "Play the game", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("custom data received \(customData)")
            
            switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    print("defaultIdentifier")
                
                case "show":
                 print("Show more information")
                    
            default:
                break;
            }
        }
        
        completionHandler()
    }
    

}

