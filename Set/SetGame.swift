//
//  Set.swift
//  Set
//
//  Created by Nada Yehia Dawoud on 6/10/18.
//  Copyright © 2018 Mobile Apps Kitchen. All rights reserved.
//


import Foundation

class SetGame {
    var cardDeck = [Card]()
    
    private(set) var score = 0
    private(set) var foundSets = 0
    private(set) var message = " "
    private(set) var messageStatus = false
    
    var maxNumberOfBoardCards: Int
    
    private let successMessages = ["Great! 👍", "Keep on going 👏", "One set found ✅", "That's right 🙌", "Cool 😎"]
    private let failureMessages = ["Not a set 👎", "Try again 🤦🏻‍♀️", "Still not found 🙅🏻‍♂️", "Keep trying 🔄", "Maybe next time🤞"]
    
    private let symbols = [Symbol.firstSymbol, Symbol.secondSymbol, Symbol.thirdSymbol]
    
    private let colors = [Color.firstColor, Color.secondColor, Color.thirdColor]
    
    private let shadings = [Shading.firstShading, Shading.secondShading, Shading.thirdShading]
    
    private let numbers = [NumberOfSymbols.One, NumberOfSymbols.Two, NumberOfSymbols.Three]
    
    var selectedCards = [Card]()
    var matchedCards = [Card]()
    var boardCards = [Card]()
    
    init(maxNumberOfBoardCards: Int) {
        for color in colors {
            for shading in shadings {
                for number in numbers {
                    for symbol in symbols {
                        let card = Card(cardID: 0, symbol: symbol, color: color, shading: shading, numberOfSymbols: number)
                        cardDeck += [card]
                    }
                }
            }
        }
        self.maxNumberOfBoardCards = maxNumberOfBoardCards
        cardDeck = shuffleCardDeck()
        
        //Make cardID unique
        for index in cardDeck.indices {
            cardDeck[index].cardID = index
        }
        
        //Add 12 cards to boardCards
        for i in 0...11 {
            boardCards += [cardDeck[i]]
        }
        
        //Remove boardCards from cardDeck
        cardDeck.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: 11)))
    }
    
    // TODO: Add func to shuffle the cards
    func shuffleCardDeck() -> [Card] {
        var shuffledCardDeck = [Card]()
        for _ in cardDeck.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(cardDeck.count)))
            shuffledCardDeck.append(cardDeck[randomIndex])
            cardDeck.remove(at: randomIndex)
        }
        return shuffledCardDeck
    }
    // TODO: Add func to chooseCard
    func chooseCard(_ card: Card) {
        if selectedCards.count < 3, !selectedCards.contains(card) {
            selectedCards += [card]
        }
        else {
            if let selectedCardID = selectedCards.firstIndex(of: card), selectedCards.count < 3 {
                selectedCards.remove(at: selectedCardID)
            }
        }
        
        if selectedCards.count == 3 {
            if doMakeASet(firstCard: selectedCards[0], secondCard: selectedCards[1], thirdCard: selectedCards[2]) {
                matchedCards += selectedCards
                //remove from board cards
                for card in selectedCards{
                    boardCards = boardCards.filter {$0 != card}
                }
                
                drawThreeMoreCards()
                score += 3
                foundSets += 1
                let randomMessageIndex = Int(arc4random_uniform(UInt32(successMessages.count)))
                message = successMessages[randomMessageIndex]
                messageStatus = true
            }
            else {
                let randomMessageIndex = Int(arc4random_uniform(UInt32(failureMessages.count)))
                message = failureMessages[randomMessageIndex]
                messageStatus = false
            }
            
            //remove ids from selectedCards
            selectedCards = [Card]()
        }
    }
    
    func drawThreeMoreCards() {
        if boardCards.count < maxNumberOfBoardCards && cardDeck.count >= 3 {
            for i in 0...2 {
                boardCards += [cardDeck[i]]
            }
            //Remove from cardDeck
            cardDeck.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: 2)))
        }
        print(boardCards.count)
    }
    
    func doMakeASet(firstCard: Card, secondCard: Card, thirdCard: Card) -> Bool {
        //Make sure that colors are all the same or all different
        let setColor = ((firstCard.color == secondCard.color) && (secondCard.color == thirdCard.color))  ||
            ((firstCard.color != secondCard.color) && (secondCard.color != thirdCard.color) && (firstCard.color != thirdCard.color))
        
        //Make sure that symbols are all the same or all different
        let setSymbol = (firstCard.symbol == secondCard.symbol) && (secondCard.symbol == thirdCard.symbol) ||
            ((firstCard.symbol != secondCard.symbol) && (secondCard.symbol != thirdCard.symbol) && (firstCard.symbol != thirdCard.symbol))
        
        //Make sure that shadings are all the same or all different
        let setShading = (firstCard.shading == secondCard.shading) && (secondCard.shading == thirdCard.shading) ||
            ((firstCard.shading != secondCard.shading) && (secondCard.shading != thirdCard.shading) && (firstCard.shading != thirdCard.shading))
        
        //Make sure that numbers are all the same or all different
        let setNumber = (firstCard.numberOfSymbols == secondCard.numberOfSymbols) && (secondCard.numberOfSymbols == thirdCard.numberOfSymbols) ||
            ((firstCard.numberOfSymbols != secondCard.numberOfSymbols) && (secondCard.numberOfSymbols != thirdCard.numberOfSymbols) && (firstCard.numberOfSymbols != thirdCard.numberOfSymbols))
            
        return setColor && setSymbol && setShading && setNumber
    }
    
    func doIncludeValidSet(cards: [Card]) -> Bool {
        if findPossibleSetAmongCards(cards) != nil {
            return true
        }
        return false
    }
    
    func findPossibleSetAmongCards(_ cards: [Card]) -> [Card]! {
        for firstCard in 0..<cards.count{
            for secondCard in (firstCard + 1)..<cards.count {
                for thirdCard in (secondCard + 1)..<cards.count {
                    let possibleSet = [cards[firstCard], cards[secondCard], cards[thirdCard]]
                    if doMakeASet(firstCard: possibleSet[0], secondCard: possibleSet[1], thirdCard: possibleSet[2]) {
                        return possibleSet
                    }
                }
            }
        }
        return nil
    }
    
    // TODO: Add func to reset game
    func reset() {
        score = 0
        foundSets = 0
        message = " "
        messageStatus = false
        selectedCards = [Card]()
        matchedCards = [Card]()
        boardCards = [Card]()
        //Add 12 cards to boardCards
        for i in 0...11 {
            boardCards += [cardDeck[i]]
        }
        
        //Remove boardCards from cardDeck
        cardDeck.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: 11)))
        cardDeck = shuffleCardDeck()
    }
}
