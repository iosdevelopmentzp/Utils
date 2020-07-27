//
//  JSONEncoder+ISO8601.swift
//  WeatherNation
//
//  Created on 24.04.2020.
//  Copyright © 2020 DevIT-Team. All rights reserved.
//

import Foundation

public extension JSONEncoder.DateEncodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        var container = $1.singleValueContainer()
        try container.encode(Formatter.iso8601withFractionalSeconds.string(from: $0))
    }
}
