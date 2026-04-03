//
//  DailyWeatherCell.swift
//  pw_exam
//
//  Created by Антон Лисицын on 02.04.2026.
//

import UIKit

class DailyWeatherCell: UICollectionViewCell {
    static let reuseID = "DailyWeatherCell"

    private let dayLabel = UILabel()
    private let iconImageView = UIImageView()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    private let stack = UIStackView()
    private let separatorView = UIView()
    private var imageLoadingTask: Task<(), Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        
        separatorView.backgroundColor = .separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        dayLabel.font = .systemFont(ofSize: 14)
        minTempLabel.font = .systemFont(ofSize: 14)
        maxTempLabel.font = .systemFont(ofSize: 14)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        stack.addArrangedSubview(dayLabel)
        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(minTempLabel)
        stack.addArrangedSubview(maxTempLabel)
 
        contentView.addSubview(stack)
        contentView.addSubview(separatorView)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with item: ForecastDay) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" 
        formatter.locale = Locale(identifier: "ru_RU")
        let dayDate = Self.date(from: item.date)
    
        dayLabel.text = formatter.string(from: dayDate)
        minTempLabel.text = "\(Int(item.day.mintempC))°"
        maxTempLabel.text = "\(Int(item.day.maxtempC))°"
        
        iconImageView.image = nil
        let imgUrl = item.day.condition.icon
        
        guard let url = URL(string: "https:" + imgUrl) else { return }
        if imageLoadingTask?.isCancelled == false {
            imageLoadingTask?.cancel()
        }
        imageLoadingTask = Task(priority: .medium) {
            do {
                let img = try await ImageLoader.shared.load(url)
                if imgUrl == item.day.condition.icon {
                        await MainActor.run {
                            self.iconImageView.image = img
                        }
                    } else {
                        //TODO: - Need to handle - show placeholder or show error
                    }
            }
            catch {
                print(error)
                //TODO: - Need to handle - show placeholder or show error
            }
        }
    }
    
    private static func date(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string) ?? Date()
    }
}
