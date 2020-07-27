//
//  UIView+Extra.swift
//  DVLayout
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
