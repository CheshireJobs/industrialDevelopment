import Foundation
import CoreData
import StorageService

class DataBaseManager {
    static let shared = DataBaseManager()
    
    let persistentContainer: NSPersistentContainer
    var dataBaseManagerHelper: PostHandler?
    
    func saveToFavorites(post: MyPost) {
        let fetchRequest = Posts.fetchRequest()
        let predicate = NSPredicate(format: "%K LIKE %@", #keyPath(Posts.author), post.author)
        fetchRequest.predicate = predicate
        
        do {
            let posts = try persistentContainer.viewContext.fetch(fetchRequest)
            guard posts.isEmpty else {
                dataBaseManagerHelper?.alreadyExist()
                return
            }
            if var newPost = NSEntityDescription.insertNewObject(forEntityName: "Posts", into: persistentContainer.viewContext) as? Posts {
                
                newPost.author = post.author
                newPost.image = post.image
                newPost.text = post.description
                newPost.likes = Int16(post.likes)
                newPost.views = Int16(post.views)
                
                try persistentContainer.viewContext.save()
            }
        } catch let error {
            dataBaseManagerHelper?.cannotSavePost(error: error.localizedDescription)
        }
    }
    
    func deleteFromFavorites(post: Posts) {
        do {
            persistentContainer.viewContext.delete(post)
            try persistentContainer.viewContext.save()
        } catch let error {
           print(error)
        }
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
