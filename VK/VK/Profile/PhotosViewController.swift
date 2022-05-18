import UIKit
import StorageService
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.backgroundColor = .white
        return photoCollectionView
    }()
    
    private var imageCollection: [UIImage] = [
        UIImage(named: "bell")!,
        UIImage(named: "dance")!,
        UIImage(named: "dancer")!,
        UIImage(named: "Dancing")!,
        UIImage(named: "Dani")!,
        UIImage(named: "Daniela")!,
        UIImage(named: "DoIt")!,
        UIImage(named: "Education")!,
        UIImage(named: "Eva")!,
        UIImage(named: "Home")!,
        UIImage(named: "bell")!,
        UIImage(named: "dance")!,
        UIImage(named: "dancer")!,
        UIImage(named: "Dancing")!,
        UIImage(named: "Dani")!,
        UIImage(named: "Daniela")!,
        UIImage(named: "DoIt")!,
        UIImage(named: "Education")!,
        UIImage(named: "Eva")!,
        UIImage(named: "Home")!
    ]
    
    private var imagePublisherFacade = ImagePublisherFacade()
    private var imageProcessor = ImageProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
        let start = DispatchTime.now()
        let end = DispatchTime.now()
        imageProcessor.processImagesOnThread(sourceImages: imageCollection, filter: .colorInvert, qos: .background, completion: { _ in })
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("time - \(timeInterval)")
        
        imagePublisherFacade.subscribe(self)
        imagePublisherFacade.addImagesWithTimer(time:  1, repeat: 22, userImages: imageCollection)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    deinit {
        imagePublisherFacade.removeSubscription(for: self)
        imagePublisherFacade.rechargeImageLibrary()
    }

}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        size.width = (view.frame.width - (8*4)) / 3
        size.height = size.width
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension PhotosViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollection.count
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as! PhotosCollectionViewCell
        cell.photoImageView.image = imageCollection[indexPath.item]
        return cell
   }
}

extension PhotosViewController: UICollectionViewDelegate {

}

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        imageCollection = images
        photoCollectionView.reloadData()
    }
}
                                    
private extension PhotosViewController {
    private func setupConstraints() {
        view.addSubview(photoCollectionView)
        
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo:
                                                            view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
