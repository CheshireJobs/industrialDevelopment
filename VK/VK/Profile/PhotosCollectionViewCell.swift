//
import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    var namePhoto: String = "" {
        didSet {
            photoImageView.image = UIImage.init(named: namePhoto)
        }
    }
    
    private let photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 6
        photoImageView.clipsToBounds = true
        return photoImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupConstraints()
    }
    
}

private extension PhotosCollectionViewCell {
    func setupConstraints() {
        contentView.addSubview(photoImageView)

        let constraints = [
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
