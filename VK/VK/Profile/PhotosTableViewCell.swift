import UIKit
import StorageService

class PhotosTableViewCell: UITableViewCell {
    
    private let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "photos_title".localized
        headerLabel.textColor = .black 
        headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return headerLabel
    }()
    
    private let arrowImageView: UIImageView = {
        let arrowImageView = UIImageView(image: UIImage.init(systemName: "arrow.forward"))
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.tintColor = UIColor.black
        return arrowImageView
    }()

    private lazy var previewPhotoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let previewPhotoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        previewPhotoCollectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
        previewPhotoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        previewPhotoCollectionView.backgroundColor = .white
        previewPhotoCollectionView.showsHorizontalScrollIndicator = false
        return previewPhotoCollectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        previewPhotoCollectionView.dataSource = self
        previewPhotoCollectionView.delegate = self

        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }

}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        size.width = (contentView.frame.width - 12 * 2 - 8 * 3) / 4 // 12 - отступы слева и справа, 8 - отступы межу фото
        size.height = size.width
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension PhotosTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previewPhotoGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  previewPhotoCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as! PhotosCollectionViewCell
        cell.namePhoto = previewPhotoGallery[indexPath.item]
        return cell
    }
    
}

extension PhotosTableViewCell: UICollectionViewDelegate {
    
}

private extension PhotosTableViewCell {
    private func setupConstraints() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(previewPhotoCollectionView)
        contentView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            arrowImageView.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 25),
            arrowImageView.widthAnchor.constraint(equalTo: arrowImageView.heightAnchor ),
            
            previewPhotoCollectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            previewPhotoCollectionView.leadingAnchor.constraint(equalTo:
                                                                    headerLabel.leadingAnchor),
            previewPhotoCollectionView.heightAnchor.constraint(equalToConstant: (contentView.frame.width  - 12 * 2 - 8 * 3) / 4),
            previewPhotoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            previewPhotoCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
                        
        ])
    }
    
}
