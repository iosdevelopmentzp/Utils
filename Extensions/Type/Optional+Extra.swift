//
//  Optional+Extra.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import Foundation

public extension Optional where Wrapped == String {
    var orEmpty: String {
        return self ?? ""
    }
}
