import UIKit
import SnapKit

class InfoViewController: UIViewController {
    
    private lazy var alertButton: CustomButton = {
        var alertButton = CustomButton(title: "tap me!", titleColor: .white)
        alertButton.layer.cornerRadius = 10
        alertButton.backgroundColor = .black
        alertButton.onTap = {
            self.showAlert()
        }
        return alertButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupConstraints()
    }
}

private extension InfoViewController {
    func showAlert() {
        let alertController = UIAlertController(title: "Удалить пост?", message: "Пост нельзя будет восстановить", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            print("Отмена")
        }
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            print("Удалить")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        view.addSubview(alertButton)
        
        alertButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
}
