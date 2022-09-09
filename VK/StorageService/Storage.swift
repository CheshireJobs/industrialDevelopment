import Foundation

//MARK: DataSource
public struct MyPost {
    public let author: String
    public let image: String
    public let likes: Int
    public let views: Int
    public let description: String
    
    public init(author: String, image: String, likes: Int, views: Int, description: String) {
        self.author = author
        self.image = image
        self.likes = likes
        self.views = views
        self.description = description
    }
}

public let previewPhotoGallery  = [
    "bell",
    "dance",
    "dancer",
    "Dancing",
    "Dani",
    "Daniela",
    "DoIt",
    "Education"
]

public let photoGallery  = [
    "bell",
    "dance",
    "dancer",
    "Dancing",
    "Dani",
    "Daniela",
    "DoIt",
    "Education",
    "Eva",
    "Home",
    "Image",
    "Last",
    "Lord",
    "mila",
    "picture",
    "Repetto",
    "Tan",
    "Tava",
    "Thais",
    "Tumblr"
]

public let postTableModel = [
    MyPost(author: "Elon Mask", image: "teslaBot", likes: 999, views: 222, description: "Это будет компаньон-помощник человека в повседневных делах. Его первая версия не сможет работать на производстве из-за определенных ограничений. Робот будет обучен с помощью ИИ выполнять полезные задачи в домашней среде людей или на улице, в том числе брать на себя опасные, повторяющиеся и скучные задания — ловить кошку, ходить в магазин, встречать курьера."),
    MyPost(author: "Chesrire Cat", image: "cheshireCat", likes: 19567, views: 10, description: "Понимать меня необязательно. Обязательно любить и кормить вовремя."),
    MyPost(author: "f1", image: "f1", likes: 579, views: 352, description: "A cool photo of each driver from this season so far - Part II "),
    MyPost(author: "The Ballet Blog", image: "ballet", likes: 180, views: 935, description: "Even in silhouette she’s amazing!!")
]
