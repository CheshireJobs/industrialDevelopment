import Foundation
import StorageService
import CoreData

class FavoritesViewModel {
    var onStateChanged: ((State) -> Void)?
    
    private let persistentContainer = DataBaseManager.shared.persistentContainer
    private var isLoaded = false

    lazy var fetchResultController: NSFetchedResultsController<Posts> = {
        let request: NSFetchRequest<Posts> = Posts.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Posts.likes), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    private(set) var state: State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    func send(action: Action) {
        switch action {
        case .viewIsReady:
            setUpFetchResultController()
        case .resetTapped:
            resetFilterFetchResultController()
        case let .setFilterTapped(text):
            setFilter(text: text)
        case let .deletePostSwiped(indexPath):
            deletePost(at: indexPath)
        }
    }
    
    func getPost(at indexPath: IndexPath) -> MyPost {
        let post = fetchResultController.object(at: indexPath)
        let myPost = MyPost(authorImage: post.authorImage ?? "",
                            author: post.author ?? "",
                            image: post.image ?? "",
                            likes: Int(post.likes),
                            views: Int(post.views),
                            description: post.text ?? "")
        return myPost
    }
    
    private func setUpFetchResultController() {
        if !isLoaded {
            isLoaded.toggle()
            persistentContainer.viewContext.perform {
                do{
                    try self.fetchResultController.performFetch()
                    self.state = .setUpFetchResultController
                } catch let error {
                    self.state = .error(error.localizedDescription)
                }
            }
        } else {
            self.state = .setUpFetchResultController
        }
    }
    
    private func resetFilterFetchResultController() {
        self.fetchResultController.fetchRequest.predicate = nil
        do {
            try self.fetchResultController.performFetch()
            self.state = .resetedFilterFetchResultController
        } catch let error {
            self.state = .error(error.localizedDescription)
        }
        self.state = .resetedFilterFetchResultController
    }
    
    private func setFilter(text: String) {
        let predicate = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Posts.author), text)
        self.fetchResultController.fetchRequest.predicate = predicate
        do {
            try self.fetchResultController.performFetch()
            self.state = .settedFilterFetchResultController
        } catch let error {
            self.state = .error(error.localizedDescription)
        }
    }
    
    private func deletePost(at indexPath: IndexPath) {
        let post = self.fetchResultController.object(at: indexPath)
        DataBaseManager.shared.deleteFromFavorites(post: post)
        self.state = .deletedPost
    }
}

extension FavoritesViewModel {
    enum State {
        case initial
        case setUpFetchResultController
        case resetedFilterFetchResultController
        case settedFilterFetchResultController // ???
        case deletedPost
        case error(String)
    }
    enum Action {
        case viewIsReady
        case resetTapped
        case setFilterTapped(String)
        case deletePostSwiped(at: IndexPath)
    }
}
