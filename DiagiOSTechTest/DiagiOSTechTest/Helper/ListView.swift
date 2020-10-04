//
//  ListView.swift
//  DiagiOSTechTest
//
//  Created by Duy Tu Tran on 10/1/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DiagController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    func setupView() {}
    
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
}

class DiagListCell<U>: DiagTableCell {
    var data: U?
}

class DiagTableCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() { }
}

class DiagListController<C: DiagListCell<U>, U>: DiagController, UITableViewDataSource, UITableViewDelegate {
    var datasource = [U]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let cellId = "cellId"
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        tb.separatorStyle = .none
        tb.register(C.self, forCellReuseIdentifier: cellId)
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 500
        tb.backgroundColor = .clear
        return tb
    }()
    
    override func setupView() {
        super.setupView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(at: indexPath)
    }
    func getCell(at index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: index) as! C
        cell.data = datasource[index.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
    func didSelectRow(at indexPath: IndexPath) { }
}

class DiagStaticListController: DiagController, UITableViewDelegate, UITableViewDataSource {
    var datasource = [UITableViewCell]() { didSet {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }}
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        tb.backgroundColor = .clear
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 500
        return tb
    }()
    
    override func setupView() {
        super.setupView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return datasource[indexPath.row] }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
    func didSelectRow(at indexPath: IndexPath) { }
}

class DiagListView<C: DiagListCell<U>, U>: DiagView, UITableViewDataSource, UITableViewDelegate {
    var datasource = [U]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let cellId = "cellId"
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        tb.backgroundColor = .clear
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 500
        tb.register(C.self, forCellReuseIdentifier: cellId)
        return tb
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! C
        cell.data = datasource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
    func didSelectRow(at indexPath: IndexPath) { }
}

class DiagHeaderListView<H: DiagListHeader<B>, B, C: DiagListCell<T>, T>: DiagController, UITableViewDataSource, UITableViewDelegate {
    lazy var table: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.backgroundColor = .clear
        tb.showsVerticalScrollIndicator = false
        tb.register(C.self, forCellReuseIdentifier: "Cell")
        tb.register(H.self, forHeaderFooterViewReuseIdentifier: "Header")
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 500
        tb.sectionHeaderHeight = UITableView.automaticDimension
        tb.estimatedSectionHeaderHeight = 500
        return tb
    }()
    
    var datasource = [(header: B, cells: [T])]() {
        didSet {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].cells.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? H
        header?.configHeader(datasource[section].header)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! C
        cell.data = datasource[indexPath.section].cells[indexPath.row]
        return cell
    }
}

class DiagHeader: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {}
}

class DiagListHeader<B>: DiagHeader {
    open func configHeader(_ data: B) {}
}
