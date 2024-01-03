import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    let mainWindow = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let manager = GameManager.shared
    
    lazy var backgroundView: UIImageView = {
        let imgView = UIImageView(frame: view.bounds)
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "launch")
        return imgView
    }()
    
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "MACHI KORO"
//        label.font = .monospacedDigitSystemFont(ofSize: 28, weight: .bold)
//        label.textAlignment = .center
//        return label
//    }()
    
    lazy var createRoomBTN: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Room", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 22)
        
        btn.setTitleColor(.gray, for: .highlighted)
        btn.layer.cornerRadius = 6
        
        let action = UIAction() { _ in
            let createRoomVC = CreateRoomController()
            self.manager.createRoomController = createRoomVC
            self.navigationController?.pushViewController(createRoomVC, animated: true)
        }
        btn.addAction(action, for: .touchUpInside)
        
        
        return btn
    }()
    
    lazy var joinRoomBTN: UIButton = {
        let btn = UIButton()
        btn.setTitle("Join Room", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 22)
        
        btn.setTitleColor(.gray, for: .highlighted)
        btn.layer.cornerRadius = 6
        
        let action = UIAction() { _ in
            let joinVC = JoinRoomController()
            self.navigationController?.pushViewController(joinVC, animated: true)
        }
        btn.addAction(action, for: .touchUpInside)
        
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupView()
        UINavigationBar.appearance().barTintColor = .green
    }
    

    
    private func setupView() {
        self.view.addSubview(backgroundView)
//        self.view.addSubview(titleLabel)
        self.view.addSubview(createRoomBTN)
        self.view.addSubview(joinRoomBTN)
        
//        titleLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.leading.trailing.equalToSuperview()
//        }
        
        createRoomBTN.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.4)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        joinRoomBTN.snp.makeConstraints { make in
            make.top.equalTo(createRoomBTN.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
//        addMockButtons()
        
    }
}
