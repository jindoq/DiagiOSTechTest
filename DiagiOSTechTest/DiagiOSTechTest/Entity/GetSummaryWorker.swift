//
//  GetWorldTotalWorker.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/4/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation

struct MWorld {
    var totalDeaths: Int
    var totalConfirmed: Int
    var totalActive: Int
    var totalRecovered: Int
    var newConfirmed: Int
    var newDeaths: Int
    var date: Date?
    
    init(_ raw: AnyObject) {
        let global = raw["Global"] as AnyObject
        totalDeaths = global["TotalDeaths"] as? Int ?? 0
        totalRecovered = global["TotalRecovered"] as? Int ?? 0
        totalConfirmed = global["TotalConfirmed"] as? Int ?? 0
        totalActive = totalConfirmed - totalDeaths - totalRecovered
        newConfirmed = global["NewConfirmed"] as? Int ?? 0
        newDeaths = global["NewDeaths"] as? Int ?? 0
        if let str = raw["Date"] as? String {
            date = Date(iso8601String: str)
        }
    }
}

class GetSummaryWorker: DiagWorker<MWorld> {
    let api = "summary"
    
    override func parseReturnedData(_ raw: AnyObject) -> MWorld? {
        return MWorld(raw)
    }
    
    override func execute() {
        ServiceConnector.get(api, success: successResponse, fail: failResponse)
    }
}
