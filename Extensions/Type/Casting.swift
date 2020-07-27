//
//  Type+Extra.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension Int {
    var d: Double {return Double(self) }
    var f: CGFloat { return CGFloat(self) }
    var stringValue: String { return String(self) }
    var timeInterval: TimeInterval { return TimeInterval(self) }
}

public extension Double {
    var int: Int { return Int(self) }
    var f: CGFloat { return CGFloat(self) }
    var timeInterval: TimeInterval { return self as TimeInterval }
    var stringValue: String { return String(self) }
}

public extension Float {
    var d: Double { return Double(self) }
    var f: CGFloat { return CGFloat(self) }
    var int: Int { return Int(self) }
    var timeInterval: TimeInterval { return TimeInterval(self) }
    var stringValue: String { return String(self) }
}

public extension CGFloat {
    var float: Float { return Float(self) }
    var d: Double { return Double(self) }
    var int: Int { return Int(self) }
    var timeInterval: TimeInterval { return TimeInterval(self) }
}
