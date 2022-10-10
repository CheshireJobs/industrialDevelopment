import Foundation
import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    
    var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.image = UIImage(named: "Jobs")
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.cornerRadius = 130 / 2
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    
    var fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.text = "Steve Jobs"
        fullNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        fullNameLabel.textColor = .appLabelColor
        return fullNameLabel
    }()
    
    var profileStatusLabel: UILabel = {
        let profileStatusLabel = UILabel()
        profileStatusLabel.text = "status_text".localized
        profileStatusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profileStatusLabel.textColor = .gray
        return profileStatusLabel
    }()
    
    lazy var statusTextField: UITextField = {
        let statusTextField = UITextField()
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
    
    lazy var setStatusButton: CustomButton = {
        let setStatusButton = CustomButton(title: "status_button".localized, titleColor: .white)
        setStatusButton.backgroundColor = .blue
        setStatusButton.layer.cornerRadius = 4
        setStatusButton.layer.shadowOffset.width = 4
        setStatusButton.layer.shadowOffset.height = 4
        setStatusButton.layer.shadowRadius = 4
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
        setStatusButton.layer.shadowOpacity = 0.7
        setStatusButton.onTap = {
            if self.statusText.count == 0 {
                return
            } else {
                self.profileStatusLabel.text = self.statusText
            }
        }
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        fullNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(27)
        }
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(16)
            make.height.width.equalTo(130)
        }
        setStatusButton.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        statusTextField.snp.makeConstraints { make in
            make.bottom.equalTo(setStatusButton.snp.top).offset(-8)
            make.leading.equalTo(fullNameLabel.snp.leading)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.height.equalTo(40)
        }
        profileStatusLabel.snp.makeConstraints { make in
            make.bottom.equalTo(statusTextField.snp.top).offset(-8)
            make.leading.equalTo(fullNameLabel.snp.leading)
        }
        self.snp.makeConstraints { make in
            make.height.equalTo(220)
        }
    }
    
    @objc private func textStatusChangeed(_ textField: UITextField) {
        if let txt: String = textField.text {
            statusText = txt
        }
    }
}
