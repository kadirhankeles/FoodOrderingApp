//
//  ProfileViewController.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 18.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var tfPasswordOne: UITextField!
    @IBOutlet weak var tfPasswordTwo: UITextField!
    
    @IBOutlet weak var buttonUpdate: UIButton!
    
    @IBOutlet weak var labelError: UILabel!
    
    var viewModel = ProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPasswordOne.isHidden = true
        tfPasswordTwo.isHidden = true
        buttonUpdate.isHidden = true
        labelName.text = viewModel.currentUser()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Şifre Değiştirildi", message: "Yeni şifrenizi kullanabilirsiniz.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
            self.viewModel.isEditing = false
            self.tfPasswordOne.isHidden = true
            self.tfPasswordTwo.isHidden = true
            self.buttonUpdate.isHidden = true
        }))

        self.present(alert, animated: true, completion: nil)

    }

    @IBAction func buttonLogout(_ sender: Any) {
        if viewModel.isError == false {
            viewModel.logout()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController,transitionOptions: .transitionCurlDown)
        }
    }
    
    @IBAction func buttonUpdate(_ sender: Any) {
        if let passwordOne = tfPasswordOne.text, !passwordOne.isEmpty,
           let passwordTwo = tfPasswordTwo.text, !passwordTwo.isEmpty {

            if passwordOne == passwordTwo {
                viewModel.updatePassword(password: passwordOne) { bool, string in
                    if bool {
                        self.labelError.text = self.viewModel.labelError
                    } else {
                        self.showAlert()
                    }
                }
            }
            
        }
    }
    
    @IBAction func buttonPencil(_ sender: Any) {
        viewModel.editClicked()
        if viewModel.isEditing {
            tfPasswordOne.isHidden = false
            tfPasswordTwo.isHidden = false
            buttonUpdate.isHidden = false
        } else {
            tfPasswordOne.isHidden = true
            tfPasswordTwo.isHidden = true
            buttonUpdate.isHidden = true
        }

    }
    
}
