import Foundation
import Firebase

protocol MatchManagerDelegate: AnyObject {
    func beginMove()
    
    func updateDiceView(value: Int)
    func updateBalanceView()
    func updateOpponentCardsView()
    
    func endMove()
}

final class GameSession {
    let ref = Database.database().reference()
    var player: Player
    var opponent: Player
    var roomID: String
    var cardStore = CardStore()
    var currentMove: String
    weak var delegate: MatchManagerDelegate?
    
    init() {
        player = Player(id: "")
        opponent = Player(id: "")
        roomID = ""
        currentMove = ""
    }
    
    init(player: Player, opponent: Player, roomID: String, currentMove: String) {
        self.player = player
        self.opponent = opponent
        self.roomID = roomID
        self.currentMove = currentMove
        observeDiceValue()
        observeBoughtCard()
        observeMyMove()
        observeWinner()
    }

    func beginGame() {
        ref.child("Rooms/\(roomID)/").child("gameStarted").setValue(true)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5){ [self] in
            ref.child("Rooms/\(roomID)/").child("current_move").setValue(player.getID())
        }
    }
    
    
    //MARK: OBSERVE
    private func observeDiceValue() {
        ref.child("Rooms/\(roomID)/dice_move").observe(.value) { [self] snapshot, sm in
            if let val = snapshot.value as? Int, val != -1 {
                if currentMove == opponent.getID() {                    
                    NotificationCenter.default.post(name: .diceThrown, object: val)
                    
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                        self.updateBalanceAfterOpponentMove(diceValue: val)
                    }
                }
            }
        }
    }
    
    private func observeBoughtCard() {
        ref.child("Rooms/\(roomID)/cardMove").observe(.value) { [self] snapshot in
            if self.currentMove == self.opponent.getID(), let value = snapshot.value as? String {
                guard let card = Card.createCard(title: value) else { return }
                opponent.addCard(card: card)
                opponent.updateBalance(income: -(card.cost))
                
                cardStore.sellCard(cardName: card.title)
                
                NotificationCenter.default.post(name: .cardBought, object: card.title)
            }
        }
    }
    
    private func observeMyMove() {
        ref.child("Rooms/\(roomID)/current_move").observe(.value) {snapshot in
            if let value = snapshot.value as? String {
                if value == self.player.getID() {
                    self.currentMove = self.player.getID()
                    
                    NotificationCenter.default.post(name: .moveBegan, object: nil)
                }
            }
        }
    }
    
    private func observeWinner() {
        ref.child("Rooms/\(roomID)/winner").observe(.value) {snapshot in
            if let value = snapshot.value as? String {
                NotificationCenter.default.post(name: .playerWon, object: value)
            }
        }
    }
    
    //MARK: Actions
    private func beginMove() {
        delegate?.beginMove()
    }
    
    func sendDiceValue(value: Int) {
        ref.child("Rooms/\(roomID)/dice_move").setValue(value)
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0){
            self.ref.child("Rooms/\(self.roomID)/dice_move").setValue(-1)
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            self.updateBalanceAfterDiceMove(diceValue: value)
        }
        
        
    }
    
    func updateBalanceAfterDiceMove(diceValue: Int) {
        var playerIncome = 0
        var opponentIncome = 0
        for card in player.getCards() {
            if diceValue == Int(floor(card.diceValue)) || diceValue == Int(ceil(card.diceValue)) {
                playerIncome += card.income * card.count
            }
        }
        for card in opponent.getCards() {
            if card.type == .blue && (diceValue == Int(floor(card.diceValue)) || diceValue == Int(ceil(card.diceValue))) {
                opponentIncome += card.income * card.count
            }
        }
        player.updateBalance(income: playerIncome)
        opponent.updateBalance(income: opponentIncome)
        
        NotificationCenter.default.post(name: .balanceUpdated, object: [playerIncome, opponentIncome])
    }
    
    func updateBalanceAfterOpponentMove(diceValue: Int) {
        var playerIncome = 0
        var opponentIncome = 0
        for card in player.getCards() {
            if card.type == .blue && (diceValue == Int(floor(card.diceValue)) || diceValue == Int(ceil(card.diceValue))) {
                playerIncome += card.income * card.count
            }
        }
        for card in opponent.getCards() {
            if diceValue == Int(floor(card.diceValue)) || diceValue == Int(ceil(card.diceValue)) {
                opponentIncome += card.income * card.count
            }
        }
        
        player.updateBalance(income: playerIncome)
        opponent.updateBalance(income: opponentIncome)
        
        NotificationCenter.default.post(name: .balanceUpdated, object: [playerIncome, opponentIncome])
    }
    
    func sendBoughtCard(title: String) {
        ref.child("Rooms/\(roomID)/cardMove").setValue(title)
        if let card = Card.createCard(title: title) {
            self.player.updateBalance(income: -(card.cost))
            
            if self.player.getCards().filter({ $0.type == .enterprise}).count == 4 {
//                NotificationCenter.default.post(name: .playerWon, object: nil)
                sendWinnerName()
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0){
            self.ref.child("Rooms/\(self.roomID)/cardMove").setValue("")
        }
    }
    
    func sendWinnerName() {
        ref.child("Rooms/\(roomID)/winner").setValue(player.getName())
    }
    

    
    func endMove() {
        DispatchQueue.global().sync {
            ref.child("Rooms/\(roomID)/current_move").setValue(opponent.getID())
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0){
            self.currentMove = self.opponent.getID()
            NotificationCenter.default.post(name: .moveEnded, object: nil)
        }
    }
    
    func quitGame() {
        ref.child("Rooms/\(roomID)/winner").setValue(opponent.getName())
    }
    
    
    
}


/*
 1. Who is making a move now
 2. Send updates about players
 3. Send Dice Result
 4. Observe changes of opponent's information -> update information there
 5. Observe Dice Result
 
 Order of a move:
 1. DICE -> Update dice value on db -> Observe dice value -> change UI
 2. INCOME -> Calculate income of self and opponents || only self -> send to server -> observe and update
 3. PURCHASE -> Buy estate -> update db -> observe 
 
 
 */
