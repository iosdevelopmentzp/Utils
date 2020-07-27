//
//  TrimmingFunctions.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension CGFloat {
    func cropNegativeValues(defaultValue: CGFloat = 0) -> CGFloat {
        return self < 0 ? defaultValue : self
    }
}

public extension Double {
    func cropNegativeValues(defaultValue: Double = 0) -> Double {
        return self < 0 ? defaultValue : self
    }
}

public extension Int {
    func cropNegativeValues(defaultValue: Int = 0) -> Int {
        return self < 0 ? defaultValue : self
    }
}

public extension Float {
    func cropNegativeValues(defaultValue: Float = 0) -> Float {
        return self < 0 ? defaultValue : self
    }
}
