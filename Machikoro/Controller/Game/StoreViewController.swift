//
//  StoreViewController.swift
//  Machikoro
//
//  Created by Timur Baimukhambet on 27.11.2023.
//

import UIKit

class StoreViewController: UIViewController {
    //MARK: Properties
    var cardStore: CardStore
    var playerKeyCards: [Card]
    var completion: ((String?) -> ())?
    var selectedCardIndex: Int?
    var balance: Int
    
    //MARK: Views
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCell")
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(red: 235/255, green: 170/255, blue: 73/255, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var backView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.alpha = 0.0
        
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.alpha = 0.0
        view.backgroundColor = UIColor(red: 185/255, green: 115/255, blue: 65/255, alpha: 1.0)
        
        return view
    }()
    
    lazy var selectedCardView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.layer.cornerRadius = 8
        imgView.clipsToBounds = true
        imgView.dropShadow()
        return imgView
    }()
    
    lazy var buyButton: UIButton = {
        let btn = UIButton(configuration: .bordered())
        btn.setTitle("Buy", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(UIColor(red: 54/255, green: 170/255, blue: 171/255, alpha: 1.0), for: .normal)
        
        btn.addAction(UIAction {_ in self.buyButtonTapped()}, for: .touchUpInside)
        
        return btn
    }()
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton(configuration: .bordered())
        btn.setTitle("Cancel", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(UIColor(red: 54/255, green: 170/255, blue: 171/255, alpha: 1.0), for: .normal)
        
        btn.addAction(UIAction {_ in self.cancelButtonTapped()}, for: .touchUpInside)
        
        return btn
    }()
    
    init(cardStore: CardStore, playerKeyCards: [Card], balance: Int) {
        self.cardStore = cardStore
        self.playerKeyCards = playerKeyCards
        self.balance = balance
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSelectedCardView()
        setupCollectionView()
        setupBuyButton()
        setupCancelButton()
    }
    
    //MARK: Setup Views
    
    private func setupView() {
        self.view.backgroundColor = .clear
        
        self.view.addSubview(backView)
        self.view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    private func setupSelectedCardView() {
        contentView.addSubview(selectedCardView)
        selectedCardView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(12)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    private func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(12)
            make.trailing.equalTo(selectedCardView.snp.leading).offset(-12)

        }
    }
    
    private func setupBuyButton() {
        contentView.addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(selectedCardView.snp.bottom).offset(16)
            make.leading.equalTo(collectionView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    private func setupCancelButton() {
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(buyButton.snp.bottom).offset(16)
            make.leading.equalTo(collectionView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    //MARK: Appear
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false)
        self.show()
    }
    
    func show() {
        UIView.animate(withDuration: 2.0) {
            self.backView.alpha = 1.0
            self.contentView.alpha = 1.0
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut]) {
            self.backView.alpha = 0.0
            self.contentView.alpha = 0.0
        } completion: { finished in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    //MARK: Actions
    
    private func buyButtonTapped() {
        guard let index = selectedCardIndex else { return }
        if cardStore.cards[index].cost > balance || cardStore.cards[index].count < 1 || (cardStore.cards[index].type == .enterprise && playerKeyCards.contains(cardStore.cards[index])){
            return
        }
        completion!(cardStore.cards[index].title)
        cardStore.cards[index].count -= 1
        
        self.hide()
    }
    
    private func cancelButtonTapped() {
        completion!(nil)
        self.hide()
    }
}

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardStore.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        cell.setupCell(cardName: cardStore.cards[indexPath.item].image, count: cardStore.cards[indexPath.item].count)
        if balance < cardStore.cards[indexPath.item].cost || cardStore.cards[indexPath.item].count < 1 || (cardStore.cards[indexPath.item].type == .enterprise && playerKeyCards.contains(cardStore.cards[indexPath.item])){
            cell.dimCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = UIImage(named: cardStore.cards[indexPath.item].image)
        selectedCardView.image = image
        selectedCardIndex = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let colSize = collectionView.bounds
        return CGSize(width: colSize.width / 3, height: colSize.height * 0.3)
    }
}
