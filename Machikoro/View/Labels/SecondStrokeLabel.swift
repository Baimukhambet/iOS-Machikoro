//
//  SecondStrokeLabel.swift
//  Machikoro
//
//  Created by Timur Baimukhambet on 19.12.2023.
//

import UIKit

@MainActor class SecondStrokeLabel: UILabel {
    var strokeSize: CGFloat
    var strokeColor: UIColor
    
    init(strokeSize: CGFloat, strokeColor: UIColor) {
        self.strokeSize = strokeSize
        self.strokeColor = strokeColor
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let textColor = self.textColor
        context?.setLineWidth(self.strokeSize)
        context?.setLineJoin(CGLineJoin.miter)
        context?.setTextDrawingMode(CGTextDrawingMode.stroke)
        self.textColor = self.strokeColor
        super.drawText(in: rect)
        context?.setTextDrawingMode(.fill)
        self.textColor = textColor
        super.drawText(in: rect)
    }
}
