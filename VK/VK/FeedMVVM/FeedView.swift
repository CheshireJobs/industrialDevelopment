import UIKit
import Foundation
import SnapKit

protocol FeedViewDelegate: AnyObject {
    func checkWord(word: String)
    func openPostViewController()
}

final class FeedView: UIView {
    
    weak var delegate: FeedViewDelegate?
    
    private var passwordTextField: UITextField = {
        var textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.placeholder = "enter password"
        return textField
    }()
    
    private var resultLabel: UILabel = {
        var resultLabel = UILabel()
        return resultLabel
    }()
    
    private lazy var checkButton: CustomButton = {
        var checkButton = CustomButton(title: "Check password", titleColor: .white)
        checkButton.layer.cornerRadius = 10
        checkButton.backgroundColor = .black
        checkButton.onTap = {
            if let word = self.passwordTextField.text, word != "" {
                self.delegate?.checkWord(word: word)
            }
        }
        return checkButton
    }()
    
    private let postButtonStackView: UIStackView = {
        let postButtonStackView = UIStackView()
        postButtonStackView.layer.borderColor = UIColor.lightGray.cgColor
        postButtonStackView.layer.borderWidth = 0.5
        postButtonStackView.layer.cornerRadius = 10
        postButtonStackView.axis = .vertical
        return postButtonStackView
    }()
    
    private lazy var openPostButtonOne: CustomButton = {
        var checkButton = CustomButton(title: "Open post", titleColor: .white)
        checkButton.layer.cornerRadius = 10
        checkButton.backgroundColor = .black
        checkButton.onTap = { [weak self] in
            self?.delegate?.openPostViewController()
        }
        return checkButton
    }()
    
    private lazy var openPostButtonTwo: CustomButton = {
        var checkButton = CustomButton(title: "Open post", titleColor: .white)
        checkButton.layer.cornerRadius = 10
        checkButton.backgroundColor = .black
        checkButton.onTap = { [weak self] in
            self?.delegate?.openPostViewController()
        }
        return checkButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupConstraints()
    }
    
    func setResultLabel(answer: Bool) {
        resultLabel.text = passwordTextField.text
        resultLabel.textColor = (answer ? .green : .red)
    }
    
    private func setupConstraints() {
        addSubviews(passwordTextField, resultLabel, checkButton, postButtonStackView)
        postButtonStackView.addArrangedSubview(openPostButtonOne)
        postButtonStackView.addArrangedSubview(openPostButtonTwo)
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(157)
            make.leading.equalTo(snp.leading).offset(16)
            make.height.equalTo(27)
            make.width.equalTo(146)
        }
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(27)
            make.leading.equalTo(snp.leading).offset(16)
            make.trailing.equalTo(snp.trailing).offset(-16)
        }
        resultLabel.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(checkButton.snp.bottom).offset(27)
        }
        postButtonStackView.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.top.equalTo(resultLabel.snp.bottom).offset(27)
        }
    }
}
