//
//  ProfileViewModel.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 18.10.2023.
//

import Foundation
import FirebaseAuth

class ProfileViewModel {
    var isEditing = false
    var isError = false
    var labelError = ""
    var frepo = FoodDaoRepository()
    func logout() {
        isError = false
        do {
            try Auth.auth().signOut()
        } catch {
            isError = true
            print(error.localizedDescription)
        }
    }
    
    func updatePassword(password: String, completion: @escaping (Bool, String) -> Void) {
        isError = false
        let user = Auth.auth().currentUser
        user?.updatePassword(to: password) { [weak self] error in
            if let error = error {
                if error.localizedDescription == "The password must be 6 characters long or more." {
                    self?.labelError = "Şifreniz 6 karakter veya daha uzun olmalıdır."
                }
            }
            completion(self?.isError ?? false, self?.labelError ?? "")
        }
    }
    
    func editClicked() {
        isEditing = !isEditing
    }
    
    func currentUser() -> String{
        frepo.currentUser()
    }
}
