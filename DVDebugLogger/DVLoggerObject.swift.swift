//
//  LoggerObject.swift
//  DebugLogger
//
//  Created by 6 on 22.07.2020.
//  Copyright © 2020 6. All rights reserved.
//

import Foundation

internal struct DVLoggerObject: Codable {
    let type: String
    let priority: DVDebugLoggerPriority
    let content: String
    let date: Date
    let id: String
    let hashtags: [String]
}
