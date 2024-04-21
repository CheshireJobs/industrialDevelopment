import Foundation
import UIKit

protocol PhotoService {
    func fetchPhotos(_ completion: @escaping ([UIImage]) -> Void)
}

class PhotosServise: PhotoService {
    func fetchPhotos(_ completion: @escaping ([UIImage]) -> Void) {
        completion(PhotosServise.photos)
    }
    
    static var photos: [UIImage] {
        [UIImage(named: "bell")!, UIImage(named: "dance")!,
         UIImage(named: "dancer")!, UIImage(named: "Dancing")!,
         UIImage(named: "Dani")!, UIImage(named: "Daniela")!,
         UIImage(named: "DoIt")!, UIImage(named: "Education")!,
         UIImage(named: "Eva")!, UIImage(named: "Home")!,
         UIImage(named: "bell")!, UIImage(named: "dance")!,
         UIImage(named: "dancer")!, UIImage(named: "Dancing")!,
         UIImage(named: "Dani")!, UIImage(named: "Daniela")!,
         UIImage(named: "DoIt")!, UIImage(named: "Education")!,
         UIImage(named: "Eva")!, UIImage(named: "Home")!,
         UIImage(named: "bell")!, UIImage(named: "dance")!,
         UIImage(named: "dancer")!, UIImage(named: "Dancing")!,
         UIImage(named: "Dani")!, UIImage(named: "Daniela")!,
         UIImage(named: "DoIt")!, UIImage(named: "Education")!,
         UIImage(named: "Eva")!, UIImage(named: "Home")!,
         UIImage(named: "bell")!, UIImage(named: "dance")!,
         UIImage(named: "dancer")!, UIImage(named: "Dancing")!,
         UIImage(named: "Dani")!, UIImage(named: "Daniela")!,
         UIImage(named: "DoIt")!, UIImage(named: "Education")!,
         UIImage(named: "Eva")!, UIImage(named: "Home")!,
        ]
    }
}
