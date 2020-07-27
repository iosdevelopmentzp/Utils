//
//  UIDevice+ScreenSize.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension UIDevice {
    static var isSEScreenSizeType: Bool {
        return UIScreen.main.nativeBounds.height <= 1136
    }
    
    static var isIphone6ScreenSizeType: Bool {
        return UIScreen.main.nativeBounds.height <= 1334 && UIScreen.main.nativeBounds.height > 1136
    }
}
