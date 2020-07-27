//
//  CGFloat+Angle.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

extension CGFloat {
    static func radians(fromDegrees: CGFloat) -> CGFloat {
        return CGFloat(fromDegrees * .pi / 180)
    }

    static func degrees(fromRadians: CGFloat) -> CGFloat {
        return CGFloat(fromRadians * 180 / .pi)
    }
}
