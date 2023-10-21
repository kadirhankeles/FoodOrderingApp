//
//  LoginViewController.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 17.10.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfMail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var labelError: UILabel!
    
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func buttonLoginPressed(_ sender: Any) {
        labelError.text = ""
        if let mail = tfMail.text, !mail.isEmpty,
           let password = tfPassword.text, !password.isEmpty {
            viewModel.loginUser(mail: mail, password: password, completion: { bool, string in
                if bool {
                    self.labelError.text = self.viewModel.labelError
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, transitionOptions: .transitionCurlUp)
                }
                
            })
        } else {
            labelError.text = "E-mail ve Şifre giriniz."
        }
    }
    
}
