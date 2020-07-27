//
//  Padding.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension CGFloat {
    static let padding = 16.f
}

public extension UIEdgeInsets {
    static func initWithPadding(_ padding: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}

public extension CGSize {
    static func square(size: CGFloat) -> CGSize {
        return CGSize(width: size, height: size)
    }
}
