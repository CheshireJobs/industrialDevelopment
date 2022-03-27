import Foundation
import UIKit

class ProfileHeaderView: UIView {
    
    let avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.image = UIImage(named: "Jobs")
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.cornerRadius = 130 / 2
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    
    let fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.text = "Steve Jobs"
        fullNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        fullNameLabel.textColor = .black
        return fullNameLabel
    }()
    
    var profileStatusLabel: UILabel = {
        let profileStatusLabel = UILabel()
        profileStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        profileStatusLabel.text = "Waiting for something..."
        profileStatusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profileStatusLabel.textColor = .gray
        return profileStatusLabel
    }()
    
    lazy var statusTextField: UITextField = {
        let statusTextField = UITextField()
        statusTextField.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: statusTextField.frame.height))
        statusTextField.leftView = paddingView
        statusTextField.leftViewMode = UITextField.ViewMode.always
        statusTextField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        statusTextField.textColor = .black
        statusTextField.backgroundColor = .white
        statusTextField.layer.borderWidth = 1
        statusTextField.layer.borderColor = UIColor.black.cgColor
        statusTextField.layer.cornerRadius = 12
        statusTextField.addTarget(self, action: #selector(textStatusChangeed), for: .editingChanged)
        return statusTextField
    }()
    
    lazy var setStatusButton: UIButton = {
        let setStatusButton = UIButton()
        setStatusButton.translatesAutoresizingMaskIntoConstraints = false
        setStatusButton.backgroundColor = .blue
        setStatusButton.setTitle("Set Status", for: .normal)
        setStatusButton.setTitleColor(.white, for: .normal)
        setStatusButton.layer.cornerRadius = 4
        setStatusButton.layer.shadowOffset.width = 4
        setStatusButton.layer.shadowOffset.height = 4
        setStatusButton.layer.shadowRadius = 4
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
        setStatusButton.layer.shadowOpacity = 0.7
        setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return setStatusButton
    }()
    private var statusText: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(profileStatusLabel)
        addSubview(setStatusButton)
        addSubview(statusTextField)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            fullNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            fullNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            avatarImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 130),
            avatarImageView.widthAnchor.constraint(equalToConstant: 130),
            
            setStatusButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            setStatusButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            setStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            
            statusTextField.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -8),
            statusTextField.leftAnchor.constraint(equalTo: fullNameLabel.leftAnchor),
            statusTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            
            profileStatusLabel.bottomAnchor.constraint(equalTo: statusTextField.topAnchor, constant: -8),
            profileStatusLabel.leftAnchor.constraint(equalTo: fullNameLabel.leftAnchor),
            
            leftAnchor.constraint(equalTo: self.leftAnchor),
            rightAnchor.constraint(equalTo: self.rightAnchor),
            topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            heightAnchor.constraint(equalToConstant: 220),
        ])
    }
    
    @objc private func buttonPressed() {
        if(statusText.count == 0){
            return
        } else {
            profileStatusLabel.text = statusText
        }
    }
    
    @objc private func textStatusChangeed(_ textField: UITextField) {
        if let txt: String = textField.text {
            statusText = txt
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
