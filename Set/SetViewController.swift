//
//  ViewController.swift
//  Set
//
//  Created by Nada Yehia Dawoud on 6/9/18.
//  Copyright © 2018 Mobile Apps Kitchen. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    var set = SetGame()
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var foundSetsLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    let colors = [UIColor.init(red: (219 / 255), green: (50 / 255), blue: (54 / 255), alpha: 1), //red
        UIColor.init(red: (244 / 255), green: (194 / 255), blue: (13 / 255), alpha: 1),//yellow
        UIColor.init(red: (60 / 255), green: (186 / 255), blue: (84 / 255), alpha: 1)] //green
    
    let symbols = ["▲", "■", "●"]
    
    let numberOfSymbols = [1, 2, 3]
    
    let firstShadingStylesAttributes: [NSAttributedString.Key: Any]  = [.strokeWidth: -1] //filled
    
    let secondShadingStyleAttributes: [NSAttributedString.Key: Any] = [.strokeWidth: 5] //stroked
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startNewGame()
    }
    
    func drawSymbolsOnCardWithColorAndShading(_ numberOfSymbols: Int, symbol: String, on button: UIButton, with color: UIColor, and shadingStyle: Int) {
        
        var stringAttributes: [NSAttributedString.Key: Any] = firstShadingStylesAttributes
        var _symbol: String
        
        // Find card shading
        switch shadingStyle {
        case 1:
            stringAttributes = firstShadingStylesAttributes
            stringAttributes[.foregroundColor] = color
            
        case 2:
            stringAttributes = secondShadingStyleAttributes
            stringAttributes[.foregroundColor] = color
            
        case 3:
            stringAttributes = [.foregroundColor: color.withAlphaComponent(0.2)]
            
        default:
            print("Default Case")
        }
        
        // Find card numberOfsymbols
        switch numberOfSymbols {
        case 1:
            _symbol = symbol
        case 2:
            _symbol = symbol + symbol
        case 3:
            _symbol = symbol + symbol + symbol
        default:
            _symbol = symbol
        }
        
        button.setAttributedTitle(NSMutableAttributedString.init(string: _symbol, attributes: stringAttributes), for: .normal)
    }
    
    /// Dictionary that keeps trak of which Cards displayed on which Buttons [cardButton.index: Card.id]
    var buttonsOfCards = [Int: Card]()
    
    func displayBoardCards() {
        for index in set.boardCards.indices {
            let cardSymbol = set.boardCards[index].symbol
            let cardColor = set.boardCards[index].color
            let cardNumberOfSymbols = set.boardCards[index].numberOfSymbols
            let cardShading = set.boardCards[index].shading
            
            var symbol: String
            var color: UIColor
            var numberOfSymbols: Int
            var shadingStyle: Int
            
            switch cardSymbol {
            case .firstSymbol:
                symbol = symbols[0]
            case .secondSymbol:
                symbol = symbols[1]
            case .thirdSymbol:
                symbol = symbols[2]
            }
            
            switch cardColor {
            case .firstColor:
                color = colors[0]
            case .secondColor:
                color = colors[1]
            case .thirdColor:
                color = colors[2]
            }
            
            switch cardNumberOfSymbols {
            case .One:
                numberOfSymbols = 1
            case .Two:
                numberOfSymbols = 2
            case .Three:
                numberOfSymbols = 3
            }
            
            switch cardShading {
            case .firstShading:
                shadingStyle = 1
            case .secondShading:
                shadingStyle = 2
            case .thirdShading:
                shadingStyle = 3
            }
            
            drawSymbolsOnCardWithColorAndShading(numberOfSymbols, symbol: symbol, on: cardButtons[index], with: color, and: shadingStyle)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            buttonsOfCards[index] = set.boardCards[index]
            cardButtons[index].isEnabled = true
            
        }
    }
    
    func startNewGame() {
        displayBoardCards()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let buttonIndex = cardButtons.index(of: sender), let card = buttonsOfCards[buttonIndex] {
            set.chooseCard(card)
            updateView()
        }
    }
    
    let selectionColor = UIColor.init(red: (72 / 255), green: (133 / 255), blue: (237 / 255), alpha: 1).cgColor
    
    func disableAllButtons() {
        for button in cardButtons {
            button.backgroundColor =  #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0)
            button.setAttributedTitle(NSMutableAttributedString.init(string: "", attributes: [:]), for: .normal)
            button.isEnabled = false
        }
    }
    
    func updateView() {
        for (buttonIndex, card) in buttonsOfCards {
            //Draw card selection
            if set.selectedCards.contains(card) {
                selectCard(button: cardButtons[buttonIndex])
            }
            else {
                deselectCard(button: cardButtons[buttonIndex])
            }
        }
        //Remove matched cards
        disableAllButtons()
        displayBoardCards()
    }
    
    func selectCard(button: UIButton) {
        button.layer.borderWidth = 3.0
        button.layer.borderColor = selectionColor
    }
    
    func deselectCard(button: UIButton) {
        button.layer.borderWidth = 0.0
    }
    
    @IBAction func touchDeal3MoreCards(_ sender: UIButton) {
    }
    
    @IBAction func touchRevealASet(_ sender: UIButton) {
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        set.reset()
        startNewGame()
    }
}

