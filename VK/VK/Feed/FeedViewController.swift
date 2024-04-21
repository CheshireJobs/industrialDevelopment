import UIKit
import StorageService

final class FeedViewController: UIViewController {
    private let viewModel: FeedViewModel
    
    private lazy var postsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupViewModel()
        viewModel.send(.viewIsReady)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
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
                self.postsTableView.reloadData()
            case let .error(error):
                print(error)
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(postsTableView)
        
        postsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func doubleTaped(sender: UIGestureRecognizer) {
        let touchLocation: CGPoint = sender.location(in: sender.view)
        guard let indexPath: IndexPath = postsTableView.indexPathForRow(at: touchLocation) else { return }
        viewModel.send(.postDoubleTapped(index: indexPath.row))
        print("addPostToFavorites: \(indexPath.row)")
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postCell = postsTableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
        postCell.post = self.viewModel.posts[indexPath.row]
        return postCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName = String()
        switch section {
        case 0:
            sectionName = "Новости"
        default:
            break
        }
        return sectionName
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTaped))
        doubleTap.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTap)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

