import UIKit
import SwiftUI
import Security
import FirebaseAuth

class LogInViewController: UIViewController {
    private var viewModel: LoginViewModel
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()

    private let enterDataStackView: UIStackView = {
        let enterDataView = UIStackView()
        enterDataView.layer.borderColor = UIColor.lightGray.cgColor
        enterDataView.layer.borderWidth = 0.5
        enterDataView.layer.cornerRadius = 10
        return enterDataView
    }()
    
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "logo")
        return logoImageView
    }()
    
    private let separateView = UIView()
    
    private lazy var signInButton: CustomButton = {
        let signInButton = CustomButton(title: "sign_in".localized, titleColor: .white)
        signInButton.setBackgroundImage( UIImage.init(named: "blue_pixel"), for: .normal)
        signInButton.layer.cornerRadius = 10
        signInButton.clipsToBounds = true
        signInButton.isEnabled = false
        signInButton.onTap = {
            self.viewModel.send(.signinButtonTapped(login: self.emailTextField.text ?? "error", password: self.passwordTextField.text ?? "error"))
        }
        return signInButton
    }()
    
    private lazy var signUpButton: CustomButton = {
        let singupButton = CustomButton(title: "sign_up".localized, titleColor: .white)
        singupButton.backgroundColor = .systemGreen
        singupButton.layer.cornerRadius = 10
        singupButton.clipsToBounds = true
        singupButton.isEnabled = false
        singupButton.onTap = {
            self.viewModel.send(.singUpButtonTapped(login: self.emailTextField.text ?? "error", password: self.passwordTextField.text ?? "error"))
        }
        return singupButton
    }()
    
    private lazy var biometricsSignInButton: UIButton = {
        let biometricsSignInButton = UIButton()
        biometricsSignInButton.setBackgroundImage(UIImage(systemName: LocalAuthorizationService.shared.biometryType == .faceID ? "faceid" : "touchid"), for: .normal) // viewModel
        biometricsSignInButton.addTarget(self, action: #selector(biometricsButtonTapped), for: .touchUpInside)
        return biometricsSignInButton
    }()
    
    @objc func biometricsButtonTapped() {
        self.viewModel.send(.biometricsButtonTapped)
    }
    
    private var activityIndicatorView = UIActivityIndicatorView()
    
    private let emailTextField: UITextField = {
        let emailTextField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: emailTextField.frame.height))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = UITextField.ViewMode.always
        emailTextField.backgroundColor = .systemGray6
        emailTextField.layer.cornerRadius = 10
        emailTextField.placeholder = "email_or_phone".localized
        return emailTextField
    }()
    
    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: passwordTextField.frame.height))
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.placeholder = "password".localized
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    var alertController: UIAlertController = {
        var alertController = UIAlertController(title: "signin_error".localized, message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(cancelAction)
        return alertController
    }()
    
    private func showErrorAlert(error: String) {
        alertController.message = error
        self.present(alertController, animated: true, completion: nil)
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appBackgroundColor
        navigationController?.navigationBar.isHidden = true
        emailTextField.addTarget(self, action: #selector(enabledButton), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(enabledButton), for: .editingChanged)
        
        setupEnterDataStackViewConstraints()
        setupConstraints()

        scrollView.keyboardDismissMode = .onDrag
        
        setupViewModel()
        viewModel.send(.viewIsReady)
    }
    
    private func setupViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .initial:
                ()
            case .loading:
                ()
            case .loaded:
                ()
            case .checkingCredentials:
                ()
            case .error(let error):
                self.showErrorAlert(error: error)
            }
        }
    }
    
    @objc func enabledButton() {
        signUpButton.isEnabled = (emailTextField.text != "" && passwordTextField.text != "") ? true : false
        signInButton.isEnabled = (emailTextField.text != "" && passwordTextField.text != "") ? true : false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //MARK: keyboard notifications
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension LogInViewController {
    private func setupEnterDataStackViewConstraints() {
        enterDataStackView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        separateView.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        enterDataStackView.addArrangedSubview(emailTextField)
        enterDataStackView.addArrangedSubview(separateView)
        enterDataStackView.addArrangedSubview(passwordTextField)
        enterDataStackView.axis = .vertical

        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: enterDataStackView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: enterDataStackView.trailingAnchor),
            emailTextField.topAnchor.constraint(equalTo: enterDataStackView.topAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 49.75),

            separateView.leadingAnchor.constraint(equalTo: enterDataStackView.leadingAnchor),
            separateView.trailingAnchor.constraint(equalTo: enterDataStackView.trailingAnchor),
            separateView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            separateView.heightAnchor.constraint(equalToConstant: 0.5),

            passwordTextField.leadingAnchor.constraint(equalTo: enterDataStackView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: enterDataStackView.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: separateView.bottomAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 49.75)
        ])
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = UIColor.appBackgroundColor
        enterDataStackView.backgroundColor = .systemGray6
        separateView.backgroundColor = .lightGray
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        enterDataStackView.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        biometricsSignInButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubviews(signInButton,
                                  signUpButton,
                                  biometricsSignInButton,
                                  logoImageView,
                                  enterDataStackView,
                                  activityIndicatorView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 120),

            enterDataStackView.heightAnchor.constraint(equalToConstant: 100),
            enterDataStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            enterDataStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            enterDataStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),

            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            signInButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            signInButton.topAnchor.constraint(equalTo: enterDataStackView.bottomAnchor, constant: 16),
            
            biometricsSignInButton.heightAnchor.constraint(equalToConstant: 50),
            biometricsSignInButton.widthAnchor.constraint(equalToConstant: 50),
            biometricsSignInButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            biometricsSignInButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 16),

            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            signUpButton.topAnchor.constraint(equalTo: biometricsSignInButton.bottomAnchor, constant: 26),
            signUpButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            activityIndicatorView.trailingAnchor.constraint(equalTo: enterDataStackView.trailingAnchor,constant: -16),
            activityIndicatorView.centerYAnchor.constraint(equalTo: enterDataStackView.bottomAnchor, constant: -49.75/2)
        ])
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
