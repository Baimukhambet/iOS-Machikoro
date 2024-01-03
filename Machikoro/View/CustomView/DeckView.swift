import UIKit

class DeckView: UIView {
    
    private let triangularCount = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        // Set the background color for the rectangular view
        backgroundColor = UIColor.blue
        
        let maskLayer = CALayer()
        // Calculate the size of each triangular cutout
        let triangleHeight = CGFloat(12)
        
        // Add upward-pointing triangular cutouts as sublayers
        for i in 0..<triangularCount {
            let startX = CGFloat(i) * triangleHeight
            let triangleLayer = createTriangleLayer(startX: startX, triangleHeight: triangleHeight)
            maskLayer.addSublayer(triangleLayer)
        }
        
        layer.mask = maskLayer
        
    }

    private func createTriangleLayer(startX: CGFloat, triangleHeight: CGFloat) -> CALayer {
        let triangleLayer = CAShapeLayer()
        let trianglePath = UIBezierPath()

        trianglePath.move(to: CGPoint(x: startX, y: 0))
        trianglePath.addLine(to: CGPoint(x: startX + triangleHeight / 2, y: triangleHeight))
        trianglePath.addLine(to: CGPoint(x: startX + triangleHeight, y: 0))
        trianglePath.close()

        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = UIColor.clear.cgColor

        return triangleLayer
    }
}
