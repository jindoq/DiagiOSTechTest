//
//  RestWorldCell.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/4/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RestWorlCell: DiagTableCell {
    let dropDownView = DropDownView()
    
    override func setupView() {
        super.setupView()
        dropDownView.icon.image = UIImage(named: "ic_rest_of_world")
        dropDownView.titleLbl.text = "Rest of the world"
        dropDownView.dropDownIcon.isHidden = true
        
        addSubviews(views: dropDownView)
        dropDownView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
