//
//  File.swift
//  pw_exam
//
//  Created by Антон Лисицын on 02.04.2026.
//

import UIKit

final class CurrentWeatherCell: UICollectionViewCell {
    static let reuseID = "CurrentWeatherCell"
    private let regionLabel = UILabel()
    private let tempLabel = UILabel()
    private let conditionLabel = UILabel()
    private let feelsLikeLabel = UILabel()
    private let windLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {        
        regionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        regionLabel.textAlignment = .center
        
        tempLabel.font = .systemFont(ofSize: 48, weight: .bold)
        tempLabel.textAlignment = .center
        
        conditionLabel.font = .systemFont(ofSize: 16)
        conditionLabel.textAlignment = .center
        
        feelsLikeLabel.font = .systemFont(ofSize: 14)
        feelsLikeLabel.textAlignment = .center
        feelsLikeLabel.textColor = .secondaryLabel
        
        windLabel.font = .systemFont(ofSize: 14)
        windLabel.textAlignment = .center
        windLabel.textColor = .secondaryLabel
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        
        [regionLabel, tempLabel, conditionLabel, feelsLikeLabel, windLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with model: CurrentWeatherResponse) {
        let current = model.current
        let location = model.location
        
        regionLabel.text = location.region
        
        tempLabel.text = "\(Int(current.tempC))°"
        
        conditionLabel.text = current.condition.text
        
        feelsLikeLabel.text = "Ощущается как \(Int(current.feelslikeC))°"
        
        windLabel.text = "Ветер: \(Int(current.windKph)) км/ч"
    }
}
