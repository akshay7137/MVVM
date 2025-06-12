//
//  UserViewModel.swift
//  MVVM
//
//  Created by Akshay Singh on 11/06/25.
//

import Foundation
import CustomCore
import UIKit
class UserViewModel {
    
    let formValidation = CustomCore.Validation()
    let apiServices = APIServices()
    
    func validateUserInput(firstname:String,mobile:String,email:String,password:String,age:String,confirmPassword:String) -> (Bool,String?) {
        
        guard !firstname.isEmpty,formValidation.isValidName(firstname, regx: "^[a-zA-Z]{2,}(?: [a-zA-Z]{2,})+$") else {
            return (false,"Enter Valid Name")
        }
        
        guard mobile.count == 10 else {
            return (false,"Enter Valid Mobile Number")
        }
        
        guard !age.isEmpty,formValidation.validationAge(age: age) else {
            return (false,"Enter Valid Age")
        }
        
        guard !email.isEmpty,formValidation.isValidName(email, regx: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$") else {
            return (false,"Enter Valid Email")
        }
        
        guard !password.isEmpty,!confirmPassword.isEmpty else {
            return (false,"Password and ConfirmPassword Shouldn't be emty")
        }
        
        guard password == confirmPassword else {
            return (false,"Password and Confirm Password Should be Same")
        }
        
        let user = User(name: firstname, email: email, mobile: mobile, age: Int(age) ?? 0, password: password)
        print(user)
        do {
            let body = try JSONEncoder().encode(user)
            let response = apiServices.postRequest(url: "https:www.testing.com/api/v1/user", body: body)
            return (true,response)
        } catch {
            return (true,error.localizedDescription)
        }
        
        
        return (true,"")
    }
}
