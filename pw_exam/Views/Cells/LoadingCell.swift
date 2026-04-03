//
//  LoadingCell.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    static let reuseID = "LoadingCell"
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
