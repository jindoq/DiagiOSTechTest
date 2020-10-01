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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() { }
}

class DiagListController<C: DiagListCell<U>, U>: DiagController, UITableViewDataSource, UITableViewDelegate {
    var datasource = [U]() { didSet { tableView.reloadData() }}
    fileprivate let cellId = "cellId"
    
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