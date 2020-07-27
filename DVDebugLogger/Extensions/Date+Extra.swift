//
//  Date+Extra.swift
//  DebugLogger
//
//  Created by 6 on 23.07.2020.
//  Copyright © 2020 6. All rights reserved.
//

import Foundation

internal extension Date {
    
    private static let  debugDateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    var debugStringRepresentation: String {
        return type(of: self).debugDateFormatter.string(from: self)
    }
}
