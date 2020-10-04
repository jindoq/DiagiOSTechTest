//
//  ViewController.swift
//  DiagiOSTechTest
//
//  Created by Duy Tu Tran on 10/1/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import UIKit

class MainViewController: DiagStaticListController {
    let ui = UI()
    lazy var output = Interactor(controller: self)
    var countries = [MCountry]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Diag.background
        datasource = ui.getCells()
        output.getCountries()
        ui.countryCell.dropDownView.actionBtn.addTarget(self, action: #selector(changeCountryAction), for: .touchUpInside)
    }

    @objc func changeCountryAction() {
        let vc = CountriesCtr()
        vc.datasource = countries
        vc.didSelectedCountry = { [weak self] country in
            guard let self = self  else {
                return
            }
            for i in 0..<self.countries.count {
                self.countries[i].isSelected = (self.countries[i].country == country.country)
            }
            self.ui.countryCell.setCurrentCountry(country)
            self.output.getDayOne(country)
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
}

