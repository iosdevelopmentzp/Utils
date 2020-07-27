//
//  UICollectionView+Extra.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func reusableCell<T: UICollectionViewCell>(withType type: T.Type, identifier: String, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Failed attempt to cast reuse cell to \(type) class name with identifier \(identifier)")
        }
        return cell
    }
    
    func reusableSupplementaryView<T: UICollectionReusableView>(type: T.Type, ofKind: String, reuseIdentifier: String, forIndexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: reuseIdentifier, for: forIndexPath) as? T else {
            fatalError("Failed attempt to cast reuse view to \(type) class name with identifier \(reuseIdentifier)")
        }
        return view
    }
}
