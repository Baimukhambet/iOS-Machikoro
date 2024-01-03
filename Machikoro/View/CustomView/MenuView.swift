//
//  MenuView.swift
//  Machikoro
//
//  Created by Timur Baimukhambet on 18.12.2023.
//

import UIKit

class MenuView: UIView {
    
    var quitTapped: (()->())?

    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.02110454626, green: 0.6728824973, blue: 0.8532800078, alpha: 1)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var quitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Quit Game", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.backgroundColor = .red
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 8
        
        btn.addAction(UIAction { _ in self.quitTapped!()}, for: .touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(quitButton)
        quitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(50)
        }
    }
    
}
