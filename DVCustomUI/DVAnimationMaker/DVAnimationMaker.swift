//
//  DVAnimationMaker.swift
//  DVCustomUI
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public typealias DVAnimationMakerCompletion = () -> Void

public class DVAnimationMaker {
    
    private weak var layerElement: CALayer?
    
    // MARK: - Public
    
    init(element: CALayer) {
        self.layerElement = element
    }
    
    public func animate(withAnimations animations: [AnimationItem], duration: TimeInterval, key: String, completion: DVAnimationMakerCompletion? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        
        if animations.count == 1, let animation = animations.first?.animation {
            layerElement?.add(animation, forKey: key)
        } else {
            let basicAnimations = animations.map { $0.animation }
            let groupAnimation = DVAnimationMaker.packAnimations(animations: basicAnimations, duration: duration)
            layerElement?.add(groupAnimation, forKey: key)
        }
        CATransaction.commit()
    }
    
    public static func makeAnimation(key: DVAnimationKeyType, duration: TimeInterval, fromValue: Any?, toValue: Any?, beginTime: CFTimeInterval? = nil) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: key.rawValue)
        animation.duration = duration
        if let beginTime = beginTime {
            animation.beginTime = beginTime
        }
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    // MARK: Private
    
    private static func packAnimations(animations: [CABasicAnimation], duration: TimeInterval) -> CAAnimationGroup {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = animations
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.duration = duration
        return groupAnimation
    }
}

// MARK: - AnimationItem

public extension DVAnimationMaker {
    struct AnimationItem {
        fileprivate let animation: CABasicAnimation
        
        init(key: DVAnimationKeyType, duration: TimeInterval, fromValue: Any?, toValue: Any?, beginTime: CFTimeInterval? = nil) {
            let animation = DVAnimationMaker.makeAnimation(key: key, duration: duration, fromValue: fromValue, toValue: toValue, beginTime: beginTime)
            self.animation = animation
        }
    }
}

// MARK: - UIView ext

public extension UIView {
    var animMaker: DVAnimationMaker {
        return DVAnimationMaker(element: self.layer)
    }
}

// MARK: - CALayer ext

public extension CALayer {
    var animaMaker: DVAnimationMaker {
        return DVAnimationMaker(element: self)
    }
}

