//
//  GoogleSigninViewModel.swift
//  MVVM
//
//  Created by Akshay Singh on 11/06/25.
//
import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase

class GoogleSigninViewModel {
    
    func signInWithGoogle(viewController: UIViewController,completion:@escaping(AuthDataResult?,Error?) -> Void) {
        GIDSignIn.sharedInstance.signOut()
        guard let clientId = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            if let error = error {
                completion(nil,error)
            }
            guard let user = signInResult?.user,let idToken = user.idToken?.tokenString else {
                completion(nil,error)
                return
            }
            
            print("Token = ",user.accessToken.tokenString)
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    completion(nil,error)
                    return
                }
                else {
                    completion(result!,nil)
                }
            }
        }
    }
    
}
