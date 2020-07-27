//
//  Formatter+iso8601.swift
//  WeatherNation
//
//  Created on 24.04.2020.
//  Copyright © 2020 DevIT-Team. All rights reserved.
//

import Foundation

public extension Formatter {
    static let iso8601withFractionalSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
