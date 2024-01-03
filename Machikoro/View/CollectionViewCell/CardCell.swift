import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 1000.0
        transform = CATransform3DRotate(transform, 0.4, 1, 0, 0)
        
        imgView.layer.transform = transform
        
        return imgView
    }()
    
    lazy var counterLabel: CustomLabel = {
        let label = CustomLabel()
        label.font = .monospacedSystemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    lazy var dimView: UIView = {
        let view = UIView(frame: imageView.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.6)
        return view
    }()
    
    var dashBorder: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        imageView.addSubview(counterLabel)
        counterLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Failed to initialize coll view cell :(")
    }
    
//    func setupCell(cardName: String, count: Int) {
//        imageView.image = UIImage(named: cardName)
//        counterLabel.text = "x\(count)"
//    }
    
    func setupCell(cardName: String, count: Int) {
        imageView.image = UIImage(named: cardName)
        counterLabel.text = "x\(count)"
    }
    
    func setupKeyCell(cardName: String) {
        counterLabel.removeFromSuperview()
        imageView.image = UIImage(named: cardName)
    }
    
    func dimCell() {
        imageView.addSubview(dimView)
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func addBorder() {
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = 2
        dashBorder.strokeColor = UIColor.white.cgColor
        dashBorder.lineDashPattern = [4, 2] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
        self.contentView.layer.addSublayer(dashBorder)
        dashBorder.fillColor = nil
        
        counterLabel.removeFromSuperview()
        self.dashBorder = dashBorder
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dimView.removeFromSuperview()
        self.dashBorder?.removeFromSuperlayer()
        self.imageView.image = nil
        counterLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 2
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }

}
