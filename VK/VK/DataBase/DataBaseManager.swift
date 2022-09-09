import Foundation
import CoreData
import StorageService

class DataBaseManager {
    static let shared = DataBaseManager()
    
    private let persistentContainer: NSPersistentContainer
    
    func getPostsCount() -> Int {
        let fetchRequest = Posts.fetchRequest()
        do {
            let posts = try persistentContainer.viewContext.fetch(fetchRequest)
            return posts.count
        } catch let error {
            print(error)
        }
        return 0
    }
    
    func doubleTaped(post: MyPost) {
        let fetchRequest = Posts.fetchRequest()
        do {
            let posts = try persistentContainer.viewContext.fetch(fetchRequest)
            if let index = posts.firstIndex(where: { $0.author == post.author}) {
                persistentContainer.viewContext.delete(posts[index])
                try persistentContainer.viewContext.save()
                return
            }
            if let newPost = NSEntityDescription.insertNewObject(forEntityName: "Posts", into: persistentContainer.viewContext) as? Posts {
                newPost.author = post.author
                newPost.image = post.image
                newPost.text = post.description
                newPost.likes = Int16(post.likes)
                newPost.views = Int16(post.views)
                
                try persistentContainer.viewContext.save()
            }
        } catch let error {
            print(error)
        }
    }
    
    func getFavoritesPosts() -> [MyPost] {
        let fetchRequest = Posts.fetchRequest()
        var favoritesPosts = [MyPost]()
        do {
            let posts = try persistentContainer.viewContext.fetch(fetchRequest)
            for post in posts {
                let author = post.author ?? ""
                let image = post.image ?? ""
                let likes = post.likes
                let views = post.views
                let description = post.text ?? ""
                
                favoritesPosts.append( MyPost(author: author, image: image, likes: Int(likes), views: Int(views), description: description ) )
            }
        } catch let error {
            print(error)
        }
        return favoritesPosts
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
