import UIKit
import Foundation

class PhotosViewModel {
    var onStateChanged: ((State) -> Void)?
    
    private var state: State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    private(set) var photos = [UIImage]()
    private var photosService = PhotosServise()
    
    func send(_ action: Action) {
        switch action {
        case .viewIsReady:
            state = .loading
            getPhotos()
        }
    }
    
    private func getPhotos() {
        photosService.fetchPhotos { [weak self] photos in
            self?.photos = photos
            self?.state = .loaded
        }
    }
}

extension PhotosViewModel {
    enum Action {
        case viewIsReady
    }
    
    enum State {
        case initial
        case loading
        case loaded
    }
}
