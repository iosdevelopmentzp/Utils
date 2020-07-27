//
//  DVAnimationKeyType.swift
//  DVCustomUI
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import Foundation

public extension DVAnimationMaker {
    enum DVAnimationKeyType: String {
        case scale = "transform.scale"
        case strokeEnd
        case borderColor
        case borderWidth
        case scaleY = "transform.scale.y"
        case scaleX = "transform.scale.x"
        case translationY = "transform.translation.y"
        case translationX = "transform.translation.x"
        case opacity
        case positionX = "position.x"
        case positionY = "position.y"
        case backgroundColor
        case bounds
        case position
        case zPosition
        case anchorPoint
        case anchorPointZ
        case hidden
        case doubleSided
        case sublayerTransform
        case masksToBounds
        case contents
        case contentsRect
        case contentsScale
        case contentsCenter
        case minificationFilterBias
        case cornerRadius
        case composingFilter
        case filters
        case backgroundFilters
        case shouldRasterize
        case rasterizationScale
        case shadowColor
        case shadowOpacity
        case shadowOffset
        case shadowRadius
        case shadowPat
        case transform
    }
}
