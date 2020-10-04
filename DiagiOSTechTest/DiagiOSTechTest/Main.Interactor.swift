//
//  Main.Interactor.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/3/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation

extension MainViewController {
    func didGetCountries(_ countries: [MCountry]) {
        self.countries = countries
        if countries.count > 0 {
            self.countries[0].isSelected = true
            ui.countryCell.setCurrentCountry(countries[0])
            output.getDayOne(countries[0])
        }
    }
    
    func didGetDayOneSuccess(_ data: [MDayOne]) {
        guard data.count > 0, let todayData = data.last else {
            return
        }
        var newCasesToday: Int?
        var newCasesYesterday: Int?
        if data.count >= 2 {
            let yesterdayData = data[data.count - 2]
            newCasesToday = todayData.confirmed - yesterdayData.confirmed
        }
        if data.count >= 3 {
            let yesterdayData = data[data.count - 2]
            let twoDaysAgoData = data[data.count - 3]
            newCasesYesterday = yesterdayData.confirmed - twoDaysAgoData.confirmed
        }
        
        ui.countryCell.configData(todayData, newCasesToday: newCasesToday, newCasesYesterday: newCasesYesterday)
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

extension MainViewController {
    class Interactor {
        func getCountries() {
            GetCountriesWorker(successAction: output?.didGetCountries, failAction: nil).execute()
        }
        
        func getDayOne(_ country: MCountry) {
            let worker = GetDayOneWorker(successAction: output?.didGetDayOneSuccess, failAction: nil)
            worker.country = country.slug
            worker.execute()
        }
        
        private weak var output: MainViewController?
        init(controller: MainViewController) { output = controller }
    }
}
