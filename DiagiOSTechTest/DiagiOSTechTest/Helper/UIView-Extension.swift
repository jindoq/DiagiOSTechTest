//
//  UIView-Extension.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/3/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func createRoundCorner(_ radius: CGFloat = 4) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func createBorder(_ width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func zoomIn(_ isIn: Bool, complete: (() -> Void)? = nil) {
        let initialValue: CGFloat = isIn ? 0.8 : 1
        let endValue: CGFloat = isIn ? 1 : 0.8
        transform = transform.scaledBy(x: initialValue , y: initialValue)
        UIView.animate(withDuration: 0.35, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform.identity.scaledBy(x: endValue, y: endValue)
            }, completion: { _ in complete?() })
    }
}

class DiagView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() { }
}
