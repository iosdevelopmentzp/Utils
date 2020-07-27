//
//  UIScreen+ScreenBoundsInPoints.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension UIScreen {
    /// Device screen bounds in points in portrait orientation
    static var deviceBoundsInPoints: CGRect {
        let pixelWidth = UIScreen.main.nativeBounds.width
        let pixelHeight = UIScreen.main.nativeBounds.height
        let pointWidth = pixelWidth / UIScreen.main.nativeScale
        let pointHeight = pixelHeight / UIScreen.main.nativeScale
        return CGRect(origin: .zero, size: CGSize(width: pointWidth, height: pointHeight))
    }
}
