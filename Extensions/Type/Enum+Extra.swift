//
//  Enum+Extra.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import Foundation

public extension CaseIterable where Self: Equatable {
    mutating func next() -> Self {
        let allCases = Self.allCases
        guard let selfIndex = allCases.firstIndex(of: self) else { return self }
        let nextIndex = Self.allCases.index(after: selfIndex)
        return allCases[nextIndex == allCases.endIndex ? allCases.startIndex : nextIndex]
    }
}
