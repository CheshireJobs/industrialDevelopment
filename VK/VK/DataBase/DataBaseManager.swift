import Foundation
import CoreData
import StorageService

class DataBaseManager {
    static let shared = DataBaseManager()
    
    private let persistentContainer: NSPersistentContainer
    private lazy var backgroundContext = persistentContainer.newBackgroundContext()
    
    func getPostsCount(filter: String) -> Int {
        let fetchRequest = Posts.fetchRequest()
        let predicate = NSPredicate(format: "%K LIKE %@", #keyPath(Posts.author), filter)
        if filter != "" {
            fetchRequest.predicate = predicate
        }
        do {
            let postsCount = try backgroundContext.count(for: fetchRequest)
            return postsCount
        } catch let error {
            print(error)
        }
        return 0
    }
    
    func saveToFavorites(post: MyPost) {
        let fetchRequest = Posts.fetchRequest()
        let predicate = NSPredicate(format: "%K LIKE %@", #keyPath(Posts.author), post.author)
        fetchRequest.predicate = predicate
        do {
            let posts = try backgroundContext.fetch(fetchRequest)
            if !posts.isEmpty{
                return
            }
            if let newPost = NSEntityDescription.insertNewObject(forEntityName: "Posts", into: backgroundContext) as? Posts {
                newPost.author = post.author
                newPost.image = post.image
                newPost.text = post.description
                newPost.likes = Int16(post.likes)
                newPost.views = Int16(post.views)
                
                try backgroundContext.save()
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteFromFavorites(index: Int) {
        let fetchRequest = Posts.fetchRequest()
        do {
            let posts = try backgroundContext.fetch(fetchRequest)
            backgroundContext.delete(posts[index])
            try backgroundContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func getFavoritesPost(index: Int, filter: String) -> MyPost {
        let fetchRequest = Posts.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchOffset = index
        let predicate = NSPredicate(format: "%K LIKE %@", #keyPath(Posts.author), filter)
        if filter != "" {
            fetchRequest.predicate = predicate
        }
        do {
            let posts = try backgroundContext.fetch(fetchRequest)
            if let post = posts.first {
                return MyPost(author: post.author ?? "",
                              image: post.image ?? "",
                              likes: Int(post.likes),
                              views: Int(post.views),
                              description: post.text ?? "")
            }
        } catch let error {
            print(error)
        }
        return MyPost.init(author: "", image: "", likes: 0, views: 0, description: "")
    }
    
    private init() {
        let container = NSPersistentContainer(name: "DataBaseModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        self.persistentContainer = container
    }
}
