//
//  GetDayOneCases.swift
//  DiagiOSTechTest
//
//  Created by kakashi on 10/3/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation

extension Int {
    var newCasesDisplay: String {
        if self >= 0 {
            return "+\(self.formatThousand)"
        } else {
            return self.formatThousand
        }
    }
    
    var formatThousand: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = 5
        var formattedString = formatter.string(from: NSNumber(value: self))
        formattedString = formattedString != nil ? formattedString! : "\(self)"
        
        return formattedString!
    }
}

struct MDayOne {
    var active: Int
    var confirmed: Int
    var deaths: Int
    var recovered: Int
    var date: Date?
    
    init(_ raw: AnyObject) {
        active = raw["Active"] as? Int ?? 0
        confirmed = raw["Confirmed"] as? Int ?? 0
        deaths = raw["Deaths"] as? Int ?? 0
        recovered = raw["Recovered"] as? Int ?? 0
        if let str = raw["Date"] as? String {
            date = Date(iso8601String: str)
        }
    }
}

class GetDayOneWorker: DiagWorker<[MDayOne]> {
    var api = "dayone/country"
    var country: String?
    
    override func parseReturnedData(_ raw: AnyObject) -> [MDayOne]? {
        if let arr = raw as? [AnyObject] {
            return arr.map { (item) -> MDayOne in
                MDayOne(item)
            }
        }
        return []
    }
    
    override func execute() {
        if let co = country {
            api.append("/\(co)")
        }
        ServiceConnector.get(api, success: successResponse, fail: failResponse)
    }
}
