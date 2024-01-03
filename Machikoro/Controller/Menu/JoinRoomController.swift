import UIKit
import Firebase

class JoinRoomController: UIViewController {
    
    let manager = GameManager.shared
    var GameVC: GameVController?
    var session: GameSession?
    
    //MARK: Initial Views
    
    lazy var backgroundView: UIImageView = {
        let imgView = UIImageView(frame: view.bounds)
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "bg-bg")
        imgView.alpha = 0.7
        return imgView
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Enter the code"
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 26, weight: .semibold)
        
        return lbl
    }()
    
    lazy var inputField: UITextFieldWithPadding = {
        let field = UITextFieldWithPadding(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        field.placeholder = "Code..."
        field.font = .systemFont(ofSize: 18)
        field.layer.cornerRadius = 8
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        field.backgroundColor = .white
        
        return field
    }()
    
    lazy var submitButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Submit", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 22)
        btn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        btn.layer.cornerRadius = 8
        btn.setTitleColor(.white, for: .normal)
        
        btn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        return btn
    }()

    
    //MARK: Setup View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupView()
//        let backBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backBtnTapped))
        let backBtn = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward.circle.fill"), style: .plain, target: self, action: #selector(backBtnTapped))
        backBtn.tintColor = .red
        backBtn.customView?.backgroundColor = .black
        
        navigationItem.leftBarButtonItem = backBtn
    }
    
    private func setupView() {
        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(inputField)
        view.addSubview(submitButton)
        
        inputField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(inputField.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(inputField.snp.bottom).offset(56)
            make.leading.trailing.equalToSuperview().inset(36)
        }
    }
    
    
    //MARK: Buttons
    
    @objc private func backBtnTapped() {
        navigationController?.popViewController(animated: false)
    }
    

    @objc func submitTapped() {
        if inputField.text == nil || inputField.text == "" {
            self.showNoRoomExists()
            return
        }
        
        manager.joinRoom(roomKey: inputField.text!) { session in
            guard let session = session else {
                self.showNoRoomExists()
                return
            }
            self.session = session
            self.GameVC = GameVController()
            self.GameVC?.session = session
            self.GameVC?.hidesBottomBarWhenPushed = true
            
            self.hasConnectedToRoom()
        }
    }
    
    //MARK: Update View After connection
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
        
        return lbl
    }()
    
    lazy var connectedOpponentView: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "Connected Player:"
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
//        lbl.backgroundColor = .white
//        lbl.layer.cornerRadius = 12
//        lbl.clipsToBounds = true
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    lazy var opponentIDView: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = ""
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.backgroundColor = .white
        lbl.layer.cornerRadius = 12
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    lazy var waitingStartLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Waiting for start..."
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    //MARK: Functions
    private func showNoRoomExists() {
        let view = CustomLabel()
        view.text = "No such room exists!"
        view.backgroundColor = .red
        view.alpha = 0.0
        view.textAlignment = .center
        view.textColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.font = .systemFont(ofSize: 24, weight: .semibold)
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        UIView.animate(withDuration: 1.6) {
            view.alpha = 1.0
        } completion: { finished in
            UIView.animate(withDuration: 1.4) {
                view.alpha = 0.0
            } completion: { finished in
                view.removeFromSuperview()
            }
        }
    }
    
    private func hasConnectedToRoom() {
        inputField.removeFromSuperview()
        titleLabel.removeFromSuperview()
        submitButton.removeFromSuperview()
        
        setupConnectedView()
        observeStart()
    }
    
    
    
    private func setupConnectedView() {
        view.addSubview(connectedOpponentView)
        view.addSubview(yourRoomIDView)
        view.addSubview(opponentIDView)
        view.addSubview(codeView)
        view.addSubview(waitingStartLabel)
        setupConstraints()
        
        codeView.text = session?.roomID
        opponentIDView.text = session?.opponent.getID()
        
    }
    
    private func setupConstraints() {
        yourRoomIDView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(102)
            make.leading.equalToSuperview().inset(24)
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
        
        waitingStartLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func observeStart() {
        session!.ref.child("Rooms/\(session!.roomID)/gameStarted").observe(.value){ snapshot in
            if let value = snapshot.value as? Bool, value == true {
                self.startGame()
            }
        }
    }
    
    private func startGame() {
        navigationController?.pushViewController(GameVC!, animated:  false)
        self.navigationController?.viewControllers.remove(at: 1)
    }
}


class UITextFieldWithPadding: UITextField {
    var textPadding: UIEdgeInsets
    init(_ padding: UIEdgeInsets) {
        self.textPadding = padding
        super.init(frame: .zero)
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
