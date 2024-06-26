import Foundation
import UIKit
import CoreData
import StorageService

class FavoritesViewController: UIViewController {
    var viewModel: FavoritesViewModel
    private let tableView = UITableView()
    
    private lazy var rightItemBarButton: UIBarButtonItem = {
        var rightItemBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass.circle.fill"), style: .done, target: self, action: #selector(searchTapped))
        return rightItemBarButton
    }()
    private lazy var leftItemBarButton: UIBarButtonItem = {
        var leftItemBarButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle.fill"), style: .done, target: self, action: #selector(resetTapped))
        return leftItemBarButton
    }()
    
    private lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "Author", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            guard let text = textField?.text, textField?.text != "" else { return }
            self.viewModel.send(action: .setFilterTapped(text))
        }))
        return alert
    }()
    
    @objc private func searchTapped(){
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func resetTapped(){
        viewModel.send(action: .resetTapped)
    }
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackgroundColor
        setupConstraints()
        setupTableView()
        setupViewModel()
        viewModel.fetchResultController.delegate = self
        viewModel.send(action: .viewIsReady)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem = rightItemBarButton
        self.navigationItem.leftBarButtonItem = leftItemBarButton
    }
    
    private func setupViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .initial:
                ()
            case .setUpFetchResultController:
                self.tableView.reloadData()
            case .resetedFilterFetchResultController:
                self.tableView.reloadData()
            case .settedFilterFetchResultController:
                self.tableView.reloadData()
            case .deletedPost:
                self.tableView.reloadData()
            case .error(_):
                ()
            }
        }
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
        return viewModel.fetchResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self) , for: indexPath) as! PostTableViewCell
        let myPost = viewModel.getPost(at: indexPath)
        cell.post = myPost
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Удалить", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.viewModel.send(action: .deletePostSwiped(at: indexPath))
            success(true)
        })
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {
                fallthrough
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {
                fallthrough
            }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {
                fallthrough
            }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {
                fallthrough
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
