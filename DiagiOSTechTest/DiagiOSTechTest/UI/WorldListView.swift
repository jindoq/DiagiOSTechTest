//
//  WorldListView.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/4/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class WorldListView: DiagListView<WorldCell, MCountry> {
    lazy var segment: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Total cases", "Active cases", "Deaths"])
        view.selectedSegmentIndex = 0
        view.setTitleTextAttributes([NSAttributedString.Key.font: DiagFont.medium(size: 15),
                                     NSAttributedString.Key.foregroundColor: UIColor.Diag.title_font],
                                    for: .normal)
        view.setTitleTextAttributes([NSAttributedString.Key.font: DiagFont.medium(size: 15),
                                     NSAttributedString.Key.foregroundColor: UIColor.black],
        for: .selected)
        view.addTarget(self, action: #selector(didSelectedStatusAction), for: UIControl.Event.valueChanged)
        return view
    }()
    
    @objc func didSelectedStatusAction() {
        switch segment.selectedSegmentIndex {
        case 0:
            datasource.sort { (a, b) -> Bool in
                a.totalConfirmed > b.totalConfirmed
            }
        case 1:
            datasource.sort { (a, b) -> Bool in
                a.totalActive > b.totalActive
            }
        default:
            datasource.sort { (a, b) -> Bool in
                a.totalDeaths > b.totalDeaths
            }
        }
        tableView.reloadData()
    }
    
    override func setupView() {
        super.setupView()
        addSubviews(views: segment, tableView)
        tableView.isHidden = true
        segment.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalToSuperview().inset(4)
            make.height.equalTo(30)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(segment.snp.bottom).inset(-padding_16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    let rowHeight: CGFloat = 50
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorldCell
        let data = datasource[indexPath.row].getData(at: segment.selectedSegmentIndex)
        cell.configCell(datasource[indexPath.row], index: indexPath.row, color: data.color, totalCases: data.totalCases, newCases: data.newCases)
        tableView.isHidden = false
        return cell
    }
}

class WorldCell: DiagListCell<MCountry> {
    let indexLbl = UIMaker.makeTitleLabel(color: UIColor.Diag.title_font)
    let countryLbl = UIMaker.makeContentLabel(fontSize: 17)
    let totalCasesLbl = UIMaker.makeTitleLabel(alignment: .right)
    let newCasesLbl = UIMaker.makeContentLabel(fontSize: 13)
    
    func configCell(_ data: MCountry, index: Int, color: UIColor, totalCases: String, newCases: String) {
        indexLbl.text = "\(index + 1)"
        countryLbl.text = data.country
        totalCasesLbl.text = totalCases
        newCasesLbl.text = newCases
        newCasesLbl.textColor = color
    }
    
    override func setupView() {
        super.setupView()
        let view = UIView()
        view.backgroundColor = UIColor.Diag.background
        addSubviews(views: view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.addSubviews(views: indexLbl, countryLbl, totalCasesLbl, newCasesLbl)
        indexLbl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
        }
        countryLbl.snp.makeConstraints { (make) in
            make.leading.equalTo(indexLbl.snp.trailing).inset(-8)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(totalCasesLbl.snp.leading).inset(-padding/2)
        }
        newCasesLbl.snp.makeConstraints { (make) in
            make.bottom.equalTo(totalCasesLbl.snp.bottom).inset(2)
            make.trailing.equalToSuperview().inset(padding)
        }
        totalCasesLbl.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(newCasesLbl.snp.leading).inset(-4)
        }
    }
}
