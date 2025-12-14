//
//  UIColor+Extension.swift
//  Tracker
//
//  Created by Igor on 12.12.2025.
//

import UIKit

extension UIColor {
    static func getUIColor(index: Int) -> UIColor {
        if index >= 1 && index <= 18 {
            return UIColor(resource: .init(name: "TrackerColor\(index)", bundle: .main))
        }
        let randomNumber = Int.random(in: 1...18)
        return UIColor(resource: .init(name: "TrackerColor\(randomNumber)", bundle: .main))
    }
}
