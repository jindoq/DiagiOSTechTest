//
//  DiagWorker.swift
//  DiagiOSTechTest
//
//  Created by Duy Tu Tran on 10/1/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import Alamofire

class DiagWorker<U> {
    var successAction: ((U) -> Void)?
    var failAction: ((_ err: DiagError) -> Void)?
    
    init(successAction: ((U) -> Void)?, failAction: ((_ err: DiagError) -> Void)?) {
        self.successAction = successAction
        self.failAction = failAction
    }
    
    //Need override
    func parseReturnedData(_ raw: AnyObject) -> U? {return nil}
    func execute() {}
    
    final func successResponse(returnedData: AnyObject) {
        if let data = parseReturnedData(returnedData) {
            successAction?(data)
        }
    }

    final func failResponse(err: DiagError) {
        failAction?(err)
    }
}

struct DiagError {
    var code: String
    var message: String?
    var data: AnyObject?
    
    init(code: String, message: String? = nil, data: AnyObject? = nil) {
        self.code = code
        self.message = message
        self.data = data
    }
}
