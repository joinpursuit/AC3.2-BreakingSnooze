//
//  PresentingCollectionViewCell.swift
//  BreakingSnooze
//
//  Created by C4Q on 1/10/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import View2ViewTransition

class PresentingCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setUpConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewHierarchy () {
        _ = [contentImage,
             titleLabel,
             authorLabel,
             descriptionLabel
            ].map { self.contentView.addSubview($0) }
    }
    
    func setUpConstraints () {
        _ = [
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4.0),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4.0),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4.0),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            authorLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
            authorLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0),
            
            descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: authorLabel.bottomAnchor, constant: 3.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 2.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -2.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2.0)
            ].map { $0.isActive = true }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightHeavy)
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 8)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var contentImage: UIImageView = {
        let view: UIImageView = UIImageView(frame: self.contentView.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.clipsToBounds = true
        view.alpha = 0.35 //We chose .35 because that is both Kadell and Cris' favourite number between 40 and 30
        view.contentMode = .scaleAspectFill
        return view
    }()
}

