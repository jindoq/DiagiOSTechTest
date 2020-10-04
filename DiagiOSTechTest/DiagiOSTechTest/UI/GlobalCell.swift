//
//  GlobalCell.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/4/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GlobalCell: DiagTableCell {
    let dropDownView = DropDownView()
    let confirmedValueLbl = UIMaker.makeTitleLabel(fontSize: 41, text: "0")
    let newConfirmedLbl = UIMaker.makeContentLabel(color: UIColor.Diag.orange)
    let totalCasesTitleLbl = UIMaker.makeContentLabel(text: "TOTAL CASES", color: UIColor.Diag.title_font)
    let chartView = UIView()
    let activeView = InfoView()
    let recoveredView = InfoView()
    let deathView = InfoView()
    let updatedDateLbl = UIMaker.makeContentLabel(fontSize: 13, text: "Updated at \(Date().dateFormat)", color: UIColor.Diag.title_font)
    
    func configData(_ data: MWorld) {
        newConfirmedLbl.text = data.newConfirmed.newCasesDisplay
        updatedDateLbl.text = "Updated at \(data.date!.toString())"
        activeView.configData(title: "ACTIVE", number: data.totalActive.formatThousand, color: UIColor.Diag.orange)
        recoveredView.configData(title: "RECOVERED", number: data.totalRecovered.formatThousand, color: UIColor.Diag.green)
        deathView.configData(title: "DEATHS", number: data.totalDeaths.formatThousand, color: UIColor.Diag.red, newCases: data.newDeaths.newCasesDisplay)
        confirmedValueLbl.text = data.totalConfirmed.formatThousand
        
        let pieChartView = PieChartView()
        pieChartView.backgroundColor = .clear
        chartView.addSubview(pieChartView)
        pieChartView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        pieChartView.setSegmentValues(totals: [data.totalActive, data.totalRecovered, data.totalDeaths], colors: [UIColor.Diag.orange, UIColor.Diag.green, UIColor.Diag.red])
    }
    
    override func setupView() {
        super.setupView()
        dropDownView.icon.image = UIImage(named: "ic_global")
        dropDownView.titleLbl.text = "World"
        dropDownView.dropDownIcon.isHidden = true
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.Diag.gray
        
        addSubviews(views: dropDownView, confirmedValueLbl, newConfirmedLbl, totalCasesTitleLbl, chartView, activeView, recoveredView, deathView, updatedDateLbl, bottomLine)
        dropDownView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        confirmedValueLbl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(dropDownView.snp.bottom).inset(-padding_12)
        }
        newConfirmedLbl.snp.makeConstraints { (make) in
            make.leading.equalTo(confirmedValueLbl.snp.trailing).inset(-8)
            make.bottom.equalTo(confirmedValueLbl.snp.bottom).inset(6)
        }
        totalCasesTitleLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(confirmedValueLbl.snp.bottom).inset(-4)
        }
        chartView.backgroundColor = .clear
        chartView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(totalCasesTitleLbl.snp.bottom).inset(-padding_12)
            make.trailing.equalTo(self.snp.centerX).offset(-padding/2)
            make.height.equalTo(chartView.snp.width)
        }
        activeView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.centerX)
            make.trailing.equalToSuperview()
            make.top.equalTo(chartView.snp.top)
        }
        recoveredView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.centerX)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(chartView.snp.centerY)
        }
        deathView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.centerX)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(chartView.snp.bottom)
        }
        updatedDateLbl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(chartView.snp.bottom).inset(-padding_12)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(updatedDateLbl.snp.bottom).inset(-padding)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
    }
}

class InfoView: DiagView {
    let icon = UIView()
    let statusLbl = UIMaker.makeContentLabel(color: UIColor.Diag.title_font)
    let numberLbl = UIMaker.makeTitleLabel()
    let newCasesLbl = UIMaker.makeContentLabel(fontSize: 11)
    
    func configData(title: String, number: String, color: UIColor, newCases: String? = nil) {
        statusLbl.text = title
        numberLbl.text = number
        icon.backgroundColor = color
        newCasesLbl.textColor = color
        newCasesLbl.text = newCases
    }
    
    override func setupView() {
        super.setupView()
        icon.backgroundColor = .clear
        icon.createRoundCorner(6)
        addSubviews(views: icon, statusLbl, numberLbl, newCasesLbl)
        icon.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.centerY.equalTo(statusLbl.snp.centerY)
            make.leading.equalToSuperview().inset(padding/2)
        }
        statusLbl.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(padding/2)
            make.leading.equalTo(icon.snp.trailing).inset(-8)
        }
        numberLbl.snp.makeConstraints { (make) in
            make.leading.equalTo(statusLbl.snp.leading)
            make.top.equalTo(statusLbl.snp.bottom).inset(-4)
            make.bottom.equalToSuperview()
        }
        newCasesLbl.snp.makeConstraints { (make) in
            make.leading.equalTo(numberLbl.snp.trailing).inset(-4)
            make.bottom.equalTo(numberLbl.snp.bottom).inset(2)
        }
    }
}
