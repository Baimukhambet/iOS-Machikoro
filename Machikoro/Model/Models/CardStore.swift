//
//  CardStore.swift
//  Machikoro
//
//  Created by Timur Baimukhambet on 13.12.2023.
//

import Foundation

class CardStore {
    var cards: [Card]
    
    init() {
        self.cards = [
            Card(title: "vokzal", type: .enterprise, cost: 4, income: 0, diceValue: 0, image: "vokzal", count: 2),
            Card(title: "radiohead", type: .enterprise, cost: 16, income: 0, diceValue: 0, image: "radiohead", count: 2),
            Card(title: "park", type: .enterprise, cost: 22, income: 0, diceValue: 0, image: "park", count: 2),
            Card(title: "mall", type: .enterprise, cost: 10, income: 0, diceValue: 0, image: "mall", count: 2),
            Card(title: "bakery", type: .green, cost: 1, income: 1, diceValue: 2.5, image: "pechka", count: 6),
            Card(title: "field", type: .blue, cost: 1, income: 1, diceValue: 1, image: "pole", count: 6),
            Card(title: "apple-garden", type: .green, cost: 3, income: 3, diceValue: 10, image: "apple-garden", count: 6),
            Card(title: "cheese", type: .blue, cost: 5, income: 3, diceValue: 7, image: "cheese", count: 6),
            Card(title: "cvetnik", type: .green, cost: 2, income: 1, diceValue: 4, image: "cvetnik", count: 6),
            Card(title: "farm", type: .blue, cost: 1, income: 1, diceValue: 2, image: "farm", count: 6),
            Card(title: "flower-shop", type: .green, cost: 1, income: 1, diceValue: 6, image: "flower-shop", count: 6),
            Card(title: "ovoshi", type: .blue, cost: 2, income: 2, diceValue: 11.5, image: "ovoshi", count: 6),
            Card(title: "rudnik", type: .blue, cost: 6, income: 5, diceValue: 9, image: "rudnik", count: 6),
            Card(title: "supermarket", type: .green, cost: 2, income: 3, diceValue: 4, image: "supermarket", count: 6),
            Card(title: "vinograd", type: .blue, cost: 3, income: 3, diceValue: 7, image: "vinograd", count: 6),
            Card(title: "zapovednik", type: .blue, cost: 3, income: 1, diceValue: 5, image: "zapovednik", count: 6),
        ]
    }
    
    func sellCard(cardName: String) {
        guard let card = Card.createCard(title: cardName) else {return}
        if let cardIndex = self.cards.firstIndex(of: card) {
            cards[cardIndex].count -= 1
        }
    }
}
