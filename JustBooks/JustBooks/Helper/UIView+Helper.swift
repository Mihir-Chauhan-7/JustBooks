//
//  UIView+Helper.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 12/01/22.
//

import Foundation
import UIKit

extension UIView {
    func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}


