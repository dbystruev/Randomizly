//
//  GameViewController.swift
//  Randomizly2
//
//  Created by Denis Bystruev on 29/11/2017.
//  Copyright © 2017 Denis Bystruev. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    let model = Model()
    var timer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFields()
        hintLabel.isHidden = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            let colors: [UIColor] = [.white, .cyan, .yellow]
            let index = Int(Date().timeIntervalSince1970) % colors.count
            self.view.backgroundColor = colors[index]
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        super.viewWillDisappear(animated)
    }
    
    func updateFields() {
        titleLabel.text = "Угадай число от \(model.minNumber) до \(model.maxNumber)"
        inputField.text = String((model.maxNumber - model.minNumber) / 2 + model.minNumber)
    }
    
    @IBAction func guess(_ sender: Any) {
        if
            let input = inputField.text,
            let number = Int(input),
            model.minNumber <= number, number <= model.maxNumber
        {
            let result = model.guess(number)
            switch result {
            case .tooLow:
                hintLabel.text = "⬆️ больше \(number)"
                hintLabel.isHidden = false
                updateFields()
            case .correct:
                hintLabel.isHidden = true
                var message = "Вы угадали за \(model.tries)"
                switch model.tries % 100 {
                case 11...19:
                    message += " попыток"
                default:
                    switch model.tries % 10 {
                    case 1:
                        message += " попытку"
                    case 2...4:
                        message += " попытки"
                    default:
                        message += " попыток"
                    }
                }
                showAlert(title: "Поздравляем, это \(number)!", message: message)
                model.randomize()
                updateFields()
            case .tooHigh:
                hintLabel.text = "⬇️ меньше \(number)"
                hintLabel.isHidden = false
                updateFields()
            }
        } else {
            showAlert(title: "Ошибка", message: "Введите целое число от \(model.minNumber) до \(model.maxNumber)")
            hintLabel.isHidden = true
            updateFields()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
