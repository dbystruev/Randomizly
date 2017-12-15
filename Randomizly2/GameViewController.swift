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
    
    var colors = [UIColor]()
    var colorIndex = 0
    let model = Model()
    var timer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initColors()
        updateTitle()
        hintLabel.isHidden = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.colorIndex += 1
            self.colorIndex = self.colors.count <= self.colorIndex ? 0 : self.colorIndex
            self.view.backgroundColor = self.colors[self.colorIndex]
        })
    }
    
    func initColors() {
        if colors.count == 0 {
            for i in (50...100).reversed() {
                let color = UIColor(white: 0.01 * CGFloat(i), alpha: 1)
                colors.append(color)
            }
        }
        
        colorIndex = 0
        view.backgroundColor = colors[colorIndex]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        super.viewWillDisappear(animated)
    }
    
    func updateInputField() {
        inputField.text = String((model.maxNumber - model.minNumber) / 2 + model.minNumber)
    }
    
    func updateTitle() {
        titleLabel.text = "Угадай число от \(model.minNumber) до \(model.maxNumber)"
    }
    
    @IBAction func hint(_ sender: Any) {
        updateInputField()
    }
    
    @IBAction func guess(_ sender: Any) {
        initColors()
        if
            let input = inputField.text,
            let number = Int(input),
            model.minNumber <= number, number <= model.maxNumber
        {
            let result = model.guess(number)
            switch result {
            case .tooLow:
                hintLabel.text = "\(number) < ⬆️ \u{2A7D} \(model.maxNumber)"
                hintLabel.isHidden = false
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
                updateTitle()
            case .tooHigh:
                hintLabel.text = "\(model.minNumber) \u{2A7D} ⬇️ < \(number)"
                hintLabel.isHidden = false
            }
        } else {
            showAlert(title: "Ошибка", message: "Введите целое число от \(model.minNumber) до \(model.maxNumber)")
            hintLabel.isHidden = true
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
