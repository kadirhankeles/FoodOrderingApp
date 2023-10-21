//
//  RegisterViewModel.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 17.10.2023.
//

import Foundation
import UIKit
import FirebaseAuth

class RegisterViewModel {
    var isError = false
    var labelError = ""

    func createUser(mail: String, password: String, completion: @escaping (Bool, String) -> Void) {
        isError = false
        Auth.auth().createUser(withEmail: mail, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.isError = true
                if error.localizedDescription == "The email address is badly formatted." {
                    self?.labelError = "E-posta adresi hatalı biçimlendirilmiş."
                } else if error.localizedDescription == "The password must be 6 characters long or more." {
                    self?.labelError = "Şifreniz 6 karakter veya daha uzun olmalıdır."
                } else if error.localizedDescription == "The email address is already in use by another account." {
                    self?.labelError = "E-posta adresi zaten başka bir hesap tarafından kullanılıyor."
                }
            }
            completion(self?.isError ?? false, self?.labelError ?? "")
        }
    }
    

}

