//import UIKit
//
//class GameViewController: UIViewController {
//    
//    let manager = GameManager.shared
//    var gameSession = GameSession()
//    var cards: [Card] {
//        get {
//            return gameSession.player.getCards()
//        }
//    }
//    var oppCards: [Card]{
//        return gameSession.opponent.getCards()
//    }
//    
//    lazy var myBalance = gameSession.player.getBalance() {
//        didSet {
//            balanceLabel.setNeedsDisplay()
//        }
//    }
//    
//    //MARK: Views
//    lazy var diceView = DiceView(frame: CGRect(x: view.center.x - 30, y: view.center.y - 30, width: 60, height: 60))
//    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = collectionView.superview?.backgroundColor
//        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
//        collectionView.showsHorizontalScrollIndicator = false
//        
//        return collectionView
//    }()
//    
//    lazy var oppCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = collectionView.superview?.backgroundColor
//        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
//        collectionView.showsHorizontalScrollIndicator = false
//        
//        return collectionView
//    }()
//    
//    lazy var throwDiceButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("Throw Dice", for: .normal)
//        btn.backgroundColor = .black
//        btn.setTitleColor(.white, for: .normal)
//        
//        btn.titleLabel?.font = .systemFont(ofSize: 18)
//        btn.layer.cornerRadius = 8
//        
//        btn.isEnabled = false
//        
//        let action = UIAction() { [self] _ in
//            self.diceView.throwDice() { value in
//                self.moveDiceToSide()
//                self.showOptionButtons()
//                self.gameSession.sendDiceValue(value: value)
//                self.gameSession.updateBalanceAfterDiceMove(diceValue: value)
//            }
//            btn.isEnabled = false
//            btn.backgroundColor = .gray
//        }
//        btn.addAction(action, for: .touchUpInside)
//        return btn
//        
//    }()
//    
//    lazy var buyPropertyButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("Buy Property", for: .normal)
//        btn.backgroundColor = .cyan
//        btn.setTitleColor(.black, for: .normal)
//        
//        btn.layer.opacity = 0
//        
//        btn.titleLabel?.font = .systemFont(ofSize: 18)
//        btn.layer.cornerRadius = 8
//        
//        let action = UIAction() { [weak self] _ in
//            self?.buyPropertyTapped()
//        }
//        btn.addAction(action, for: .touchUpInside)
//        return btn
//        
//    }()
//    
//    lazy var skipMoveButton: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("Skip", for: .normal)
//        btn.backgroundColor = .cyan
//        btn.setTitleColor(.black, for: .normal)
//        
//        btn.titleLabel?.font = .systemFont(ofSize: 18)
//        btn.layer.cornerRadius = 8
//        
//        btn.layer.opacity = 0
//        
//        let action = UIAction() { [weak self] _ in
//            self?.hideOptionButtons()
//            self?.moveDiceToCenter()
//        }
//        btn.addAction(action, for: .touchUpInside)
//        
//        return btn
//        
//    }()
//    
//    
//    lazy var balanceLabel: CustomLabel = {
//        let label = CustomLabel()
//        label.text = "Balance: \(gameSession.player.getBalance())"
//        label.textAlignment = .center
//        label.backgroundColor = .black
//        label.textColor = .white
//        label.layer.cornerRadius = 8
//        label.clipsToBounds = true
//        
//        return label
//    }()
//    
//    lazy var opponentBalanceLabel: CustomLabel = {
//        let label = CustomLabel()
//        label.text = "Balance: 2"
//        label.textAlignment = .center
//        label.backgroundColor = .black
//        label.textColor = .white
//        label.layer.cornerRadius = 8
//        label.clipsToBounds = true
//        
//        return label
//    }()
//    
//    lazy var currentMoveView: CustomLabel = {
//        let lbl = CustomLabel()
//        lbl.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
//        lbl.textColor = .black
//        return lbl
//    }()
//    
//    lazy var quitGameButton: CustomButton = {
//        let btn = CustomButton()
//        btn.backgroundColor = .red.withAlphaComponent(0.9)
//        btn.titleLabel?.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
//        btn.setTitleColor(.white, for: .normal)
//        btn.setTitle("Leave Game", for: .normal)
//        let action = UIAction() { _ in
//            self.quitGame()
//        }
//        btn.addAction(action, for: .touchUpInside)
//        
//        return btn
//    }()
//    
//    
//    //MARK: SetupView
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = #colorLiteral(red: 0.9100823998, green: 0.684394896, blue: 0.4622610807, alpha: 1).withAlphaComponent(0.7)
//        navigationItem.hidesBackButton = true
//        self.hidesBottomBarWhenPushed = true
//        
//        self.gameSession.delegate = self
//        
//        
//        if gameSession.player.getID() == "firstID" {
//            beginMove()
//        }
//        
//        setupView()
//    }
//    
//
//    
//    private func setupView() {
//        view.addSubview(collectionView)
//        view.addSubview(oppCollectionView)
//        view.addSubview(throwDiceButton)
//        view.addSubview(balanceLabel)
//        view.addSubview(diceView)
//        view.addSubview(quitGameButton)
//        view.addSubview(currentMoveView)
//        view.addSubview(opponentBalanceLabel)
//        
//        throwDiceButton.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
//            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(24)
//            make.width.equalToSuperview().multipliedBy(0.3)
//        }
//        
//        balanceLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(24)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
//        }
//        
//        collectionView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(12)
//            make.height.equalTo(140)
//            make.bottom.equalTo(throwDiceButton.snp.top).offset(-32)
//        }
//        
//        oppCollectionView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(88)
//            make.leading.trailing.equalToSuperview().inset(12)
//            make.height.equalTo(140)
//        }
//        
//        opponentBalanceLabel.snp.makeConstraints { make in
//            make.top.equalTo(oppCollectionView.snp.bottom).offset(24)
//            make.leading.equalToSuperview().inset(24)
//        }
//        
//        currentMoveView.snp.makeConstraints { make in
//            make.top.equalTo(opponentBalanceLabel.snp.bottom).offset(24)
//            make.leading.trailing.equalToSuperview().inset(24)
//        }
//        
//        quitGameButton.snp.makeConstraints { make in
//            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(12)
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//        }
//
//        
//    }
//}
//
////MARK: CollectionView Layout
//
//extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.collectionView{
//            return cards.count + 2
//        } else {
//            return oppCards.count + 2
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
//        let tmpCards = (collectionView == self.collectionView) ? self.cards : self.oppCards
//        
//        if indexPath.item < tmpCards.count {
//            cell.setupCell(cardName: tmpCards[indexPath.item].image, count: tmpCards[indexPath.item].count)
//            cell.contentView.layer.borderWidth = 0
//        } else {
//            cell.contentView.layer.borderColor = UIColor.black.cgColor
//            cell.contentView.layer.borderWidth = 4
//        }
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 140)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(4)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//
//    
//}
//
//// MARK: UI Change
//extension GameViewController {
//    
//    
//    func showStore() {
//        let storeVc = StoreViewController()
//        storeVc.cardStore = self.gameSession.cardStoreSecond
//        storeVc.modalPresentationStyle = .popover
//        self.present(storeVc, animated: true)
//    }
//    
//    func moveDiceToSide() {
//        UIView.animate(withDuration: 1.0) {
//            self.diceView.frame = CGRect(x: 10, y: self.view.center.y - 30, width: 60, height: 60)
//        }
//    }
//    
//    private func showOptionButtons() {
//        view.addSubview(skipMoveButton)
//        view.addSubview(buyPropertyButton)
//        buyPropertyButton.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(140)
//            make.height.equalTo(60)
//        }
//        skipMoveButton.snp.makeConstraints { make in
//            make.top.equalTo(buyPropertyButton.snp.bottom).offset(8)
//            make.centerX.equalToSuperview()
//            make.width.equalTo(140)
//            make.height.equalTo(60)
//        }
//        UIView.animate(withDuration: 0.5) {
//            self.buyPropertyButton.layer.opacity = 1.0
//            self.skipMoveButton.layer.opacity = 1.0
//        }
//    }
//    
//    private func hideOptionButtons() {
//        UIView.animate(withDuration: 0.5) {
//            self.buyPropertyButton.layer.opacity = 0.0
//            self.skipMoveButton.layer.opacity = 0.0
//        } completion: { finished in
//            self.buyPropertyButton.removeFromSuperview()
//            self.skipMoveButton.removeFromSuperview()
//        }
//    }
//    
//    private func moveDiceToCenter() {
//        UIView.animate(withDuration: 1.0) {
//            self.diceView.frame = CGRect(x: self.view.center.x - 30, y: self.view.center.y - 30, width: 60, height: 60)
//        }
//    }
//    
//    private func endMoveAnimation() {
//        hideOptionButtons()
//        moveDiceToCenter()
//        throwDiceButton.backgroundColor = .gray
//        currentMoveView.text = "Opponent's turn!"
//    }
//    
//    
//    //MARK: Actions
//    
//    func beginMove() {
//        throwDiceButton.isEnabled = true
//        throwDiceButton.backgroundColor = .black
//        currentMoveView.text = "Your turn!"
//    }
//    
//    private func buyPropertyTapped() {
//        let storeVC = StoreViewController()
//        storeVC.cardStore = self.gameSession.cardStoreSecond
//        storeVC.balance = self.gameSession.player.getBalance()
//        storeVC.modalPresentationStyle = .fullScreen
//        
//        storeVC.completion = { cardName in
//            self.gameSession.player.addCard(cardName)
//            self.collectionView.reloadData()
//            self.endMoveAction()
//        }
//        self.present(storeVC, animated: true)
//    }
//    
//    private func endMoveAction() {
//        endMoveAnimation()
//        gameSession.endMove()
//    }
//    
//    private func quitGame() {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//}
//
//extension GameViewController: MatchManagerDelegate {
//    func updateDiceView(value: Int) {
//        self.diceView.animateDiceThrow(value: value) { value in
//            self.moveDiceToSide()
//            self.gameSession.updateBalance(diceValue: value)
//        }
//    }
//    
//    func updateBalanceView() {
//        self.balanceLabel.text = "Balance: \(gameSession.player.getBalance())"
//        self.opponentBalanceLabel.text = "Balance: \(gameSession.opponent.getBalance())"
//    }
//    
//    func updateOpponentCardsView() {
//        self.oppCollectionView.reloadData()
//    }
//    
//    
//}
