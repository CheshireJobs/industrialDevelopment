import StorageService

final class ProfileViewModel {
    var userLogin: String
    var posts = [MyPost]()
    var onSatateChanged: ((State) -> Void)?
    var onPhotosRowSelected: (() -> Void)?
    var onExitTapped: (() -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            onSatateChanged?(state)
        }
    }
    private var userService: UserService
    private(set) var currentUser: User?
    private let postsService: PostsService = ProfilePostsService()
    
    init(userService: UserService, userLogin: String) {
        self.userService = userService
        self.userLogin = userLogin
    }
    
    func send(_ action: Action) {
        switch action {
        case .viewIsReady:
            state = .loading
            getData()
        case .photosRowSelected:
            onPhotosRowSelected?()
        case .exitButtonTapped:
            UserDefaults.standard.set(false, forKey: "isAuthorized")
            
            onExitTapped?()
        }
    }
    
    func getData() {
        currentUser = userService.getUser(userLogin: userLogin)
        postsService.fetchPosts { [weak self] posts in
            self?.posts = posts
            self?.state = .loaded
        }
    }
}

extension ProfileViewModel {
    enum Action {
        case viewIsReady
        case photosRowSelected
        case exitButtonTapped
    }
    
    enum State {
        case initial
        case loading
        case loaded
    }
}
