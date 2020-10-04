//
//  GetCountriesWorker.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/3/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import UIKit

struct MCountry {
    var country: String
    var slug: String
    var isSelected = false
    var totalConfirmed: Int
    var totalDeaths: Int
    var totalRecovered: Int
    var totalActive: Int
    var newConfirmed: Int
    var newDeaths: Int
    var newRecovered: Int
    
    init(_ raw: AnyObject) {
        country = raw["Country"] as? String ?? ""
        slug = raw["Slug"] as? String ?? ""
        totalConfirmed = raw["TotalConfirmed"] as? Int ?? 0
        totalDeaths = raw["TotalDeaths"] as? Int ?? 0
        totalRecovered = raw["TotalRecovered"] as? Int ?? 0
        totalActive = totalConfirmed - totalDeaths - totalRecovered
        newConfirmed = raw["NewRecovered"] as? Int ?? 0
        newDeaths = raw["NewDeaths"] as? Int ?? 0
        newRecovered = raw["NewRecovered"] as? Int ?? 0
    }
    
    func getData(at index: Int) -> (color: UIColor, totalCases: String, newCases: String) {
        switch index {
        case 0:
            return (color: UIColor.Diag.orange, totalCases: totalConfirmed.formatThousand, newCases: newConfirmed.newCasesDisplay)
        case 1:
            return (color: UIColor.Diag.orange, totalCases: totalActive.formatThousand, newCases: newConfirmed.newCasesDisplay)
        default:
            return (color: UIColor.Diag.red, totalCases: totalDeaths.formatThousand, newCases: newDeaths.newCasesDisplay)
        }
    }
}

class GetCountriesWorker: DiagWorker<[MCountry]> {
    let api = "countries"
    
    override func parseReturnedData(_ raw: AnyObject) -> [MCountry]? {
        if let arr = raw as? [AnyObject] {
            return arr.map { (item) -> MCountry in
                MCountry(item)
            }
        }
        return []
    }
    
    override func execute() {
        ServiceConnector.get(api, success: successResponse, fail: failResponse)
    }
}
