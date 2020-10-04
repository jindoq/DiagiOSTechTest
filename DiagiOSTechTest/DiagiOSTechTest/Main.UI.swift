//
//  Main.UI.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/3/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension MainViewController {
    class UI: NSObject {
        let headerCell = HeaderCell()
        let countryCell = CountryCell()
        
        func getCells() -> [DiagTableCell] {
            return [headerCell, countryCell]
        }
    }
}

class HeaderCell: DiagTableCell {
    let titleLbl = UIMaker.makeTitleLabel(fontSize: 31, text: "Statistics")
    
    override func setupView() {
        super.setupView()
        addSubviews(views: titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalToSuperview().inset(padding/2)
            make.bottom.equalToSuperview()
        }
    }
}
