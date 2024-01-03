//
//  CustomViews.swift
//  Machikoro
//
//  Created by Timur Baimukhambet on 27.11.2023.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: 12 + size.width, height: 12 + size.height)
    }
    
//    override func draw(_ rect: CGRect) {
//        let insets = UIEdgeInsets(top: 64, left: 12, bottom: 12, right: 12)
//        super.draw(rect.inset(by: insets))
//    }
    
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
