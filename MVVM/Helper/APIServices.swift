//
//  APIServices.swift
//  MVVM
//
//  Created by Akshay Singh on 10/06/25.
//

import Foundation
import CustomCore

class APIServices {
    let core = CustomCore.APIService()
    static let shared = APIServices()
    
    func getRequest(url:String) async throws -> (Data,Int){
        let (data,statusCode) : (Data,Int) = try await core.getFetchDataUsingAsync(url: url)
        return (data,statusCode)
    }
    
    func postRequest(url:String,body:Data) ->String {
        print("Data Reached on APIServices = ",String(data: body, encoding: .utf8))
        return "You have successfully Registered"
    }
}

