import UIKit

class DiceView: UIView {
    var diceValue: Int = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    let dotSize: CGFloat = 10
    let spacing: CGFloat = 10

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2

        context.setFillColor(UIColor.cyan.cgColor)
        context.fill(rect)

        self.layer.cornerRadius = 8
        self.clipsToBounds = true

        switch diceValue {
        case 1:
            drawDot(at: CGPoint(x: bounds.midX, y: bounds.midY))
        case 2:
            drawDot(at: CGPoint(x: bounds.midX - dotSize - spacing, y: bounds.midY))
            drawDot(at: CGPoint(x: bounds.midX + dotSize + spacing, y: bounds.midY))
        case 3:
            drawDot(at: CGPoint(x: bounds.midX - dotSize - spacing, y: bounds.midY - dotSize - spacing))
            drawDot(at: CGPoint(x: bounds.midX, y: bounds.midY))
            drawDot(at: CGPoint(x: bounds.midX + dotSize + spacing, y: bounds.midY + dotSize + spacing))
        case 4:
            drawDot(at: CGPoint(x: bounds.midX - dotSize - spacing, y: bounds.midY - dotSize - spacing))
            drawDot(at: CGPoint(x: bounds.midX + dotSize + spacing, y: bounds.midY - dotSize - spacing))
            drawDot(at: CGPoint(x: bounds.midX - dotSize - spacing, y: bounds.midY + dotSize + spacing))
            drawDot(at: CGPoint(x: bounds.midX + dotSize + spacing, y: bounds.midY + dotSize + spacing))
        case 5:
            drawDot(at: CGPoint(x: bounds.midX - dotSize - spacing, y: bounds.midY - dotSize - spacing))
            drawDot(at: CGPoint(x: bounds.midX + dotSize + spacing, y: bounds.midY - dotSize - spacing))
            drawDot(at: CGPoint(x: bounds.midX - dotSize - spacing, y: bounds.midY + dotSize + spacing))
            drawDot(at: CGPoint(x: bounds.midX, y: bounds.midY))
            drawDot(at: CGPoint(x: bounds.midX + dotSize + spacing, y: bounds.midY + dotSize + spacing))
        case 6:
            drawDot(at: CGPoint(x: bounds.midX - dotSize - spacing / 2, y: bounds.midY - dotSize - spacing))
            drawDot(at: CGPoint(x: bounds.midX + dotSize + spacing / 2, y: bounds.midY - dotSize - spacing))
            drawDot(at: CGPoint(x: bounds.midX - dotSize - spacing / 2, y: bounds.midY + dotSize + spacing))
            drawDot(at: CGPoint(x: bounds.midX + dotSize + spacing / 2, y: bounds.midY + dotSize + spacing))
            
            drawDot(at: CGPoint(x: bounds.midX + dotSize + spacing / 2, y: bounds.midY ))
            drawDot(at: CGPoint(x: bounds.midX - dotSize - spacing / 2, y: bounds.midY ))
        default:
            break
        }
    }
    

    private func drawDot(at point: CGPoint) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let dotRect = CGRect(x: point.x - dotSize / 2, y: point.y - dotSize / 2, width: dotSize, height: dotSize)
        context.setFillColor(UIColor.black.cgColor)
        context.fillEllipse(in: dotRect)
    }
    
    func throwDice(completion: @escaping (Int) -> ()) {
        // Total duration for the complete animation
        let totalDuration: TimeInterval = 2.0
        
        // Number of intermediate steps before settling on the final value
        let numberOfSteps = 8
        
        // Duration for each intermediate step
        let intermediateStepDuration = totalDuration / Double(numberOfSteps)
        
        // Perform a sequence of animations
        var currentStep = 0
        _ = Timer.scheduledTimer(withTimeInterval: intermediateStepDuration, repeats: true) { timer in
            // Assign a random value to diceValue for each intermediate step
            self.diceValue = Int.random(in: 1...6)
            
            currentStep += 1
            
            // Check if all intermediate steps are completed
            if currentStep >= numberOfSteps {
                timer.invalidate()
                
                // Optional: Settle on the final value after the last intermediate step
                UIView.animate(withDuration: intermediateStepDuration, animations: {
                    self.diceValue = Int.random(in: 1...6)
                }, completion: { _ in
                    completion(self.diceValue)
                })
            }
        }
    }
    
    func animateDiceThrow(value: Int, completion: @escaping (Int) -> ()) {
        // Total duration for the complete animation
        let totalDuration: TimeInterval = 2.0
        
        // Number of intermediate steps before settling on the final value
        let numberOfSteps = 8
        
        // Duration for each intermediate step
        let intermediateStepDuration = totalDuration / Double(numberOfSteps)
        
        // Perform a sequence of animations
        var currentStep = 0
        _ = Timer.scheduledTimer(withTimeInterval: intermediateStepDuration, repeats: true) { timer in
            // Assign a random value to diceValue for each intermediate step
            self.diceValue = Int.random(in: 1...6)
            
            currentStep += 1
            
            // Check if all intermediate steps are completed
            if currentStep >= numberOfSteps {
                timer.invalidate()
                
                // Optional: Settle on the final value after the last intermediate step
                UIView.animate(withDuration: intermediateStepDuration, animations: {
                    self.diceValue = value
                }, completion: { _ in
                    completion(self.diceValue)
                })
            }
        }
    }
}
