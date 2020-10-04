//
//  GetFilterWorker.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/4/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation

enum EStatus: String {
    case confirmed = "confirmed"
    case recovered = "recovered"
    case deaths = "deaths"
    
    var title: String {
        switch self {
        case .confirmed:
            return "Confirmed"
        case .recovered:
            return "Recovered"
        case . deaths:
            return "Deaths"
        }
    }
}

struct MFilter {
    var cases: Int?
    var status: String?
    var date: Date?
    var statusFilter: EStatus?
    var isSelected = false
    
    init(_ status: EStatus, selected: Bool = false) {
        statusFilter = status
        isSelected = selected
    }
    
    init(_ raw: AnyObject) {
        cases = raw["Cases"] as? Int
        status = raw["Status"] as? String
        if let str = raw["Date"] as? String {
            date = Date(iso8601String: str)
        }
    }
}

class GetFilterWorker: DiagWorker<[MFilter]> {
    var api = "country/%@/status/%@?from=%@&to=%@"
    var from = ""
    var to = ""
    var country = ""
    var status = ""
    
    override func parseReturnedData(_ raw: AnyObject) -> [MFilter]? {
          if let arr = raw as? [AnyObject] {
              return arr.map { (item) -> MFilter in
                  MFilter(item)
              }
          }
          return []
    }
    
    override func execute() {
        api = String(format: api, country, status, from, to)
        ServiceConnector.get(api, success: successResponse, fail: failResponse)
    }
}
