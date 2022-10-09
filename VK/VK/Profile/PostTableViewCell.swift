import UIKit
import StorageService
import iOSIntPackage
import SnapKit

final class PostTableViewCell: UITableViewCell {
    
//MARK: properties
    var post: MyPost! {
        didSet {
            postAuthorLabel.text = post!.author
            let imageProcessor = ImageProcessor()
            let sourcePhoto = UIImage(named: post!.image)
            imageProcessor.processImage(sourceImage: sourcePhoto!, filter: ColorFilter.fade, completion: {(filteredImage) in postImageView.image = filteredImage })
            postDescriptionLabel.text = post!.description
            let localized = NSLocalizedString("any_likes", comment: "")
            let formatted = String.localizedStringWithFormat(localized, post!.likes)
            postLikesLabel.text = formatted//"likes_title".localized + "\(String(describing: post!.likes))"
            postViewLabel.text = "views_title".localized + "\(String(describing: post!.views))"
        }
    }

    private let postAuthorLabel: UILabel = {
        let postAuthorLabel = UILabel()
        postAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        postAuthorLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        postAuthorLabel.textColor = .black
        postAuthorLabel.numberOfLines = 2
        return postAuthorLabel
    }()
    
    private let postImageView: UIImageView = {
        let postImageView = UIImageView()
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.contentMode = .scaleAspectFit
        postImageView.backgroundColor = .black
        return postImageView
    }()
    
    private let postDescriptionLabel: UILabel = {
        let postDescriptionLabel = UILabel()
        postDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        postDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        postDescriptionLabel.textColor = .systemGray
        postDescriptionLabel.numberOfLines = 0
        return postDescriptionLabel
    }()
    
    private let postLikesLabel: UILabel = {
        let postLikesLabel = UILabel()
        postLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        postLikesLabel.font = UIFont.systemFont(ofSize: 16)
        postLikesLabel.textColor = .black
        return postLikesLabel
    }()
    
    private let postViewLabel: UILabel = {
        let postViewsLabel = UILabel()
        postViewsLabel.translatesAutoresizingMaskIntoConstraints = false
        postViewsLabel.font = UIFont.systemFont(ofSize: 16)
        postViewsLabel.textColor = .black
        return postViewsLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupConstraints()
    }
}

//MARK: layout
private extension PostTableViewCell {
    func setupConstraints() {
        contentView.addSubview(postAuthorLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(postDescriptionLabel)
        contentView.addSubview(postLikesLabel)
        contentView.addSubview(postViewLabel)
        
        let constraints = [
            postAuthorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            postAuthorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postAuthorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            postImageView.topAnchor.constraint(equalTo: postAuthorLabel.bottomAnchor, constant: 12),
            postImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            postImageView.heightAnchor.constraint(equalTo:  postImageView.widthAnchor),
            postImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            postDescriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            postDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            postLikesLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 16),
            postLikesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postLikesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            postViewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postViewLabel.topAnchor.constraint(equalTo: postLikesLabel.topAnchor),
            postViewLabel.bottomAnchor.constraint(equalTo: postLikesLabel.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
