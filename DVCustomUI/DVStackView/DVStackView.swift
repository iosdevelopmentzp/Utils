//
//  DVStackView.swift
//  DVCustomUI
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public class DVStackView: UIStackView {
    
    // MARK: Public
    
    init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0) {
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addBackground(color: UIColor, cornerRadius: CGFloat = 0) {
        let subView = UIView()
        subView.backgroundColor = color
        subView.layer.cornerRadius = cornerRadius
        insertSubview(subView, at: 0)
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subView.leftAnchor.constraint(equalTo: self.leftAnchor),
            subView.rightAnchor.constraint(equalTo: self.rightAnchor),
            subView.topAnchor.constraint(equalTo: self.topAnchor),
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    @discardableResult
    public func spacer() -> UIView {
        let view = UIView.spacer
        addArrangedSubview(view)
        return view
    }
    
    @discardableResult
    public func spacer(_ spacing: CGFloat, priority: UILayoutPriority = .defaultHigh) -> UIView {
        let view = UIView()
        let defaultSpacing = self.spacing * 2
        if defaultSpacing < spacing {
            let realNeedSpace = spacing - defaultSpacing
            view.translatesAutoresizingMaskIntoConstraints = false
            switch axis {
            case .horizontal:
                let widthConstraint = view.widthAnchor.constraint(equalToConstant: realNeedSpace)
                widthConstraint.priority = priority
                widthConstraint.isActive = true
            case .vertical:
                let heightConstraint = view.heightAnchor.constraint(equalToConstant: realNeedSpace)
                heightConstraint.priority = priority
                heightConstraint.isActive = true
            @unknown default: break
            }
        }
        addArrangedSubview(view)
        return view
    }
    
    @discardableResult
    public func addArrangedSubviewHavingPackedInContainerView(_ newView: UIView, containerHeight: CGFloat? = nil, containerWidth: CGFloat? = nil) -> UIView {
        let containerView = UIView()
        addArrangedSubview(containerView)
        containerView.addSubview(newView)
        if let height = containerHeight {
            containerView.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = containerView.heightAnchor.constraint(equalToConstant: height)
            heightConstraint.isActive = true
        }
        if let width = containerWidth {
            containerView.translatesAutoresizingMaskIntoConstraints = false
            let wifthtConstraint = containerView.widthAnchor.constraint(equalToConstant: width)
            wifthtConstraint.isActive = true
        }
        return containerView
    }
    
    public func packToPerpendicularStackView(views: [UIView], spacing: CGFloat = 0) {
        let newAxis: NSLayoutConstraint.Axis = self.axis == .horizontal ? .vertical : .horizontal
        let newStack = DVStackView(axis: newAxis, spacing: spacing)
        for view in views {
            newStack.addArrangedSubview(view)
        }
        addArrangedSubview(newStack)
    }
}

public extension UIView {
    static var spacer: UIView { return UIView() }
}

