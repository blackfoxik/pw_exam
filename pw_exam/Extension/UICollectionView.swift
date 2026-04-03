//
//  UICollectionView.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import UIKit

// MARK: - Safe Array Access Extension

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseId)
    }
}

extension UICollectionReusableView {
    
    // MARK: - Public properties
    
    static var reuseId: String { String(describing: Self.self) }
}
