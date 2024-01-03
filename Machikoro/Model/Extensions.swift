import Foundation
import Firebase

extension Dictionary {
    var JSON: Data {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        } catch {
            return Data()
        }
    }
}

extension DataSnapshot {
    var valueToJSON: Data {
        guard let dictionary = value as? [String: Any] else {
            return Data()
        }
        return dictionary.JSON
    }
    
    var listToJSON: Data {
        guard let object = children.allObjects as? [DataSnapshot] else {
            return Data()
        }
        let dictionary: [NSDictionary] = object.compactMap{$0.value as? NSDictionary}
        
        do {
            return try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            return Data()
        }
    }
}

extension UIApplication {
    static let windowSize = (UIApplication.shared.connectedScenes.first as! UIWindowScene).windows.first!.screen.bounds
}


extension Notification.Name {
    static var diceThrown: Notification.Name {
        return .init(rawValue: "Dice.Thrown")
    }
    
    static var cardBought: Notification.Name {
        return .init(rawValue: "Card.Bought")
    }
    
    static var moveBegan: Notification.Name {
        return .init(rawValue: "Move.Began")
    }
    
    static var moveEnded: Notification.Name {
        return .init(rawValue: "Move.Ended")
    }
    
    static var balanceUpdated: Notification.Name {
        return .init(rawValue: "Balance.Updated")
    }
    
    static var playerWon: Notification.Name {
        return .init(rawValue: "Player.Won")
    }
    
    static var opponentWon: Notification.Name {
        return .init(rawValue: "Opponent.Won")
    }
}


extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: self.bounds.width, height: self.bounds.height + 6)
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
