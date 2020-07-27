//
// Layout.swift
// Hola
// 
// Created on 13.06.2020
// Copyright © 2020.  All rights reserved.

import UIKit

// MARK: - UIView extension

public extension UIView {
    var layout: Layout {
        return Layout(self)
    }
}

public struct Layout {
    
    private let element: UIView
    
    fileprivate init(_ element: UIView) {
        self.element = element
    }
    
    // MARK: - Fill to view
    
    public func fillToSafeAreaSuperview(inset: UIEdgeInsets = .zero) {
        element.translatesAutoresizingMaskIntoConstraints = false
        let superview = safeSuperview()
        
        if #available(iOS 11.0, *) {
            element.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: inset.top).isActive = true
            element.leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: inset.left).isActive = true
            element.rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -inset.right).isActive = true
            element.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -inset.bottom).isActive = true
        } else {
            var parentViewController: UIViewController? = superview.findViewController()
            
            if let vc = parentViewController, vc.view !== superview {
                parentViewController = nil
            }
            let topPin = parentViewController?.topLayoutGuide.bottomAnchor ?? superview.topAnchor
            let bottomPin = parentViewController?.bottomLayoutGuide.topAnchor ?? superview.bottomAnchor
            element.topAnchor.constraint(equalTo: topPin, constant: inset.top).isActive = true
            element.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: inset.left).isActive = true
            element.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -inset.right).isActive = true
            element.bottomAnchor.constraint(equalTo: bottomPin, constant: -inset.bottom).isActive = true
        }
    }
    
    public func fillToSafeAreaOfView(_ targetView: UIView, inset: UIEdgeInsets = .zero) {
        element.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            element.topAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.topAnchor, constant: inset.top).isActive = true
            element.leftAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.leftAnchor, constant: inset.left).isActive = true
            element.rightAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.rightAnchor, constant: -inset.right).isActive = true
            element.bottomAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.bottomAnchor, constant: -inset.bottom).isActive = true
        } else {
            var parentViewController: UIViewController? = targetView.findViewController()
            
            if let vc = parentViewController, vc.view !== targetView {
                parentViewController = nil
            }
            
            let topPin = parentViewController?.topLayoutGuide.bottomAnchor ?? targetView.topAnchor
            let bottomPin = parentViewController?.bottomLayoutGuide.topAnchor ?? targetView.bottomAnchor
            element.topAnchor.constraint(equalTo: topPin, constant: inset.top).isActive = true
            element.leftAnchor.constraint(equalTo: targetView.leftAnchor, constant: inset.left).isActive = true
            element.rightAnchor.constraint(equalTo: targetView.rightAnchor, constant: -inset.right).isActive = true
            element.bottomAnchor.constraint(equalTo: bottomPin, constant: -inset.bottom).isActive = true
        }
        
    }
    
    public func fillSuperview(inset: UIEdgeInsets = .zero) {
        safeSuperview()
        pinHorizontalEdgesToSuperView(leftPadding: inset.left, rightPadding: inset.right)
        pinVerticalEdgesToSuperView(topPadding: inset.top, bottomPadding: inset.bottom)
    }
    
    public func fillToView(_ view: UIView, inset: UIEdgeInsets = .zero) {
        pinHorizontalEdgesToView(view, leftPadding: inset.left, rightPadding: inset.right)
        pinVerticalEdgesToView(view, topPadding: inset.top, bottomPadding: inset.bottom)
    }
    
    // MARK: - H, V pin
    
    @discardableResult
    public func pinHorizontalEdgesToSuperView(leftPadding: CGFloat = 0, rightPadding: CGFloat = 0) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(leftPadding)-[view]-(rightPadding)-|",
                                                         options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                         metrics: ["leftPadding": leftPadding, "rightPadding": rightPadding],
                                                         views: ["view": element])
        safeSuperview().addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    public func pinHorizontalEdgesToView(_ targetView: UIView, leftPadding: CGFloat = 0, rightPadding: CGFloat = 0) -> [NSLayoutConstraint] {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(leftPadding)-[view]-(rightPadding)-|",
                                                         options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                         metrics: ["leftPadding": leftPadding, "rightPadding": rightPadding],
                                                         views: ["view": element])
        targetView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    public func pinVerticalEdgesToSuperView(topPadding: CGFloat = 0, bottomPadding: CGFloat = 0) -> [NSLayoutConstraint] {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(topPadding)-[view]-(bottomPadding)-|",
                                                         options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                         metrics: ["topPadding": topPadding, "bottomPadding": bottomPadding],
                                                         views: ["view": element])
        safeSuperview().addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    public func pinVerticalEdgesToView(_ targetView: UIView, topPadding: CGFloat = 0, bottomPadding: CGFloat = 0) -> [NSLayoutConstraint] {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(topPadding)-[view]-(bottomPadding)-|",
                                                         options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                         metrics: ["topPadding": topPadding, "bottomPadding": bottomPadding],
                                                         views: ["view": element])
        targetView.addConstraints(constraints)
        return constraints
    }
    
    // MARK: - Center
    
    @discardableResult
    public func centerSuperview() -> [NSLayoutConstraint] {
        let vertConstr = centerVertically()
        let horConstr = centerHorizontally()
        return [vertConstr, horConstr]
    }
    
    @discardableResult
    public func centerToView(_ targetView: UIView, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        element.translatesAutoresizingMaskIntoConstraints = false
        let vertConstr = element.centerYAnchor.constraint(equalTo: targetView.centerYAnchor, constant: constant)
        let horConstr = element.centerXAnchor.constraint(equalTo: targetView.centerXAnchor, constant: constant)
        vertConstr.isActive = true
        horConstr.isActive = true
        return [vertConstr, horConstr]
    }
    
    @discardableResult
    public func centerVertically(constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: element,
                                            attribute: .centerY,
                                            relatedBy: .equal,
                                            toItem: safeSuperview(),
                                            attribute: .centerY,
                                            multiplier: 1.0, constant: constant)
        safeSuperview().addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    public func centerVerticallyToView(_ targetView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = targetView.centerYAnchor.constraint(equalTo: targetView.centerYAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerHorizontally(constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: element,
                                            attribute: .centerX,
                                            relatedBy: .equal,
                                            toItem: safeSuperview(),
                                            attribute: .centerX,
                                            multiplier: 1.0, constant: constant)
        safeSuperview().addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    public func centerHorizontallyToView(_ targetView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = targetView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    // MARK: - Layout to pin
    
    
    @discardableResult
    public func leftEqualToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.leftAnchor.constraint(equalTo: safeSuperview().leftAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func rightEqualToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = element.rightAnchor.constraint(equalTo: safeSuperview().rightAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func topEqualToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = element.topAnchor.constraint(equalTo: safeSuperview().topAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func bottomEqualToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = element.bottomAnchor.constraint(equalTo: safeSuperview().bottomAnchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func pinTopToView(view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: element,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .top,
                                            multiplier: 1, constant: constant)
        safeSuperview().addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    public func pinBottomToView(view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: element,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .bottom,
                                            multiplier: 1, constant: constant)
        safeSuperview().addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    public func pinLeftToView(view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: element,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .left,
                                            multiplier: 1, constant: constant)
        safeSuperview().addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    public func pinRightToView(view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: element,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .right,
                                            multiplier: 1, constant: constant)
        safeSuperview().addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    public func leftEqualTo(_ pin: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.leftAnchor.constraint(equalTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func rightEqualTo(_ pin: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.rightAnchor.constraint(equalTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func topEqualTo(_ pin: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.topAnchor.constraint(equalTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func bottomEqualTo(_ pin: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.bottomAnchor.constraint(equalTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func topEquelToSafeSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        let superview = safeSuperview()
        let constraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            constraint = element.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant)
        } else {
            var parentViewController: UIViewController? = superview.findViewController()
            
            if let vc = parentViewController, vc.view !== superview {
                parentViewController = nil
            }
            
            let topPin = parentViewController?.topLayoutGuide.bottomAnchor ?? superview.topAnchor
            constraint = element.topAnchor.constraint(equalTo: topPin, constant: constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func bottomEquelToSafeSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        let superview = safeSuperview()
        let constraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            constraint = element.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: constant)
        } else {
            var parentViewController: UIViewController? = superview.findViewController()
            
            if let vc = parentViewController, vc.view !== superview {
                parentViewController = nil
            }
            
            let bottomPin = parentViewController?.bottomLayoutGuide.topAnchor ?? superview.bottomAnchor
            constraint = element.topAnchor.constraint(equalTo: bottomPin, constant: constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func leftEquelToSafeSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        let superview = safeSuperview()
        let constraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            constraint = element.leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: constant)
        } else {
            constraint = element.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func rightEquelToSafeSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        let superview = safeSuperview()
        let constraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            constraint = element.rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: constant)
        } else {
            constraint = element.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: constant)
        }
        constraint.isActive = true
        return constraint
    }
    
    //MARK: - Height, Width
    
    @discardableResult
    public func heightEqualToSuperview(multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: element,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: safeSuperview(),
                                            attribute: .height,
                                            multiplier: multiplier, constant: 0)
        safeSuperview().addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    public func widthEqualToSuperview(multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: element,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: safeSuperview(),
                                            attribute: .width,
                                            multiplier: multiplier, constant: 0)
        safeSuperview().addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    public func widthEqualTo(_ pin: NSLayoutDimension, constant: CGFloat = 0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.widthAnchor.constraint(equalTo: pin, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func heightEqualTo(_ pin: NSLayoutDimension, constant: CGFloat = 0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.heightAnchor.constraint(equalTo: pin, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func heightEqualTo(_ constant: CGFloat, priority: UILayoutPriority = .defaultHigh) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.heightAnchor.constraint(equalToConstant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func widthEqualTo(_ constant: CGFloat, priority: UILayoutPriority = .defaultHigh) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.widthAnchor.constraint(equalToConstant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    public func sizeEqualTo(_ size: CGSize) {
        heightEqualTo(size.height)
        widthEqualTo(size.width)
    }
    
    // MARK: - Greate, less then
    
    @discardableResult
    public func topLessThenOrEquel(_ pin: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.topAnchor.constraint(lessThanOrEqualTo: pin)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func topGreaterThanOrEqual(_ pin: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.topAnchor.constraint(greaterThanOrEqualTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func bottomLessThenOrEquel(_ pin: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.bottomAnchor.constraint(lessThanOrEqualTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func bottomGreaterThanOrEqual(_ pin: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.bottomAnchor.constraint(greaterThanOrEqualTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func leftLessThenOrEquel(_ pin: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.leftAnchor.constraint(lessThanOrEqualTo: pin)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func leftGreaterThanOrEqual(_ pin: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.leftAnchor.constraint(greaterThanOrEqualTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func rightLessThenOrEquel(_ pin: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.rightAnchor.constraint(lessThanOrEqualTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func rightGreaterThanOrEqual(_ pin: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        element.translatesAutoresizingMaskIntoConstraints = false
        let constraint = element.rightAnchor.constraint(greaterThanOrEqualTo: pin, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func topLessThenOrEquelSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        return topLessThenOrEquel(safeSuperview().topAnchor, constant: constant)
    }
    
    @discardableResult
    public func topGreaterThanOrEqualSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        return topGreaterThanOrEqual(safeSuperview().topAnchor, constant: constant)
    }
    
    @discardableResult
    public func bottomLessThenOrEquelSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        return bottomLessThenOrEquel(safeSuperview().bottomAnchor, constant: constant)
    }
    
    @discardableResult
    public func bottomGreaterThanOrEqualSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        return bottomGreaterThanOrEqual(safeSuperview().bottomAnchor, constant: constant)
    }
    
    @discardableResult
    public func leftLessThenOrEquelSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        return leftLessThenOrEquel(safeSuperview().leftAnchor, constant: constant)
    }
    
    @discardableResult
    public func leftGreaterThanOrEqualSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        return leftGreaterThanOrEqual(safeSuperview().leftAnchor, constant: constant)
    }
    
    @discardableResult
    public func rightLessThenOrEquelSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        return rightLessThenOrEquel(safeSuperview().rightAnchor, constant: constant)
    }
    
    @discardableResult
    public func rightGreaterThanOrEqualSuperview(constant: CGFloat = 0) -> NSLayoutConstraint {
        return rightGreaterThanOrEqual(safeSuperview().rightAnchor, constant: constant)
    }
}

// MARK: - Private

private extension Layout {
    @discardableResult private func safeSuperview() -> UIView {
        return checkForSuperview()
    }
    
    @discardableResult private func checkForSuperview() -> UIView {
        element.translatesAutoresizingMaskIntoConstraints = false
        guard let view = element.superview else {
            fatalError("You need to have a superview before you can add contraints")
        }
        return view
    }
}
