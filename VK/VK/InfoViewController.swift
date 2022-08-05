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
    private var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        if let jsonModelUrl = URL(string: "https://jsonplaceholder.typicode.com/todos/22") {
            let task = URLSession.shared.dataTask(with: jsonModelUrl) { data, responce, error in
                if let jsonData = data {
                    do {
                        let deserializedData = try JSONSerialization.jsonObject(with: jsonData, options: [])
                        if let dictionary = deserializedData as? [String: Any] {
                            let user = JsonUser(dictionary: dictionary)
                            DispatchQueue.main.async {
                                self.titleLabel.text = user.title
                            }
                        }
                    }
                    catch let error {
                        print(error)
                    }
                }
            }
            task.resume()
        }
        
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
        view.addSubview(titleLabel)
        
        alertButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.top).offset(36)
        }
    }
}
