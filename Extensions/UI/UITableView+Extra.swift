//
//  UITableView+Extra.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import UIKit

public extension UITableView {
    
    func reusableCell<T: UITableViewCell>(withType type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Failed attempt to cast reuse cell to \(type) class name with identifier \(identifier)")
        }
        return cell
    }
    
    func setAutomaticDimension() {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 44.0
    }
    
    func scrollToBottom() {
        if let pathToLastRow = getLastRow() {
            self.scrollToRow(at: pathToLastRow, at: .bottom, animated: true)
        }
    }
    
    private func getLastRow() -> IndexPath? {
        let lastSectionIndex = self.numberOfSections - 1
        if lastSectionIndex < 0 {
            return nil
        }

        let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1
        if lastRowIndex < 0 {
            return nil
        }
        return IndexPath(row: lastRowIndex, section: lastSectionIndex)
    }
}

