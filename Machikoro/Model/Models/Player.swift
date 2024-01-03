import Foundation

struct PlayerStruct {
    var name: String
    var balance: Int
    var buildings: [String : Int]
}

extension PlayerStruct {
    var dictionaryRepresentation: [String: Any] {
        return [
            "name": name,
            "balance": balance,
            "buildings": buildings
        ]
    }
}

final class Player: Codable {
    private var id: String
    private var name: String = "Player"
    private var cards: [Card] = [
        Card(title: "bakery", type: .green, cost: 1, income: 1, diceValue: 2.5, image: "pechka", count: 1),
        Card(title: "field", type: .blue, cost: 1, income: 1, diceValue: 1, image: "pole", count: 1),
    ]
    private var balance: Int = 2
    
    init(id: String) {
        self.id = id
    }
    
    init(id: String, cards: [Card], balance: Int) {
        self.id = id
        self.cards = cards
        self.balance = balance
    }
    
    init(id: String, name: String, cards: [Card], balance: Int) {
        self.id = id
        self.name = name
        self.cards = cards
        self.balance = balance
    }
    
    
    func getID() -> String {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func addCard(card: Card?) {
        guard let card = card else { return }
        if self.cards.contains(card) {
            self.cards[cards.firstIndex(of: card)!].count += 1
        } else {
            self.cards.append(card)
        }
    }
    
    func getCards() -> [Card] {
        return self.cards
    }
    
    func getBalance() -> Int {
        return self.balance
    }
    
    func updateBalance(income: Int) {
        self.balance += income
    }
}
