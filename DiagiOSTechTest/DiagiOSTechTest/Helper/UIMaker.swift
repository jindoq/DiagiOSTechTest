//
//  UIMaker.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/3/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit

let padding: CGFloat = 20
let padding_16: CGFloat = 16
let padding_12: CGFloat = 12
struct UIMaker {
    static func makeContentLabel(fontSize: CGFloat = 15,
                                 text: String? = nil,
                                 isBold: Bool = false,
                                 color: UIColor = .white,
                                 numberOfLines: Int = 0,
                                 alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = isBold ? DiagFont.medium(size: fontSize): DiagFont.regular(size: fontSize)
        label.textColor = color
        label.textAlignment = alignment
        label.text = text
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    static func makeTitleLabel(fontSize: CGFloat = 17,
                                 text: String? = nil,
                                 isBold: Bool = true,
                                 color: UIColor = .white,
                                 numberOfLines: Int = 0,
                                 alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = isBold ? DiagFont.medium(size: fontSize): DiagFont.regular(size: fontSize)
        label.textColor = color
        label.textAlignment = alignment
        label.text = text
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byWordWrapping
        return label
    }
}
