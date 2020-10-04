//
//  Font-Extension.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/3/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit

enum DiagFont: String {
    case regular = "Muli-SemiBold"
    case medium = "Muli-Bold"
    
    static func regular(size: CGFloat) -> UIFont {
        return font(name: .regular, size: size)
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return font(name: .medium, size: size)
    }
    
    static func font(name: DiagFont, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name.rawValue, size: size) else { return UIFont.boldSystemFont(ofSize: size) }
        return font
    }
    
}
