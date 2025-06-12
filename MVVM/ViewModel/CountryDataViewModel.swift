//
//  CountryDataViewModel.swift
//  MVVM
//
//  Created by Akshay Singh on 10/06/25.
//
import UIKit
import CustomCore

class CountryDataViewModel {
    let showMessage = CustomCore.ShowMessages()
    private(set) var countries: [Country] = []
    func getCountryCode() async -> ([Country],Error?) {
        
        do {
            let (data,statusCode) = try await APIServices.shared.getRequest(url: "https://restcountries.com/v3.1/all?fields=name,idd")
            if statusCode == 200 {
                self.countries = try JSONDecoder().decode([Country].self, from: data)
                countries.sort(by: {
                    ($0.name?.common ?? "") < ($1.name?.common ?? "")
                })
            }
            return (self.countries,nil)
        } catch let error {
            print("Error = ",error)
            return ([],error)
        }
        
    }
    
    func getCurrentCountry() -> Country? {
        
        guard let countryCode = Locale.current.regionCode else { return nil }
        let countryName = Locale(identifier: "en_US").localizedString(forRegionCode: countryCode)
        return countries.first(where: {$0.name?.common == countryName})
    }
}
