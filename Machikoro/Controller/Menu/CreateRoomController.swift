import UIKit

class CreateRoomController: UIViewController {
    
    let manager = GameManager.shared
    var GameVC: GameVController?
    var session: GameSession?
    
    lazy var backgroundView: UIImageView = {
        let imgView = UIImageView(frame: view.bounds)
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "bg-bg")
        imgView.alpha = 0.7
        return imgView
    }()
    
    lazy var yourRoomIDView: UILabel = {
        let lbl = UILabel()
        lbl.text = "Room's ID:"
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    lazy var codeView: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = ""
        lbl.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(codeWasTapped))
        lbl.isUserInteractionEnabled = true
        lbl.addGestureRecognizer(tapGesture)
        
        return lbl
    }()
    
    lazy var connectedOpponentView: UILabel = {
        let lbl = UILabel()
        lbl.text = "Connected Player:"
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    lazy var opponentIDView: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.backgroundColor = .white
        lbl.layer.cornerRadius = 12
        lbl.clipsToBounds = true
        
        return lbl
    }()
    
    lazy var startGameButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Start", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        btn.layer.cornerRadius = 12
        btn.isEnabled = false
        
        let action = UIAction { [self] _ in
            beginGame()
        }
        btn.addAction(action, for: .touchUpInside)
        
        return btn
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        createGame()
        setupView()
        let backBtn = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward.circle.fill"), style: .plain, target: self, action: #selector(backBtnTapped))
        backBtn.tintColor = .red
        backBtn.customView?.backgroundColor = .black
        
        navigationItem.leftBarButtonItem = backBtn
    }
    
    @objc private func backBtnTapped() {
        navigationController?.popViewController(animated: false)
    }
    
    private func setupView() {
        view.addSubview(backgroundView)
        view.addSubview(codeView)
        view.addSubview(startGameButton)
        view.addSubview(connectedOpponentView)
        view.addSubview(yourRoomIDView)
        view.addSubview(opponentIDView)
        
        yourRoomIDView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(102)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        codeView.snp.makeConstraints { make in
            make.top.equalTo(yourRoomIDView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        connectedOpponentView.snp.makeConstraints { make in
            make.top.equalTo(codeView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        opponentIDView.snp.makeConstraints { make in
            make.top.equalTo(connectedOpponentView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        startGameButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-124)
            make.leading.trailing.equalToSuperview().inset(44)
        }
    }
    
    @objc func codeWasTapped(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        UIView.animate(withDuration: 0.7) {
            label.alpha = 0.2
        }
        
        UIView.animate(withDuration: 0.7) {
            label.alpha = 1
        }
        UIPasteboard.general.string = label.text
    }
    
    private func createGame() {
        manager.createNewGame() { [self] session in
            print("Player ID: \(session.player.getID())")
            print("Opponent ID: \(session.opponent.getID())")
            print("RoomID: \(session.roomID)")
            self.session = session
            
            self.GameVC = GameVController()
            self.GameVC!.session = session
            self.GameVC?.hidesBottomBarWhenPushed = true
            opponentIDView.text = session.opponent.getID()
            
            startGameButton.isEnabled = true
            startGameButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
    }
    
    private func beginGame() {
        navigationController?.pushViewController(GameVC!, animated: false)
        session?.beginGame()
        navigationController?.viewControllers.remove(at: 1)
    }

}
