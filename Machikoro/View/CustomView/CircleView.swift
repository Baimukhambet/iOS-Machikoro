//
//  CircleView.swift
//  Machikoro
//
//  Created by Timur Baimukhambet on 13.12.2023.
//

import UIKit

class CircleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let _ = UIGraphicsGetCurrentContext() else { return }
        
        UIColor(red: 29/255, green: 173/255, blue: 126/255, alpha: 1.0).setFill()
        
        let centerX = rect.width / 2
        let centerY = rect.height / 2
        
        let radius = min(centerX, centerY)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        
        path.fill()
        
        UIColor(red: 139/255, green: 194/255, blue: 172/255, alpha: 1.0).setStroke()
        
        // Calculate the radius of the inner circle (you can adjust the padding here)
        let innerRadius = radius - 10 // Adjust the padding as needed
        
        // Create a circular path for the inner circle
        let innerPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY),
                                     radius: innerRadius,
                                     startAngle: 0,
                                     endAngle: CGFloat(2 * Double.pi),
                                     clockwise: true)
        
        // Set the line width for the stroke
        innerPath.lineWidth = 14.0 // Adjust the line width as needed
        
        // Stroke the path to create the inner circle
        innerPath.stroke()
        
        UIColor(red: 25/255, green: 110/255, blue: 85/255, alpha: 1.0).setStroke()
        let outerPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY),
                                     radius: radius,
                                     startAngle: 0,
                                     endAngle: CGFloat(2 * Double.pi),
                                     clockwise: true)
        outerPath.lineWidth = 10
        outerPath.stroke()
    }

}
