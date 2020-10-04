//
//  FilterCtr.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/4/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit

class FilterCtr: DiagHeaderListView<FilterHeader, String, FilterCell, MFilter> {
    var country: MCountry?
    let dateFilterView = DateFilterView()
    var statuses = (header: "Select status", cells: [MFilter(.confirmed, selected: true), MFilter(.recovered), MFilter(.deaths)])
    var filterData = (header: "Filter result", cells: [MFilter]())
    var fromDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    var toDate = Date()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(views: dateFilterView, table)
        dateFilterView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
        }
        table.snp.makeConstraints { (make) in
            make.top.equalTo(dateFilterView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        view.backgroundColor = UIColor.Diag.background
        navigationItem.title = country?.country
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_dismiss"), style: .done, target: self, action: #selector(dismissAction))
        dateFilterView.delegate = self
        datasource = [statuses, filterData]
        dateFilterView.configCell(from: fromDate, to: toDate)
        getFilter()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            return
        }
        let prev = statuses.cells[indexPath.row]
        for i in 0..<statuses.cells.count {
            statuses.cells[i].isSelected = false
        }
        statuses.cells[indexPath.row].isSelected = !prev.isSelected
        datasource = [statuses, filterData]
        getFilter()
    }
    
    @objc func dismissAction() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func getFilter() {
        let worker = GetFilterWorker(successAction: didGetFilterSuccess, failAction: nil)
        worker.country = country?.slug ?? ""
        worker.status = statuses.cells.first{ $0.isSelected }?.statusFilter?.rawValue ?? ""
        worker.from = fromDate.toISO8601String()
        worker.to = toDate.toISO8601String()
        worker.execute()
    }
    
    func didGetFilterSuccess(_ data: [MFilter]) {
        filterData.cells = data.reversed()
        datasource = [statuses, filterData]
    }
}

extension FilterCtr: DatePickerDelegate {
    func pickFromDate(_ date: Date) {
        fromDate = date
        getFilter()
    }
    
    func pickToDate(_ date: Date) {
        toDate = date
        getFilter()
    }
}

class FilterHeader: DiagListHeader<String> {
    let titleLbl = UIMaker.makeTitleLabel(color: .black)
    
    override func setupView() {
        super.setupView()
        let view = UIView()
        view.backgroundColor = UIColor.color(hex: "D6D9E4")
        addSubviews(views: view)
        view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        view.addSubviews(views: titleLbl)
        titleLbl.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview().inset(padding)
            maker.top.bottom.equalToSuperview().inset(padding_12)
        }
    }
    
    override func configHeader(_ title: String) {
        titleLbl.text = title
    }
}

class FilterCell: DiagListCell<MFilter> {
    let titleLbl = UIMaker.makeTitleLabel()
    let dateLbl = UIMaker.makeContentLabel()
    let icon = UIImageView()
    
    override var data: MFilter? {
        didSet {
            if let statusFilter = data?.statusFilter, let selected = data?.isSelected {
                dateLbl.isHidden = true
                icon.isHidden = false
                titleLbl.text = statusFilter.title
                icon.image = selected ? UIImage(named: "ic_history_selected") : UIImage(named: "ic_history_unselected")
            } else {
                dateLbl.isHidden = false
                icon.isHidden = true
                dateLbl.text = data?.date?.toString()
                titleLbl.text = "\(data!.status!.capitalized): \(data!.cases!.formatThousand)"
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        addSubviews(views: titleLbl, dateLbl, icon)
        titleLbl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(padding)
            make.top.bottom.equalToSuperview().inset(padding_12)
        }
        dateLbl.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
        }
        icon.contentMode = .scaleToFill
        icon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
    }
}
