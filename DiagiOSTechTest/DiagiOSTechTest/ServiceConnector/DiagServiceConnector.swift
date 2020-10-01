//
//  DiagServiceConnector.swift
//  DiagiOSTechTest
//
//  Created by Duy Tu Tran on 10/1/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import Alamofire

struct ServiceConnector {
    static fileprivate var connector = AlamofireConnector()
    static fileprivate func getHeader() -> HTTPHeaders? {
        return ["Content-Type":"application/json"]
    }
    
    static fileprivate func getUrl(from api: String) -> URL? {
        let apiUrl = "https://api.covid19api.com/" + api
        return URL(string: apiUrl)
    }
    
    static func get(_ api: String,
                    params: [String: Any]? = nil,
                    success: @escaping (_ result: AnyObject) -> Void,
                    fail: ((_ error: DiagError) -> Void)? = nil) {
        let apiUrl = getUrl(from: api)
        connector.request(withApi: apiUrl,
                          method: .get,
                          params: params,
                          header: getHeader(),
                          success: success,
                          fail: fail)
    }
    
    static func post(_ api: String,
                    params: [String: Any]? = nil,
                    success: @escaping (_ result: AnyObject) -> Void,
                    fail: ((_ error: DiagError) -> Void)? = nil) {
        
        let apiUrl = getUrl(from: api)
        connector.request(withApi: apiUrl,
                          method: .post,
                          params: params,
                          header: getHeader(),
                          success: success,
                          fail: fail)
    }
}
