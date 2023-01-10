import StorageService

protocol PostsService {
    func fetchPosts(_ completion: @escaping ([MyPost]) -> Void)
}

class FeedPostsService: PostsService {
    func fetchPosts(_ completion: @escaping ([MyPost]) -> Void) {
        completion(FeedPostsService.posts)
    }
    
    static var posts: [MyPost] {
        [MyPost(authorImage: "teslaBot", author: "Elon Mask", image: "teslaBot",likes: 999, views: 222, description: "Это будет компаньон-помощник человека в повседневных делах. Его первая версия не сможет работать на производстве из-за определенных ограничений. Робот будет обучен с помощью ИИ выполнять полезные задачи в домашней среде людей или на улице, в том числе брать на себя опасные, повторяющиеся и скучные задания — ловить кошку, ходить в магазин, встречать курьера."),
        MyPost(authorImage: "cheshireCat", author: "Chesrire Cat", image: "cheshireCat", likes: 19567, views: 10, description: "Понимать меня необязательно. Обязательно любить и кормить вовремя."),
        MyPost(authorImage: "f1", author: "f1", image: "f1", likes: 1, views: 352, description: "A cool photo of each driver from this season so far - Part II "),
        MyPost(authorImage: "ballet", author: "Ballet", image: "ballet", likes: 180, views: 935, description: "Even in silhouette she’s amazing!!")
        ]
    }
}
