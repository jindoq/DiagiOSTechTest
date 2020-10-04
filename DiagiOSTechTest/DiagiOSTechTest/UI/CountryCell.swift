//
//  CountryCell.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/3/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CountryCell: DiagTableCell {
    let dropDownView = DropDownView()
    let dateLbl = UIMaker.makeContentLabel()
    let newCasesTodayLbl = UIMaker.makeTitleLabel(fontSize: 35, color: UIColor.Diag.orange)
    let newCasesYesterdayLbl = UIMaker.makeTitleLabel(fontSize: 19, color: UIColor.Diag.title_font)
    let totalCasesTitleLbl = UIMaker.makeContentLabel(text: "Total cases")
    let totalCasesValueLbl = UIMaker.makeTitleLabel(fontSize: 31)
    lazy var recoveredBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Diag.green
        return view
    }()
    lazy var activeBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Diag.orange
        return view
    }()
    lazy var deathBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Diag.red
        return view
    }()
    let recoveredTitleLbl = UIMaker.makeContentLabel(text: "Recovered", color: UIColor.Diag.green)
    let recoveredValueLbl = UIMaker.makeTitleLabel(fontSize: 19)
    let activeTitleLbl = UIMaker.makeContentLabel(text: "Active",  color: UIColor.Diag.orange, alignment: .center)
    let activeValueLbl = UIMaker.makeTitleLabel(fontSize: 19, alignment: .center)
    let deathTitleLbl = UIMaker.makeContentLabel(text: "Deaths", color: UIColor.Diag.red, alignment: .right)
    let deathValueLbl = UIMaker.makeTitleLabel(fontSize: 19, alignment: .right)
    
    func setInitData() {
        dateLbl.text = "New cases at \(Date().dateFormat)"
        newCasesTodayLbl.text = "+0"
        newCasesYesterdayLbl.text = "+0 the day before"
        totalCasesValueLbl.text = "0"
        recoveredValueLbl.text = "0"
        activeValueLbl.text = "0"
        deathValueLbl.text = "0"
        deathBar.backgroundColor = UIColor.Diag.green
        activeBar.backgroundColor = UIColor.Diag.green
    }
    
    func setCurrentCountry(_ country: MCountry) {
        dropDownView.titleLbl.text = country.country
        dropDownView.layoutIfNeeded()
    }
    
    func configData(_ data: MDayOne, newCasesToday: Int?, newCasesYesterday: Int?) {
        dateLbl.text = "New cases at \(data.date!.toString())"
        newCasesTodayLbl.text = "\(newCasesToday?.newCasesDisplay ?? "No Data")"
        newCasesYesterdayLbl.text = "\(newCasesYesterday?.newCasesDisplay ?? "No Data") the day before"
        totalCasesValueLbl.text = data.confirmed.formatThousand
        deathBar.backgroundColor = UIColor.Diag.red
        activeBar.backgroundColor = UIColor.Diag.orange
        deathBar.snp.remakeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Double(data.deaths)/Double(data.confirmed))
        }
        activeBar.snp.remakeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(deathBar.snp.leading)
            make.width.equalToSuperview().multipliedBy(Double(data.active)/Double(data.confirmed))
        }
        recoveredValueLbl.text = data.recovered.formatThousand
        activeValueLbl.text = data.active.formatThousand
        deathValueLbl.text = data.deaths.formatThousand
    }
    
    override func setupView() {
        super.setupView()
        setInitData()
        dropDownView.icon.image = UIImage(named: "ic_country")
        let line = UIView()
        line.backgroundColor = UIColor.Diag.gray
        line.createRoundCorner(0.5)
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.Diag.gray
        addSubviews(views: dropDownView, dateLbl, newCasesTodayLbl, newCasesYesterdayLbl, line, totalCasesTitleLbl, totalCasesValueLbl, recoveredBar, recoveredTitleLbl, recoveredValueLbl, activeTitleLbl, activeValueLbl, deathTitleLbl, deathValueLbl, bottomLine)
        dropDownView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        dateLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(dropDownView.snp.bottom).inset(-padding)
        }
        newCasesTodayLbl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(dateLbl.snp.bottom).inset(-padding_12)
        }
        newCasesYesterdayLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(newCasesTodayLbl.snp.bottom).inset(-padding_12)
        }
        line.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(1)
            make.top.equalTo(newCasesYesterdayLbl.snp.bottom).inset(-padding_12)
        }
        totalCasesTitleLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(line.snp.bottom).inset(-padding_12)
        }
        totalCasesValueLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(totalCasesTitleLbl.snp.bottom).inset(-2)
        }
        recoveredBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(12)
            make.top.equalTo(totalCasesValueLbl.snp.bottom).inset(-padding_12)
        }
        recoveredTitleLbl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(recoveredBar.snp.bottom).inset(-4)
        }
        recoveredValueLbl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(padding)
            make.top.equalTo(recoveredTitleLbl.snp.bottom).inset(-2)
        }
        deathTitleLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(recoveredTitleLbl.snp.centerY)
            make.trailing.equalToSuperview().inset(padding)
        }
        deathValueLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(recoveredValueLbl.snp.centerY)
            make.trailing.equalToSuperview().inset(padding)
        }
        activeTitleLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(recoveredTitleLbl.snp.centerY)
            make.centerX.equalToSuperview().multipliedBy(1.1)
        }
        activeValueLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(recoveredValueLbl.snp.centerY)
            make.centerX.equalTo(activeTitleLbl.snp.centerX)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(recoveredValueLbl.snp.bottom).inset(-padding)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
        
        recoveredBar.addSubviews(views: deathBar, activeBar)
        deathBar.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0)
        }
        activeBar.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(deathBar.snp.leading)
            make.width.equalToSuperview().multipliedBy(0)
        }
    }
}

class DropDownView: DiagView {
    let actionBtn = UIButton()
    lazy var icon: UIImageView = {
        let ic = UIImageView()
        ic.contentMode = .scaleToFill
        return ic
    }()
    
    lazy var dropDownIcon: UIImageView = {
        let ic = UIImageView()
        ic.contentMode = .scaleToFill
        ic.image = UIImage(named: "ic_dropdown")
        ic.change(color: UIColor.Diag.blue)
        return ic
    }()
    
    let titleLbl = UIMaker.makeTitleLabel(fontSize: 19)
    
    override func setupView() {
        super.setupView()
        addSubviews(views: icon, titleLbl, dropDownIcon, actionBtn)
        icon.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.leading.top.equalToSuperview().inset(padding)
            make.bottom.equalToSuperview()
        }
        titleLbl.snp.makeConstraints { (make) in
            make.leading.equalTo(icon.snp.trailing).inset(-8)
            make.centerY.equalTo(icon.snp.centerY)
        }
        dropDownIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(icon.snp.centerY)
            make.width.height.equalTo(12)
            make.leading.equalTo(titleLbl.snp.trailing).inset(-8)
        }
        actionBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension UIImageView {
    func change(color: UIColor) {
        guard let image = image else { return }
        self.image = image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        tintColor = color
    }
}
