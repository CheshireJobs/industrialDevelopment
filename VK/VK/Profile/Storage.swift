import Foundation

//MARK: DataSource
struct MyPost {
    let author: String
    let image: String
    let likes: Int
    let views: Int
    let description: String
}

let previewPhotoGallery  = [
    "bell",
    "dance",
    "dancer",
    "Dancing",
    "Dani",
    "Daniela",
    "DoIt",
    "Education"
]

let photoGallery  = [
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

let postTableModel = [
    MyPost(author: "Elon Mask", image: "teslaBot", likes: 999, views: 222, description: "Это будет компаньон-помощник человека в повседневных делах. Его первая версия не сможет работать на производстве из-за определенных ограничений. Робот будет обучен с помощью ИИ выполнять полезные задачи в домашней среде людей или на улице, в том числе брать на себя опасные, повторяющиеся и скучные задания — ловить кошку, ходить в магазин, встречать курьера."),
    MyPost(author: "Chesrire Cat", image: "cheshireCat", likes: 19567, views: 10, description: "Понимать меня необязательно. Обязательно любить и кормить вовремя."),
    MyPost(author: "f1", image: "f1", likes: 579, views: 352, description: "A cool photo of each driver from this season so far - Part II "),
    MyPost(author: "The Ballet Blog", image: "ballet", likes: 180, views: 935, description: "Even in silhouette she’s amazing!!")
]
