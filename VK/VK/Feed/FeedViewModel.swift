import StorageService

final class FeedViewModel {
    var onStateChanged: ((State) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    private(set) var posts = [MyPost]()
    private let postsService: PostsService = FeedPostsService()

    func send(_ action: Action) {
        switch action {
        case .viewIsReady:
            state = .loading
            fetchPosts()
        case .postDoubleTapped(index: let index):
            DataBaseManager.shared.saveToFavorites(post: posts[index])
        }
    }
    
    private func fetchPosts() {
        postsService.fetchPosts { [weak self] posts in
            self?.posts = posts
            self?.state = .loaded
        }
    }
}

extension FeedViewModel {
    enum Action {
        case viewIsReady
        case postDoubleTapped(index: Int)
    }
    
    enum State {
        case initial
        case loading
        case loaded
        case error(String)
    }
}
