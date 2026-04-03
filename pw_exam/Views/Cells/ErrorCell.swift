//
//  ErrorCell.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import UIKit

class ErrorCell: UICollectionViewCell {
    static let reuseID = "ErrorCell"
    
    let imageView = UIImageView()
    let label = UILabel()
    let button = UIButton(type: .system)
    let stackView = UIStackView()
    
    var reloadAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        setupViews()
        setupLayout()
    }
    
    func configure(with error: String, retryAction: @escaping () -> ()) {
        self.label.text = error
        self.reloadAction = retryAction
    }
    
    private func setupViews() {
        imageView.image = UIImage(systemName: "exclamationmark.triangle")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        
        var config = UIButton.Configuration.filled()
        config.title = "Retry"
        config.image = UIImage(systemName: "arrow.clockwise")
        config.imagePadding = 6
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .systemRed
        
        button.configuration = config
        button.addTarget(self, action: #selector(reloadTapped), for: .touchUpInside)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        
        contentView.addSubview(stackView)
    }
    
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
      
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36),

            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func reloadTapped() {
        reloadAction?()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
