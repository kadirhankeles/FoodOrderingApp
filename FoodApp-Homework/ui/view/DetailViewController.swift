//
//  DetailViewController.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 12.10.2023.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var labelStar: UILabel!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelFoodDetail: UILabel!
    @IBOutlet weak var labelFoodCount: UILabel!
    @IBOutlet weak var labelFoodPrice: UILabel!
    
    var food: FoodModel?
    var star: String?
    var foodIndex: Int?
    var viewModel = DetailViewModel()
    var cartList = [CartModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let foodObject = food {
            if let imageURL = foodObject.yemek_resim_adi, let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(imageURL)") {
                imageFood.kf.setImage(with: url)
            }
            labelFoodName.text = foodObject.yemek_adi
            labelStar.text = star
            labelFoodDetail.text = viewModel.foodDetail["\(foodObject.yemek_adi!)"]
            _ = viewModel.totalPrice.subscribe(onNext: { price in
                self.labelFoodPrice.text = "\(price)₺"
            })
            labelFoodPrice.text = "\(foodObject.yemek_fiyat!)₺"
            _ = viewModel.foodCount.subscribe(onNext: { [weak self] count in
                self?.labelFoodCount.text = String(count)
            })
            _ = viewModel.cartList.subscribe(onNext: { cartList in
                self.cartList = cartList
            })

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.frepo.fetchCart(kullanici_adi: viewModel.currentUser())
    }
    

    @IBAction func buttonAdd(_ sender: UIButton) {
        viewModel.increaseFoodCount()
        viewModel.calculatePrice(price: Int((food?.yemek_fiyat)!)!)
    }
    
    @IBAction func buttonDrop(_ sender: Any) {
        viewModel.decreaseFoodCount()
        viewModel.calculatePrice(price: Int((food?.yemek_fiyat)!)!)
    }
    
    @IBAction func buttonAddToCart(_ sender: Any) {
        if let foodObject = food {
            viewModel.buttonAddClicked(foodObject: foodObject, cartList: cartList)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
}
