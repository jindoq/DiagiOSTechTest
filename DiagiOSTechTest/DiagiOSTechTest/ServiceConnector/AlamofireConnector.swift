//
//  AlamofireConnector.swift
//  DiagiOSTechTest
//
//  Created by Duy Tu Tran on 10/1/20.
//  Copyright © 2020 Duy Tu Tran. All rights reserved.
//

import Foundation
import Alamofire

struct AlamofireConnector {
    func request(withApi api: URL?,
                 method: HTTPMethod,
                 params: [String: Any]? = nil,
                 header: HTTPHeaders? = nil,
                 success: @escaping (_ result: AnyObject) -> Void,
                 fail: ((_ error: DiagError) -> Void)?) {
        guard let api = api else { return }
        let encoding: ParameterEncoding = method == .post || method == .put || method == .delete ? JSONEncoding.default : URLEncoding.httpBody
        
        AF.request(api, method: method, parameters: params, encoding: encoding, headers: header)
            .responseJSON { (response) in
                self.response(response: response,
                              withSuccessAction: success,
                              failAction: fail)
        }
    }
    
    func response(response: AFDataResponse<Any>,
                  withSuccessAction success: @escaping (_ result: AnyObject) -> Void,
                  failAction fail: ((_ error: DiagError) -> Void)?) {
        if let code = response.response?.statusCode, code != 200 {
            if let message = (response.value as AnyObject)["message"] as? String {
                let error = DiagError(code: "error_\(code)", message: message)
                fail?(error)
                return
            }
            
            if let result = response.value,
                let error = getError(response: result as AnyObject) {
                fail?(error)
                return
            }
            
            let error = DiagError(code: "error_\(code)", message: "Server Error")
            fail?(error)
            return
        }
        
        if let value = response.value {
            success(value as AnyObject)
        } else {
            fail?(DiagError(code: "no_response_data", message: "No Response Data"))
        }
    }
    
    private func getError(response: AnyObject) -> DiagError? {
        var err: DiagError?
        if let error = response.value(forKeyPath: "error") as? [String], error.count > 0 {
            err = DiagError(code: "unknown_error", message: error.joined(separator: "\n"))
        }
        if let code = response["error_code"] as? Int {
            err?.code = String(code)
        }
        return err
    }
}
