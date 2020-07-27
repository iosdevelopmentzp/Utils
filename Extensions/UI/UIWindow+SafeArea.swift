//
//  UIWindow+SafeArea.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension UIWindow {
    
    static var safeAreaInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }
    
    static var bottomSafeAreaPadding: CGFloat {
        guard #available(iOS 11.0, *) else { return 0 }
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    static var topSafeAreaPadding: CGFloat {
        guard #available(iOS 11.0, *) else { return 0 }
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }
}
