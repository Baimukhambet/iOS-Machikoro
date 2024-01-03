import UIKit

@MainActor final class GameView: UIView {
    
    var controller: GameControllerProtocol
    var isMenuShown = false
    
    init(controller: GameControllerProtocol) {
        self.controller = controller
        super.init(frame: .zero)
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Views
    
    lazy var bgImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "bg-bg")
        return view
    }()
    
    lazy var menuView: MenuView = {
        let view = MenuView(frame: CGRect(x: 38, y: safeAreaInsets.top, width: self.bounds.width / 2, height: self.bounds.height / 7))
        view.quitTapped = {[weak self] in self?.controller.quitGameTapped()}
        
        return view
    }()
    
    lazy var boardView: UIView = {
        let view = UIView()
        let circleView = CircleView()
        view.addSubview(circleView)
        
        circleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.clipsToBounds = true
        return view
    }()


    
    lazy var playerDeckView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9373076558, green: 0.9788979888, blue: 0.9526409507, alpha: 1)
        return view
    }()
    
    lazy var playerLabelView: PlayerLabelView = {
        let view = PlayerLabelView()
        return view
    }()
    
    lazy var opponentLabelView = PlayerLabelView()
    
    lazy var cardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
        view.dataSource = controller
        view.delegate = controller
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    lazy var opponentCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
        view.dataSource = controller
        view.delegate = controller
        view.showsHorizontalScrollIndicator = false
        view.transform = CGAffineTransform(scaleX: -1, y: -1)
        
        return view
    }()
    
    lazy var keyCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = false
        view.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
        view.dataSource = controller
        view.delegate = controller
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var opponentKeyCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = false
        view.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
        view.dataSource = controller
        view.delegate = controller
        view.backgroundColor = .clear
        view.transform = CGAffineTransform(scaleX: -1, y: -1)
        
        return view
    }()
    
    lazy var incomeUpdatePopUpView: SecondStrokeLabel = {
        let lbl = SecondStrokeLabel(strokeSize: 6, strokeColor: UIColor(red: 236/255, green: 255/255, blue: 253/255, alpha: 1.0))
        lbl.font = .systemFont(ofSize: 36, weight: .bold)
        lbl.textColor = UIColor(red: 10/255, green: 169/255, blue: 210/255, alpha: 1.0)
        lbl.textAlignment = .center
        lbl.alpha = 0.0
        return lbl
    }()
    
    lazy var diceView: DiceView = {
        let diceView = DiceView()
        diceView.alpha = 0.0
        return diceView
    }()
    
    private func createCurrentMoveLabel() -> SecondStrokeLabel {
        let lbl = SecondStrokeLabel(strokeSize: 6, strokeColor: UIColor(red: 236/255, green: 255/255, blue: 253/255, alpha: 1.0))
        lbl.font = .systemFont(ofSize: 36, weight: .bold)
        lbl.textColor = UIColor(red: 10/255, green: 169/255, blue: 210/255, alpha: 1.0)
        lbl.textAlignment = .center
        return lbl
    }
    
    //MARK: BUTTONS
    
    lazy var menuButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "list.star")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.02110454626, green: 0.6728824973, blue: 0.8532800078, alpha: 1)
        btn.layer.borderWidth = 4
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 30
        
        let action = UIAction { _ in
            if !self.isMenuShown {
                self.menuView.alpha = 0.0
                self.addSubview(self.menuView)
                self.bringSubviewToFront(btn)
                UIView.animate(withDuration: 0.3) {
                    self.menuView.alpha = 1.0
                } completion: { finished in
                    self.isMenuShown = true
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.menuView.alpha = 0.0
                } completion: { finished in
                    self.menuView.removeFromSuperview()
                    self.isMenuShown = false
                }
                
            }
        }
        btn.addAction(action, for: .touchUpInside)
        
        return btn
    }()
    
    lazy var throwDiceButton: UIButton = {
        let btn = UIButton(configuration: .bordered())
        btn.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 93/255, alpha: 1.0)
        btn.layer.borderColor = UIColor(red: 246/255, green: 179/255, blue: 9/255, alpha: 1.0).cgColor
        btn.layer.borderWidth = 4
        
        btn.addAction(UIAction { _ in self.throwDiceTapped()}, for: .touchUpInside)
        
        var container = AttributeContainer()
        container.foregroundColor = .black
        
        btn.setTitle("Throw Dice", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        return btn
    }()
    
    
    
    //MARK: Setup Views
    
    private func setupView() {
        setupBoardView()
        setupDeckView()
        setupOpponentKeyCardsCollectionView()
        setupMenuButton()
        setupOpponentLabelView()
    }
    
    private func setupMenuButton() {
        addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(8)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.width.height.equalTo(60)
        }
    }
    
    private func setupBoardView() {
        addSubview(bgImage)
        bgImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(boardView)
        boardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.4)
            make.height.equalTo(self.snp.width).multipliedBy(1.5)
        }
        setupOpponentCardCollectionView()
    }
    
    private func setupDeckView() {
        addSubview(playerDeckView)
        playerDeckView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        setupPlayerLabelView()
        setupCardCollectionView()
        setupKeyCardsCollectionView()
    }
    
    private func setupPlayerLabelView() {
        playerDeckView.addSubview(playerLabelView)
        playerLabelView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setupOpponentLabelView() {
        addSubview(opponentLabelView)
        opponentLabelView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(self.boardView.snp.top).offset(-4)
            make.width.equalToSuperview().multipliedBy(0.3)
            
        }
    }
    
    private func setupCardCollectionView() {
        playerDeckView.addSubview(cardCollectionView)
        cardCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(playerLabelView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupKeyCardsCollectionView() {
        addSubview(keyCardsCollectionView)
        keyCardsCollectionView.snp.makeConstraints { make in
            make.bottom.equalTo(playerDeckView.snp.top).offset(-14)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(14)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-14)
            make.height.equalTo(120)
        }
    }
    
    private func setupOpponentCardCollectionView() {
        addSubview(opponentCardCollectionView)
        
        opponentCardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(boardView.snp.top).inset(UIApplication.windowSize.width / 5.6)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(UIApplication.windowSize.width / 6)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(UIApplication.windowSize.width / 6)
            make.height.equalTo(UIApplication.windowSize.height * 0.1)
        }
    }
    
    private func setupOpponentKeyCardsCollectionView() {
        boardView.addSubview(opponentKeyCardsCollectionView)
        opponentKeyCardsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(opponentCardCollectionView.snp.bottom).offset(14)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(14)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-14)
            make.height.equalTo(120)
        }
    }
    
    //MARK: Actions
    private func throwDiceTapped() {
        throwDiceButton.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showDice()
            self.diceView.throwDice { value in
                print("You got \(value)")
                self.controller.sendDiceValue(value: value)
            }
        }
    }
    
    //MARK: Animations
    
    func showCurrentMoveLabel(text: String, completion: @escaping () -> ()) {
        let currentMovePopUp = createCurrentMoveLabel()
        
        currentMovePopUp.frame = CGRect(x: self.bounds.width + 100, y: self.center.y, width: self.bounds.width, height: 60)
        currentMovePopUp.text = text
        self.addSubview(currentMovePopUp)
        
        UIView.animate(withDuration: 1.0, delay: 0.0,  options: [.curveEaseIn]) { [self] in
            currentMovePopUp.frame = CGRect(x: 0, y: self.center.y, width: self.bounds.width, height: 60)
        } completion: { finished in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 1.0) { [self] in
                    currentMovePopUp.frame = CGRect(x: CGFloat(Int(-self.bounds.width)), y: self.center.y, width: self.bounds.width, height: 60)
                } completion: { finished in
                    currentMovePopUp.removeFromSuperview()
                    completion()
                }
            }
        }
    }
    
    func showDiceButton() {
        addSubview(throwDiceButton)
        throwDiceButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(90)
        }
    }
    
    func showDice() {
        diceView.frame = CGRect(x: self.center.x - 30, y: self.center.y - 30, width: 60, height: 60)
        addSubview(diceView)
        UIView.animate(withDuration: 1.0) {
            self.diceView.alpha = 1.0
        }
    }
    
    func hideDice() {
        UIView.animate(withDuration: 1.0) {
            self.diceView.alpha = 0.0
        } completion: { finished in
            self.diceView.removeFromSuperview()
        }
    }
    
    func animateDice(value: Int) {
        diceView.animateDiceThrow(value: value) { value in
            //
        }
    }
    
    func showIncomeUpdates(incomes: [Int], completion: @escaping () -> ()) {
        incomeUpdatePopUpView.frame = CGRect(x: 0, y: self.center.y - 40, width: self.bounds.width, height: 80)
        addSubview(incomeUpdatePopUpView)
        incomeUpdatePopUpView.text = "You get \(incomes.first!) coins!"
        UIView.animate(withDuration: 1.0) {
            self.incomeUpdatePopUpView.alpha = 1.0
        } completion: { finished in
            UIView.animate(withDuration: 1.0) {
                self.incomeUpdatePopUpView.alpha = 0.0
            } completion: { finished in
                self.incomeUpdatePopUpView.text = "Opponent gets \(incomes.last!) coins"
                UIView.animate(withDuration: 1.0){
                    self.incomeUpdatePopUpView.alpha = 1.0
                } completion: { finished in
                    UIView.animate(withDuration: 1.0) {
                        self.incomeUpdatePopUpView.alpha = 0.0
                    } completion: { finished in
                        self.incomeUpdatePopUpView.removeFromSuperview()
                        completion()
                    }
                }
            }
        }
    }
    
    func updateBalanceLabels(playerBalance: Int, opponentBalance: Int) {
        playerLabelView.balanceLabel.text = "\(playerBalance)"
        opponentLabelView.balanceLabel.text = "\(opponentBalance)"
    }
    
    func endGamePopUp(winnerName: String) {
        incomeUpdatePopUpView.frame = CGRect(x: 0, y: self.center.y - 40, width: self.bounds.width, height: 80)
        self.incomeUpdatePopUpView.alpha = 1.0
        incomeUpdatePopUpView.text = "\(winnerName) won!"
        addSubview(incomeUpdatePopUpView)
    }
    
}
