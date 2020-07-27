//
//  UIWindow+VisibleViewController.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension UIWindow {
    static var visibleViewController: UIViewController? {
        return self.visibleViewController(viewController: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    private static func visibleViewController(viewController: UIViewController?) -> UIViewController? {
        if viewController?.presentedViewController == nil {
            return viewController
        } else if let navigationController = viewController as? UINavigationController {
            return self.visibleViewController(viewController: navigationController.topViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return self.visibleViewController(viewController: tabBarController.selectedViewController)
        } else {
            return self.visibleViewController(viewController: viewController?.presentedViewController)
        }
    }
}
