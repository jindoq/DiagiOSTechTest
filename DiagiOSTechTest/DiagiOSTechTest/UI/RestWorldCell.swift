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
    let worldListView = WorldListView()
    
    func configData(countries: [MCountry]) {
        worldListView.datasource = countries.sorted { (a, b) -> Bool in
            a.totalConfirmed > b.totalConfirmed
        }
    }
    
    override func setupView() {
        super.setupView()
        dropDownView.icon.image = UIImage(named: "ic_rest_of_world")
        dropDownView.titleLbl.text = "Rest of the world"
        dropDownView.dropDownIcon.image = UIImage(named: "ic_search")
        dropDownView.dropDownIcon.change(color: UIColor.Diag.blue)
        
        addSubviews(views: dropDownView, worldListView)
        dropDownView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        worldListView.tableView.isScrollEnabled = false
        worldListView.snp.makeConstraints { (make) in
            make.top.equalTo(dropDownView.snp.bottom).inset(-padding_12)
            make.height.equalTo(worldListView.rowHeight*11)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(padding)
        }
    }
}
