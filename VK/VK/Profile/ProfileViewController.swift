import Foundation
import UIKit
import StorageService

class ProfileViewController: UIViewController {
    
    private let tableView = UITableView()
    private let reuseID = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupConstraints()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    private func setupTableView() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.register(
            ProfileTableHeaderView.self,
            forHeaderFooterViewReuseIdentifier: String(describing: ProfileTableHeaderView.self)
        )
        tableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: String(describing: PhotosTableViewCell.self)
        )
        
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

//MARK: UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return postTableModel.count
        default:
            return 0
        }

    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self), for: indexPath) as! PhotosTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! PostTableViewCell
            cell.post = postTableModel[indexPath.row]
            return cell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0 ) {
            guard let profileHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProfileTableHeaderView.self)) as? ProfileTableHeaderView else {
                return nil
            }
            return profileHeaderView
        } else {
            return nil
        }
    }
    
}

//MARK: UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
            let photosViewController = PhotosViewController()
            photosViewController.title = "Photo Gallery"
            navigationController?.pushViewController(photosViewController, animated: true)
        }
    }
}
