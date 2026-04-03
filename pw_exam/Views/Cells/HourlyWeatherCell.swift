//
//  HourlyWeatherCell.swift
//  pw_exam
//
//  Created by Антон Лисицын on 02.04.2026.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    static let reuseID = "HourlyWeatherCell"

    private let hourLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()
    private let stack = UIStackView()
    private var imageLoadingTask: Task<(), Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 4

        hourLabel.font = .systemFont(ofSize: 14)
        tempLabel.font = .systemFont(ofSize: 14)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(hourLabel)
        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(tempLabel)

        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with item: Hour) {
        hourLabel.text = Self.hourString(from: Self.date(from: item.time))
        tempLabel.text = "\(Int(item.tempC))°"
        
        iconImageView.image = nil
        let imgUrl = item.condition.icon
        guard let url = URL(string: "https:" + imgUrl) else { return }
        if imageLoadingTask?.isCancelled == false {
            imageLoadingTask?.cancel()
        }
        imageLoadingTask = Task(priority: .medium) {
            do {
                let img = try await ImageLoader.shared.load(url)
                if imgUrl == item.condition.icon {
                        await MainActor.run {
                            self.iconImageView.image = img
                        }
                    } else {
                        //TODO: - Need to handle - show placeholder or show error
                    }
            }
            catch {
                //TODO: - Need to handle - show placeholder or show error
            }
        }
    }
    
    private static func date(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = .current
        return formatter.date(from: string) ?? Date()
    }

    private static func hourString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: date)
    }
}
