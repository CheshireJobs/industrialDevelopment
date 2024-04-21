import Foundation
import UIKit
import StorageService

class ProfileViewController: UIViewController {
    private var viewModel: ProfileViewModel
    private let tableView = UITableView()
    
    private lazy var exitButton: UIBarButtonItem = {
        var rightItemBarButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(onExitButtonTapped))
        return rightItemBarButton
    }()
    
    @objc private func onExitButtonTapped() {
        viewModel.send(.exitButtonTapped)
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupTableView()
        setupViewModel()
        viewModel.send(.viewIsReady)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = exitButton
    }
    
    private func setupViewModel() {
        viewModel.onSatateChanged = { [weak self] state in
            guard let self = self else {return}
            
            switch state {
            case .initial:
                ()
            case .loading:
                ()
            case .loaded:
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        tableView.register(
            ProfileTableHeaderView.self,
            forHeaderFooterViewReuseIdentifier: String(describing: ProfileTableHeaderView.self))
        tableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: String(describing: PhotosTableViewCell.self))
        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupConstraints() {
        view.backgroundColor = UIColor.appBackgroundColor
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

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.posts.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
            cell.post = viewModel.posts[indexPath.row]
            return cell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0 ) {
            guard let profileTableHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProfileTableHeaderView.self)) as? ProfileTableHeaderView else {
                return nil
            }
            profileTableHeaderView.profileHeaderView.fullNameLabel.text = viewModel.currentUser?.fullName
            profileTableHeaderView.profileHeaderView.avatarImageView.image = UIImage(named: viewModel.currentUser?.photo ?? "logo")
            profileTableHeaderView.profileHeaderView.statusTextField.text = viewModel.currentUser?.statusString
            return profileTableHeaderView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName = String()
        switch section {
        case 0:
            break
        case 1:
            sectionName = "Мои записи"
        default:
            break
        }
        return sectionName
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.send(.photosRowSelected)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
