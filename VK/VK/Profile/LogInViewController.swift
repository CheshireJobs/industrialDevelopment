import UIKit
import Security
import FirebaseAuth

class LogInViewController: UIViewController, AuthRealmServicePresenter {
    
// MARK: properties
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    var delegate: LoginViewControllerDelegate?
    var authRealm = AuthRealmService.shared
    var onLoginButtonTapped: ((UserService, String) -> Void)?
    
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
    
    private lazy var singinButton: CustomButton = {
        let singinButton = CustomButton(title: "sign_in".localized, titleColor: .white)
        singinButton.setBackgroundImage( UIImage.init(named: "blue_pixel"), for: .normal)
        singinButton.layer.cornerRadius = 10
        singinButton.clipsToBounds = true
        singinButton.isEnabled = false
        singinButton.onTap = {
//            self.delegate?.checheckCredentials(login: self.emailTextField.text ?? "error", password: self.passwordTextField.text ?? "error", controller: self)
            
            self.authRealm.signIn(login:  self.emailTextField.text ?? "error", password: self.passwordTextField.text ?? "error", controller: self)
            
        }
        return singinButton
    }()
    
    func displayLoginErrorAlert(error: String) {
        let alertController = UIAlertController(title: "signin_error".localized, message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func displayProfile(login: String) {
        let currentUserService = CurrentUserService(userLogin: login)
        onLoginButtonTapped?(currentUserService, login)
    }
    
    private lazy var singupButton: CustomButton = {
        let singupButton = CustomButton(title: "sign_up".localized, titleColor: .white)
        singupButton.backgroundColor = .systemGreen
        singupButton.layer.cornerRadius = 10
        singupButton.clipsToBounds = true
        singupButton.isEnabled = false
        singupButton.onTap = {
//            self.delegate?.signUp(login: self.emailTextField.text ?? "error", password: self.passwordTextField.text ?? "error", controller: self)
            
            self.authRealm.signUp(login:  self.emailTextField.text ?? "error", password: self.passwordTextField.text ?? "error", controller: self)
        }
        return singupButton
    }()
    
    private lazy var guessPasswordButton: CustomButton = {
        let guessPasswordButton = CustomButton(title: "crack_password".localized, titleColor: .white)
        guessPasswordButton.setBackgroundImage( UIImage.init(named: "blue_pixel"), for: .normal)
        guessPasswordButton.layer.cornerRadius = 10
        guessPasswordButton.clipsToBounds = true
        return guessPasswordButton
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appBackgroundColor
        scrollView.keyboardDismissMode = .onDrag
        navigationController?.navigationBar.isHidden = true
        
        emailTextField.addTarget(self, action: #selector(enabledButton), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(enabledButton), for: .editingChanged)
        
        setupEnterDataStackViewConstraints()
        setupConstraints()
        
        let queue = DispatchQueue.global(qos: .utility)
        
        guessPasswordButton.onTap = {
            self.activityIndicatorView.startAnimating()
            queue.async {
                let password = SecCreateSharedWebCredentialPassword() as String?
                bruteForce(passwordToUnlock: password ?? "error")
                DispatchQueue.main.async { [weak self] in
                    self?.passwordTextField.text = password
                    self?.passwordTextField.isSecureTextEntry = false
                    self?.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    @objc func enabledButton() {
        singupButton.isEnabled = (emailTextField.text != "" && passwordTextField.text != "") ? true : false
        singinButton.isEnabled = (emailTextField.text != "" && passwordTextField.text != "") ? true : false
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
    
    private func setupEnterDataStackViewConstraints() {
        enterDataStackView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        separateView.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        enterDataStackView.addArrangedSubview(emailTextField)
        enterDataStackView.addArrangedSubview(separateView)
        enterDataStackView.addArrangedSubview(passwordTextField)
        enterDataStackView.axis = .vertical

        let enterDataStackViewConstraints = [
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
        ]

        NSLayoutConstraint.activate(enterDataStackViewConstraints)
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
        singinButton.translatesAutoresizingMaskIntoConstraints = false
        singupButton.translatesAutoresizingMaskIntoConstraints = false
        guessPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubviews(singinButton,
                                  singupButton,
                                  guessPasswordButton,
                                  logoImageView,
                                  enterDataStackView,
                                  activityIndicatorView)
        
        let constraints = [
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

            singinButton.heightAnchor.constraint(equalToConstant: 50),
            singinButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            singinButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            singinButton.topAnchor.constraint(equalTo: enterDataStackView.bottomAnchor, constant: 16),
            
            guessPasswordButton.heightAnchor.constraint(equalToConstant: 50),
            guessPasswordButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            guessPasswordButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            guessPasswordButton.topAnchor.constraint(equalTo: singinButton.bottomAnchor, constant: 16),

            singupButton.heightAnchor.constraint(equalToConstant: 50),
            singupButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            singupButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            singupButton.topAnchor.constraint(equalTo: guessPasswordButton.bottomAnchor, constant: 26),
            singupButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            activityIndicatorView.trailingAnchor.constraint(equalTo: enterDataStackView.trailingAnchor,constant: -16),
            activityIndicatorView.centerYAnchor.constraint(equalTo: enterDataStackView.bottomAnchor, constant: -49.75/2)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
