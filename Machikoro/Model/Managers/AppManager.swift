import Foundation
import Firebase

class GameManager {
    static let shared = GameManager()
    let ref = Database.database().reference()
    weak var createRoomController: CreateRoomController?
    weak var joinRoomController: JoinRoomController?
    
    private init() {}
    //Create Room and its ID
    func createNewGame(completion: @escaping (GameSession) -> ()) {
        let dispatchGroup = DispatchGroup()
        
        let roomKey = ref.child("Rooms").childByAutoId().key!
        let playerKey = ref.child("Rooms/\(roomKey)/Players/)").childByAutoId().key!
        let player = Player(id: playerKey)
        var opponent: Player?
        
        ref.child("Rooms/\(roomKey)/Players/\(playerKey)").setValue(1)
        
        createRoomController!.codeView.text = roomKey
        
        dispatchGroup.enter()
        
        ref.child("Rooms/\(roomKey)/Players/").observe(.childAdded) { snapshot in
            if snapshot.key != playerKey {
                print("Found OpponentID: \(snapshot.key)")
                opponent = Player(id: snapshot.key)
                dispatchGroup.leave()
            }
        }
        
        
        dispatchGroup.notify(queue: .main) {
            let gameSession = GameSession(player: player, opponent: opponent!, roomID: roomKey, currentMove: playerKey)
            completion(gameSession)
        }
    }
    
    
    
    //JOIN ROOM BY ID
    func joinRoom(roomKey: String, completion: @escaping (GameSession?) -> ()) {
        ref.child("Rooms/\(roomKey)").observeSingleEvent(of: .value) {[self] snapshot in
            if !snapshot.exists() {
                print("no su hc romm")
                completion(nil)
                return
            } else {
                let dispatchGroup = DispatchGroup()
                let playerKey = ref.child("Rooms/\(roomKey)/Players/").childByAutoId().key!
                let player = Player(id: playerKey)
                var opponent: Player?
                var opponentKey = ""
                dispatchGroup.enter()
                
                fetchOpponentKey(roomKey: roomKey, selfKey: playerKey) { oppKey in
                    opponent = Player(id: oppKey)
                    opponentKey = oppKey
                    dispatchGroup.leave()
                }
                
                ref.child("Rooms/\(roomKey)/Players/\(String(describing: playerKey))").setValue(1)
                
                dispatchGroup.notify(queue: .main) {
                    let gameSession = GameSession(player: player, opponent: opponent!, roomID: roomKey, currentMove: opponentKey)
                    completion(gameSession)
                }
            }
        }
        

        
        
    }
    
    private func fetchOpponentKey(roomKey: String, selfKey: String, completion: @escaping (String) -> ()) {
        var opponentKey = "NIL"
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        ref.child("Rooms/\(roomKey)/Players/").observeSingleEvent(of: .value) { snapshot in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                if snap.key != selfKey{
                    opponentKey = snap.key
                }
            }
            
            dispatchGroup.leave()
        }
//        observing = ()
        
        dispatchGroup.notify(queue: .global(qos: .userInteractive)) {
            completion(opponentKey)
        }
        
        
    }
    
    
}


//MARK: Responsibility
/*
 1. Create room
 2. Create session
 3. Assign value to game session
 4. GameSession() is responsible for the game's flow!
 */
