//
//  AlertViewController.swift
//  Machikoro
//
//  Created by Timur Baimukhambet on 04.12.2023.
//

import UIKit

class AlertViewController: UIViewController {
    
//    lazy var alertView = AlertView(frame: CGRect(x: view.center.x, y: view.center.y, width: 200, height: 280), message: "")
    
    var message: String
    
    lazy var messageLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 10, y: 40, width: 230, height: 40))
        lbl.textColor = .black
        lbl.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        lbl.text = message
        
        return lbl
    }()
    
    lazy var backgroundView: UIView = {
        let uiView = UIView(frame: CGRect(origin: CGPoint(x: view.center.x - 120, y: view.center.y - 60), size: CGSize(width: 240, height: 120)))
        uiView.backgroundColor = .gray.withAlphaComponent(0.8)
        uiView.layer.cornerRadius = 16

        return uiView
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Tap", for: .normal)
        let action = UIAction { _ in
            print("Button tapped")
            self.dismiss(animated: true)
        }
        btn.backgroundColor = .red
        btn.addAction(action, for: .touchUpInside)
        
        return btn
    }()
    
    
    
    // init
    init(message: String) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.definesPresentationContext = true
        view.addSubview(backgroundView)
        
        addGR()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        backgroundView.addSubview(messageLabel)
        backgroundView.addSubview(btn)
        
        btn.frame = CGRect(x: 10, y: 40, width: 100, height: 40)
    }
    
    private func addGR() {
        backgroundView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(tappedOnView)))
        backgroundView.isUserInteractionEnabled = true
    }
    
    @objc func tappedOnView() {
        print("tapped")
        self.dismiss(animated: true)
    }
    



}
