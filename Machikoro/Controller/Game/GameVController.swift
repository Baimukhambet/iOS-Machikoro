import UIKit

protocol GameControllerProtocol: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func sendDiceValue(value: Int)
    func quitGameTapped()
}


class GameVController: UIViewController {
    
    var session = GameSession()
    var myCards: [Card] {
        return session.player.getCards().filter{$0.type != .enterprise}
    }
    var opponentCards: [Card] {
        return session.opponent.getCards().filter{$0.type != .enterprise}
    }
    var myKeyCards: [Card] {
        return session.player.getCards().filter{$0.type == .enterprise}
    }
    var opponentKeyCards: [Card] {
        return session.opponent.getCards().filter{$0.type == .enterprise}
    }
    
    var cardStore: CardStore {
        return session.cardStore
    }

    weak var mainView: GameView? {return (self.view as! GameView)}
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        addObservers()
        
        mainView?.updateBalanceLabels(playerBalance: session.player.getBalance(), opponentBalance: session.opponent.getBalance())
        mainView?.playerLabelView.playerNameLabel.text = session.player.getName()
        mainView?.opponentLabelView.playerNameLabel.text = session.opponent.getName()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(beginMove), name: .moveBegan, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveEnded), name: .moveEnded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateDice(_:)), name: .diceThrown, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cardBought), name: .cardBought, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(balanceUpdated(_:)), name: .balanceUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameEnded(_:)), name: .playerWon, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameEnded(_:)), name: .opponentWon, object: nil)
    }
    
    override func loadView() {
        self.view = GameView(controller: self)
    }
    
    //MARK: Actions
    
    @objc func beginMove() {
        mainView?.showCurrentMoveLabel(text: "Your Move!", completion: {
            self.mainView?.showDiceButton()
        })
    }
    
    func sendDiceValue(value: Int) {
        session.sendDiceValue(value: value)
    }
    
    private func endMove() {
        session.endMove()
    }
    
    @objc private func moveEnded() {
        DispatchQueue.main.async {
            self.mainView?.showCurrentMoveLabel(text: "Opponent's Move!", completion: {
                //
            })
        }
    }
    
    @objc private func animateDice(_ notification: Notification) {
        let value = notification.object as! Int
        mainView?.showDice()
        mainView?.animateDice(value: value)
    }
    
    @objc private func balanceUpdated(_ notification: Notification) {
        let incomes = notification.object as! [Int]
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.mainView?.showIncomeUpdates(incomes: incomes, completion: {
                self.mainView?.updateBalanceLabels(playerBalance: self.session.player.getBalance(), opponentBalance: self.session.opponent.getBalance())
                if self.session.currentMove == self.session.player.getID() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.showStoreView()
                    }
                }
            })
        }
    }
    
    private func showStoreView() {
        let storeVC = StoreViewController(cardStore: cardStore, playerKeyCards: myKeyCards, balance: session.player.getBalance())
        storeVC.completion = { cardTitle in
            guard let cardTitle = cardTitle else {
                self.endMove()
                return
            }
            let card = Card.createCard(title: cardTitle)
            self.session.player.addCard(card: card)
            self.session.sendBoughtCard(title: cardTitle)
            self.mainView?.updateBalanceLabels(playerBalance: self.session.player.getBalance(), opponentBalance: self.session.opponent.getBalance())
            self.mainView?.cardCollectionView.reloadData()
            self.mainView?.keyCardsCollectionView.reloadData()
            
            self.endMove()
        }
        storeVC.appear(sender: self)
    }
    
    @objc private func cardBought(_ notification: Notification) {
        mainView?.opponentCardCollectionView.reloadData()
        mainView?.opponentKeyCardsCollectionView.reloadData()
        mainView?.updateBalanceLabels(playerBalance: session.player.getBalance(), opponentBalance: session.opponent.getBalance())
    }
    
    @objc private func gameEnded(_ notification: Notification) {
        removeObservers()
        if let winnerName = notification.object as? String {
            mainView?.endGamePopUp(winnerName: winnerName)
        } else {
            mainView?.endGamePopUp(winnerName: "xxx")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .balanceUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: .moveEnded, object: nil)
        NotificationCenter.default.removeObserver(self, name: .diceThrown, object: nil)
        NotificationCenter.default.removeObserver(self, name: .cardBought, object: nil)
        NotificationCenter.default.removeObserver(self, name: .moveBegan, object: nil)
    }
    
    func quitGameTapped() {
        removeObservers()
        session.quitGame()
        navigationController?.popViewController(animated: false)
    }
 
}

extension GameVController: GameControllerProtocol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView?.cardCollectionView {
            return myCards.count
        } else if collectionView == mainView?.opponentCardCollectionView {
            return opponentCards.count
        } else if collectionView == mainView?.keyCardsCollectionView || collectionView == mainView?.opponentKeyCardsCollectionView {
            return 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        if collectionView == mainView?.cardCollectionView {
            cell.setupCell(cardName: myCards[indexPath.item].image, count: myCards[indexPath.item].count)
        } else if collectionView == mainView?.opponentCardCollectionView {
            cell.setupCell(cardName: opponentCards[indexPath.item].image, count: opponentCards[indexPath.item].count)
            cell.counterLabel.font = .systemFont(ofSize: 10)
        } else if collectionView == mainView?.keyCardsCollectionView {
            if myKeyCards.count <= indexPath.item {
                cell.addBorder()
            } else {
                cell.setupKeyCell(cardName: myKeyCards[indexPath.item].image)
            }
        } else if collectionView == mainView?.opponentKeyCardsCollectionView {
            if opponentKeyCards.count <= indexPath.item {
                cell.addBorder()
            } else {
                cell.setupKeyCell(cardName: opponentKeyCards[indexPath.item].image)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainView?.cardCollectionView {
            let colSize = collectionView.bounds
            return CGSize(width: colSize.width * 0.4, height: colSize.height * 0.7)
        } else if collectionView == mainView?.opponentCardCollectionView {
            let colSize = collectionView.bounds
            return CGSize(width: colSize.width * 0.25, height: colSize.height)
        }
        return CGSize(width: 60, height: 90)
    }
}
