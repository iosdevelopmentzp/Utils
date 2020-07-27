//
//  CGRect+Extra.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension CGRect {
    mutating func scale(_ percent: CGFloat) {
        self = self.insetBy(dx: self.width / 2 * (1.0 - percent), dy: self.height / 2 * (1.0 - percent))
    }
    
    func scaled(_ percent: CGFloat) -> CGRect {
        return self.insetBy(dx: self.width / 2 * (1.0 - percent), dy: self.height / 2 * (1.0 - percent))
    }
}
