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
        let globalCell = GlobalCell()
        let restWorldCell = RestWorlCell()
        
        func getCells() -> [DiagTableCell] {
            return [headerCell, countryCell, globalCell, restWorldCell]
        }
    }
}

class HeaderCell: DiagTableCell {
    let titleLbl = UIMaker.makeTitleLabel(fontSize: 31, text: "Statistics")
    let icon = UIImageView(image: UIImage(named: "ic_filter"))
    let actionBtn = UIButton()
    
    override func setupView() {
        super.setupView()
        icon.change(color: UIColor.Diag.blue)
        icon.contentMode = .scaleAspectFit
        addSubviews(views: titleLbl, icon, actionBtn)
        titleLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalToSuperview().inset(padding/2)
            make.bottom.equalToSuperview()
        }
        icon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(padding)
            make.centerY.equalTo(titleLbl.snp.centerY)
            make.height.width.equalTo(30)
        }
        actionBtn.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(100)
        }
    }
}
