//
//  PresentationExtensions.swift
//  Movies
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit

// ************************************************
// MARK: - UICollectionViewCell
// ************************************************

extension UICollectionViewCell {
    
    public static var identifier: String {
        return String(describing: self)
    }
    
    public static var nibName: String {
        return self.identifier
    }
}

// ************************************************
// MARK: - UICollectionView
// ************************************************

extension UICollectionView {
    
    public func register<CellType: UICollectionViewCell>(_: CellType.Type) {
        self.register(UINib(nibName: CellType.nibName, bundle: nil), forCellWithReuseIdentifier: CellType.identifier)
    }
    
    public func dequeueReusableCell<CellType: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> CellType {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: CellType.identifier, for: indexPath) as? CellType else {
            fatalError("Could not dequeue cell with identifier: \(CellType.identifier)")
        }
        return cell
    }
}
