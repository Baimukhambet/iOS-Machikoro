import Foundation
import UIKit

enum CardType: String, Codable{
    case blue = "blue"
    case green = "green"
    case purple = "purple"
    case enterprise = "enterprise"
}

class Card: NSObject, Codable {
    override func isEqual(_ object: Any?) -> Bool {
        let card = object as! Card
        return self.title == card.title
    }
    
    var title: String
    var type: CardType
    var cost: Int
    var income: Int
    var diceValue: Float
    var image: String
    var count: Int
    
    init(title: String, type: CardType, cost: Int, income: Int, diceValue: Float, image: String, count: Int) {
        self.title = title
        self.type = type
        self.cost = cost
        self.income = income
        self.diceValue = diceValue
        self.image = image
        self.count = count
    }
    
    
    //Create card by its title:
    static func createCard(title: String) -> Card? {
        switch title{
        case "bakery":
            return Card(title: "bakery", type: .green, cost: 1, income: 1, diceValue: 2.5, image: "pechka", count: 1)
        case "field":
            return Card(title: "field", type: .blue, cost: 1, income: 1, diceValue: 1, image: "pole", count: 1)
        case "apple-garden":
            return Card(title: "apple-garden", type: .green, cost: 3, income: 3, diceValue: 10, image: "apple-garden", count: 1)
        case "cheese":
            return Card(title: "cheese", type: .blue, cost: 5, income: 3, diceValue: 7, image: "cheese", count: 1)
        case "cvetnik":
            return Card(title: "cvetnik", type: .green, cost: 2, income: 1, diceValue: 4, image: "cvetnik", count: 1)
        case "farm":
            return Card(title: "farm", type: .blue, cost: 1, income: 1, diceValue: 2, image: "farm", count: 1)
        case "flower-shop":
            return Card(title: "flower-shop", type: .green, cost: 1, income: 1, diceValue: 6, image: "flower-shop", count: 1)
        case "ovoshi":
            return Card(title: "ovoshi", type: .blue, cost: 2, income: 2, diceValue: 11.5, image: "ovoshi", count: 1)
        case "vokzal":
            return Card(title: "vokzal", type: .enterprise, cost: 4, income: 0, diceValue: 0, image: "vokzal", count: 1)
        case "radiohead":
            return Card(title: "radiohead", type: .enterprise, cost: 16, income: 0, diceValue: 0, image: "radiohead", count: 1)
        case "park":
            return Card(title: "park", type: .enterprise, cost: 22, income: 0, diceValue: 0, image: "park", count: 1)
        case "mall":
            return Card(title: "mall", type: .enterprise, cost: 10, income: 0, diceValue: 0, image: "mall", count: 1)
        case "vinograd":
            return Card(title: "vinograd", type: .blue, cost: 3, income: 3, diceValue: 7, image: "vinograd", count: 1)
        case "zapovednik":
            return Card(title: "zapovednik", type: .blue, cost: 3, income: 1, diceValue: 5, image: "zapovednik", count: 1)
        case "rudnik":
            return Card(title: "rudnik", type: .blue, cost: 6, income: 5, diceValue: 9, image: "rudnik", count: 1)
        case "supermarket":
            return Card(title: "supermarket", type: .green, cost: 2, income: 3, diceValue: 4, image: "supermarket", count: 1)
        default:
            return nil
            
        }
    }
    
    override func copy() -> Any {
        let card = Card(title: title, type: type, cost: cost, income: income, diceValue: diceValue, image: image, count: 1)
        return card
    }
}

