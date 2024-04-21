//
//  PhotoCollectionViewCell.swift
//  Navigation
//
//  Created by Olen'ka Yurinova on 26.08.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    private let photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.image = UIImage.init(named: "f1")
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
//        photoImageView.backgroundColor = .black
        return photoImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .gray
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
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
