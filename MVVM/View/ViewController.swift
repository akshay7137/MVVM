//
//  ViewController.swift
//  MVVM
//
//  Created by Akshay Singh on 10/06/25.
//

import UIKit
import CustomCore

class ViewController: UIViewController {

    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var stackViewMobile: UIStackView!
    @IBOutlet weak var buttonCode: UIButton!
    @IBOutlet weak var textFieldMobile: UITextField!
    @IBOutlet weak var textFieldAge: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonLoginWIthGoogle: UIButton!
    
    let countryViewModel = CountryDataViewModel()
    let googleSignInModel = GoogleSigninViewModel()
    var country : [Country] = []
    let coreMessages = CustomCore.ShowMessages()
    let userDataModel = UserViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCountryCode()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func onClickCode(_ sender: Any) {
        self.showDropdownOptions(countryCode: self.country)
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.clearTextField()
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        let isValid = userDataModel.validateUserInput(firstname: textFieldName.text ?? "", mobile: textFieldMobile.text ?? "", email: textFieldEmail.text ?? "", password: textFieldPassword.text ?? "", age: textFieldAge.text ?? "",confirmPassword: textFieldConfirmPassword.text ?? "")
        if isValid.0 == false {
            self.coreMessages.showToast(view: self.view, message: isValid.1 ?? "")
            return
        } else {
            self.coreMessages.showToast(view: self.view, message: isValid.1 ?? "")
        }
        self.clearTextField()
        
    }
    
    @IBAction func onClickGoogleLogin(_ sender: Any) {
        googleSignInModel.signInWithGoogle(viewController: self) { result,error in
            if let error = error {
                self.coreMessages.showToast(view: self.view, message: error.localizedDescription)
                return
            }
            guard let result = result else {
                self.coreMessages.showToast(view: self.view, message: "Something went wrong please try again!")
                return
            }
            print(result.user)
            self.coreMessages.showAlertSingleButton(viewController: self, title: "Google Login Success", message: "You have been successfully logged in")
        }
    }
    
}


extension ViewController {
    func setup() {
        self.labelTop.text = "Registration"
        labelTop.textColor = .systemBlue
        labelTop.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        labelTop.layer.shadowColor = UIColor.black.cgColor
        labelTop.layer.shadowRadius = 2.0
        labelTop.layer.shadowOpacity = 0.3
        labelTop.layer.shadowOffset = CGSize(width: 2, height: 2)
        labelTop.layer.masksToBounds = false
        labelTop.alpha = 0
        UIView.animate(withDuration: 3.0) {
            self.labelTop.alpha = 1
        }
        
        self.textfieldDesign(textField: textFieldName)
        self.textfieldDesign(textField: textFieldAge)
        self.textfieldDesign(textField: textFieldMobile)
        self.textfieldDesign(textField: textFieldEmail)
        self.textfieldDesign(textField: textFieldPassword)
        self.textfieldDesign(textField: textFieldConfirmPassword)
        
        
        
        buttonCancel.backgroundColor = .systemGray5
        buttonCancel.setTitleColor(.systemRed, for: .normal)
        buttonCancel.layer.cornerRadius = 8
        
        buttonSubmit.backgroundColor = .systemBlue
        buttonSubmit.setTitleColor(.white, for: .normal)
        buttonSubmit.layer.cornerRadius = 8
        buttonSubmit.layer.shadowColor = UIColor.black.cgColor
        buttonSubmit.layer.shadowOpacity = 0.2
        buttonSubmit.layer.shadowOffset = CGSize(width: 2, height: 2)
        buttonSubmit.layer.shadowRadius = 4
        
        self.buttonCode.layer.cornerRadius = 10
        buttonCode.layer.borderWidth = 1.0
        buttonCode.layer.borderColor = UIColor.gray.cgColor
        
        self.buttonLoginWIthGoogle.layer.cornerRadius = 10
        buttonLoginWIthGoogle.layer.borderWidth = 1.0
        buttonLoginWIthGoogle.layer.borderColor = UIColor.gray.cgColor
        
        self.hideKeyboardWhenTappedAround()
    }
}

extension ViewController {
    func textfieldDesign(textField:UITextField) {
        textField.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        textField.layer.addSublayer(bottomLine)
    }
    
    func clearTextField() {
        textFieldName.text = ""
        textFieldAge.text = ""
        textFieldMobile.text = ""
        textFieldEmail.text = ""
        textFieldPassword.text = ""
        textFieldConfirmPassword.text = ""
    }
}


extension ViewController {
    func getCountryCode() {
        Task {
            let (countries,error) = await countryViewModel.getCountryCode()
            if let error = error {
                DispatchQueue.main.async {
                    self.coreMessages.showToast(view: self.view, message: "Unable to fetch countries data \(error.localizedDescription)")
                }
            }
            self.country = countries
            if let currentCountry = countryViewModel.getCurrentCountry(),
               let root = currentCountry.idd?.root,
               let suffix = currentCountry.idd?.suffixes?.first {
                    let code = root + suffix
                DispatchQueue.main.async {
                    self.buttonCode.setTitle(code, for: .normal)
                }
                }
        }
    }
    
    func showDropdownOptions(countryCode:[Country]) {
        let alert = UIAlertController(title: "Select Country", message: nil, preferredStyle: .actionSheet)
        let options = countryCode
        
        for option in options {
            alert.addAction(UIAlertAction(title: option.name?.common, style: .default, handler: { _ in
                var appendedCountryCode : String = ""
                if let root = option.idd?.root,let suffixes = option.idd?.suffixes?.first {
                    appendedCountryCode = root + suffixes
                }
                self.buttonCode.setTitle(appendedCountryCode, for: .normal)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

extension ViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let bottomInset = keyboardFrame.height
        
        if textFieldConfirmPassword.isFirstResponder || textFieldPassword.isFirstResponder || textFieldEmail.isFirstResponder {
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -bottomInset / 2)
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
    
}
