import UIKit
import Security

class LogInViewController: UIViewController {
    
    @IBOutlet var profileView: UIView!
    
// MARK: properties
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    weak var delegate: LoginViewControllerDelegate?
    
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
    
    private lazy var loginButton: CustomButton = {
        let loginButton = CustomButton(title: "Log In", titleColor: .white)
        loginButton.setBackgroundImage( UIImage.init(named: "blue_pixel"), for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.onTap = {
            var currentUserService: UserService
            #if DEBUG
            currentUserService = TestUserService()
            #else
            currentUserService = CurrentUserService()
            #endif
            let profileViewController = ProfileViewController(userService: currentUserService, userLogin: self.emailTextField.text ?? "error")
            self.navigationController?.pushViewController(profileViewController , animated: true)
        }
        return loginButton
    }()
    
    private lazy var guessPasswordButton: CustomButton = {
        let guessPasswordButton = CustomButton(title: "Don't know password? Crack it!", titleColor: .white)
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
        emailTextField.placeholder = "Email or phone"
        return emailTextField
    }()
    
    private let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: passwordTextField.frame.height))
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        return passwordTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView.keyboardDismissMode = .onDrag
        navigationController?.navigationBar.isHidden = true
        
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
        
        containerView.backgroundColor = .white
        enterDataStackView.backgroundColor = .systemGray6
        separateView.backgroundColor = .lightGray
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        enterDataStackView.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        guessPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubviews(loginButton,
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

            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            loginButton.topAnchor.constraint(equalTo: enterDataStackView.bottomAnchor, constant: 16),
            
            guessPasswordButton.heightAnchor.constraint(equalToConstant: 50),
            guessPasswordButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            guessPasswordButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            guessPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            guessPasswordButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            activityIndicatorView.trailingAnchor.constraint(equalTo: enterDataStackView.trailingAnchor,constant: -16),
            activityIndicatorView.centerYAnchor.constraint(equalTo: enterDataStackView.bottomAnchor, constant: -49.75/2)
        ]
        
        NSLayoutConstraint.activate(constraints)
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

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
