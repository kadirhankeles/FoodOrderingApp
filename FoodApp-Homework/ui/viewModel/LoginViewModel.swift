//
//  LoginViewModel.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 17.10.2023.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    var isError = false
    var labelError = ""
    
    func loginUser(mail: String, password: String, completion: @escaping (Bool, String) -> Void) {
        isError = false
        Auth.auth().signIn(withEmail: mail, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.isError = true
                if error.localizedDescription == "The email address is badly formatted." {
                    self?.labelError = "E-posta adresi hatalı biçimlendirilmiş."
                } else if error.localizedDescription == "An internal error has occurred, print and inspect the error details for more information." {
                    self?.labelError = "Hatalı şifre girişi"
                }
                print(error.localizedDescription)
            }
            completion(self?.isError ?? false, self?.labelError ?? "")
        }
    }
    

}
