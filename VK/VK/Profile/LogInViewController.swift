import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet var profileView: UIView!
    
// MARK: properties
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
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setBackgroundImage( UIImage.init(named: "blue_pixel"), for: .normal)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return loginButton
    }()
    
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
        
        containerView.addSubviews(loginButton, logoImageView, enterDataStackView)
        
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
            loginButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func loginButtonPressed() {
        var currentUserService: UserService
        #if DEBUG
        currentUserService = TestUserService()
        #else
        currentUserService = CurrentUserService()
        #endif
        let profileViewController = ProfileViewController(userService: currentUserService, userLogin: emailTextField.text ?? "error")
        navigationController?.pushViewController(profileViewController , animated: true)
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
