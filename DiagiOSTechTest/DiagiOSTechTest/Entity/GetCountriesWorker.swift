//
//  GetCountriesWorker.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/3/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation

struct MCountry {
    var country: String
    var slug: String
    var isSelected = false
    
    init(_ raw: AnyObject) {
        country = raw["Country"] as? String ?? ""
        slug = raw["Slug"] as? String ?? ""
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
