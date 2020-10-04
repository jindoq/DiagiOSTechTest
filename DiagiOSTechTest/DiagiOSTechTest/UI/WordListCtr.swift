//
//  WordListCtr.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/4/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class WorldListCtr: DiagController, UISearchBarDelegate {
    let listView = WorldListView()
    
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
    var countries = [MCountry]()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCountries = countries.filter { $0.country.lowercased().range(of: searchText.lowercased(), options: [.caseInsensitive]) != nil }
        searchActive = !searchText.isEmpty
        listView.datasource = searchActive ? filterCountries : countries
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Diag.background
        navigationItem.title = "Select Country"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_dismiss"), style: .done, target: self, action: #selector(dismissAction))
        listView.datasource = countries.sorted { (a, b) -> Bool in
            a.totalConfirmed > b.totalConfirmed
        }
    }
    
    @objc func dismissAction() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func setupView() {
        super.setupView()
        view.addSubviews(views: searchBar, listView)
        searchBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50)
        }
        listView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
}
