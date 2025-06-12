//
//  Country.swift
//  MVVM
//
//  Created by Akshay Singh on 10/06/25.
//

import Foundation

struct Country : Decodable {
    let name: Name?
    let idd: IDD?
    
    struct Name: Decodable {
        let common: String
    }
    
    struct IDD: Decodable {
        let root: String?
        let suffixes: [String]?
    }
}
