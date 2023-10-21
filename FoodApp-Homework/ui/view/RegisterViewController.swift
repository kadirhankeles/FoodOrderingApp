//
//  RegisterViewController.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 17.10.2023.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var tfMail: UITextField!
    @IBOutlet weak var tfPasswordOne: UITextField!
    @IBOutlet weak var tfPasswordTwo: UITextField!
    @IBOutlet weak var labelError: UILabel!
    
    var viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Kayıt Başarılı", message: "Giriş ekranına yönlendirileceksiniz.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))

        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func buttonRegisterPressed(_ sender: Any) {
        labelError.text = ""
        if let mail = tfMail.text, !mail.isEmpty,
           let passwordOne = tfPasswordOne.text, !passwordOne.isEmpty,
           let passwordTwo = tfPasswordTwo.text, !passwordTwo.isEmpty {
            
            if passwordOne == passwordTwo {
                viewModel.createUser(mail: mail, password: passwordOne, completion: { bool, string in
                    if bool {
                        self.labelError.text = self.viewModel.labelError
                    } else {
                        self.showAlert()
                    }
                })
            } else {
                labelError.text = "Şifreler Uyuşmuyor."
            }
        } else {
            labelError.text = "Tüm alanları doğru bir şekilde doldurunuz."
        }
        
    }
    
}
