//
//  CountriesCtr.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/4/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CountriesCtr: DiagListController<CountryTableCell, MCountry>, UISearchBarDelegate {
    var didSelectedCountry: ((MCountry) -> Void)?
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.delegate = self
        search.searchBarStyle = UISearchBar.Style.minimal
        search.placeholder = "Search by country"
        search.tintColor = .white
        if let textfield = search.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .white
        }
        return search
    }()
    var searchActive : Bool = false
    var filterCountries = [MCountry]()
    
    override func didSelectRow(at indexPath: IndexPath) {
        let country = searchActive ? filterCountries[indexPath.row] : datasource[indexPath.row]
        didSelectedCountry?(country)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func getCell(at index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: index) as! CountryTableCell
        cell.data = searchActive ? filterCountries[index.row] : datasource[index.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filterCountries.count : datasource.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Diag.background
        navigationItem.title = "Select Country"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_dismiss"), style: .done, target: self, action: #selector(dismissAction))
    }
    
    @objc func dismissAction() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func setupView() {
        super.setupView()
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50)
        }
        tableView.snp.remakeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCountries = datasource.filter { $0.country.lowercased().range(of: searchText.lowercased(), options: [.caseInsensitive]) != nil }
        searchActive = !searchText.isEmpty
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class CountryTableCell: DiagListCell<MCountry> {
    let countryLbl = UIMaker.makeTitleLabel()
    lazy var icon: UIImageView = {
        let ic = UIImageView()
        ic.contentMode = .scaleAspectFit
        ic.image = UIImage(named: "ic_tick")
        ic.change(color: UIColor.Diag.blue)
        return ic
    }()
    
    override var data: MCountry? {
        didSet {
            countryLbl.text = data?.country
            icon.isHidden = !(data?.isSelected ?? false)
        }
    }
    
    override func setupView() {
        super.setupView()
        let line = UIView()
        line.backgroundColor = UIColor.Diag.gray
        addSubviews(views: countryLbl, icon, line)
        countryLbl.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(padding)
            make.top.bottom.equalToSuperview().inset(padding_12)
        }
        icon.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        line.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
