//
//  CartViewController.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 15.10.2023.
//

import UIKit
import Kingfisher
import RxSwift

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var cartList = [CartModel]()
    var viewModel = CartViewModel()
    @IBOutlet weak var labelTotalPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        _ = viewModel.cartList.subscribe(onNext: { cartList in
            self.cartList = cartList.reversed()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.labelTotalPrice.text = "\(self.viewModel.totalPrice(cartList: cartList))₺"
            }
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchCart(kullanici_adi: viewModel.currentUser())
        if cartList.count == 0 {
            //showAlert()
        }
    }
    
    @objc func buttonMinus(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let food = cartList[indexPath.row]
        sender.isEnabled = false
        if Int(food.yemek_siparis_adet!)! > 1 {
            viewModel.frepo.deleteFoodFromCart(sepet_yemek_id: Int(food.sepet_yemek_id!)!, kullanici_adi: viewModel.currentUser())
            viewModel.frepo.addFoodToCart(yemek_adi: food.yemek_adi!, yemek_resim_adi: food.yemek_resim_adi!, yemek_fiyat: Int(food.yemek_fiyat!)!, yemek_siparis_adet: Int(food.yemek_siparis_adet!)! - 1 , kullanici_adi: viewModel.currentUser())
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            sender.isEnabled = true
        }
        //alert verebilirsin vakit kalırsa

    }
    
    @objc func buttonPlus(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let food = cartList[indexPath.row]
        sender.isEnabled = false
        viewModel.frepo.deleteFoodFromCart(sepet_yemek_id: Int(food.sepet_yemek_id!)!, kullanici_adi: viewModel.currentUser())
        viewModel.frepo.addFoodToCart(yemek_adi: food.yemek_adi!, yemek_resim_adi: food.yemek_resim_adi!, yemek_fiyat: Int(food.yemek_fiyat!)!, yemek_siparis_adet: Int(food.yemek_siparis_adet!)! + 1 , kullanici_adi: viewModel.currentUser())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            sender.isEnabled = true
        }
        
        
    }
    
    @IBAction func buttonPay(_ sender: Any) {
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Sepetinizde ürün yok!", message: "Yeni Lezzetler keşfedeceğiniz sayfaya yönlendirileceksiniz. ", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, transitionOptions: .transitionCrossDissolve)
        }))

        present(alert, animated: true, completion: nil)

    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartCell
        let food = cartList[indexPath.row]
        cell.labelFoodName.text = food.yemek_adi
        if let imageURL = food.yemek_resim_adi, let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(imageURL)") {
            cell.imageViewFood.kf.setImage(with: url)
        }
        cell.labelFoodPrice.text = "\(Int(food.yemek_fiyat!)! * Int(food.yemek_siparis_adet!)!)₺"
        cell.labelFoodCount.text = food.yemek_siparis_adet
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.selectionStyle = .none
        cell.buttonMinus.tag = indexPath.row
        cell.buttonMinus.addTarget(self, action: #selector(buttonMinus), for: .touchUpInside)
        
        cell.buttonPlus.tag = indexPath.row
        cell.buttonPlus.addTarget(self, action: #selector(buttonPlus), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let food = cartList[indexPath.row]
            cartList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.frepo.deleteFoodFromCart(sepet_yemek_id: Int(food.sepet_yemek_id!)!, kullanici_adi: viewModel.currentUser())
            if cartList.count == 0 {
                showAlert()
            }
        }
    }



    
    
}
