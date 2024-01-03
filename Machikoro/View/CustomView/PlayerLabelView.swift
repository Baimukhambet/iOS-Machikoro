//
//  PlayerLabelView.swift
//  Machikoro
//
//  Created by Timur Baimukhambet on 13.12.2023.
//

import UIKit

class PlayerLabelView: UIView {

    lazy var balanceLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.text = "8"
        return view
    }()
    
    lazy var coinImageView: UIImageView = {
        let image = UIImage(named: "coin")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.image = image
        view.clipsToBounds = true
        return view
    }()
    
    lazy var balanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.addSubview(coinImageView)
        view.addSubview(balanceLabel)
        
        coinImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(6)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(6)
            make.leading.equalTo(coinImageView.snp.trailing).offset(4)
        }
        
        return view
    }()
    
    lazy var playerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).withAlphaComponent(0.7)
        label.textAlignment = .center
        
        label.text = "Your name"
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        self.layer.cornerRadius = 8
        self.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        self.layer.borderWidth = 5
        self.clipsToBounds = true
        
        addSubview(balanceView)
        addSubview(playerNameLabel)
        balanceView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(6)
            make.height.equalTo(32)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        playerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
    }
    
}
