import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    private let tableView = UITableView()
    
    private lazy var rightItemBarButton: UIBarButtonItem = {
        var rightItemBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass.circle.fill"), style: .done, target: self, action: #selector(searchTapped))
        return rightItemBarButton
    }()
    private lazy var leftItemBarButton: UIBarButtonItem = {
        var leftItemBarButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle.fill"), style: .done, target: self, action: #selector(resetTapped))
        return leftItemBarButton
    }()
    
    private var authorFilter = ""
    
    private lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "Author", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.authorFilter = textField?.text ?? ""
            self.tableView.reloadData()
        }))
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem = rightItemBarButton
        self.navigationItem.leftBarButtonItem = leftItemBarButton
    }
    
    @objc private func searchTapped(){
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func resetTapped(){
        authorFilter = ""
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataBaseManager.shared.getPostsCount(filter: authorFilter)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self) , for: indexPath) as! PostTableViewCell
        let post = DataBaseManager.shared.getFavoritesPost(index: indexPath.row, filter: authorFilter)
        cell.post = post
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Удалить", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            DataBaseManager.shared.deleteFromFavorites(index: indexPath.row)
            tableView.reloadData()
            success(true)
        })
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

