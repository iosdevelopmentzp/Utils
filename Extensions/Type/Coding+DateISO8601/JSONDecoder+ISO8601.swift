//
//  JSONDecoder+ISO8601.swift
//  WeatherNation
//
//  Created on 24.04.2020.
//  Copyright © 2020 DevIT-Team. All rights reserved.
//

import Foundation

public extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Formatter.iso8601withFractionalSeconds.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container,
                  debugDescription: "Invalid date: " + string)
        }
        return date
    }
}
