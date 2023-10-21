//
//  HomeViewModel.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 5.10.2023.
//

import Foundation
import RxSwift
import UIKit
import FirebaseAuth

class HomeViewModel {
    var foodList = BehaviorSubject<[FoodModel]>(value: [FoodModel]())
    var starList = BehaviorSubject<[String]>(value: [String]())
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    var search = false
    var filteredFoodList = [FoodModel]()
    var filteredStarList = [String]()
    var frepo = FoodDaoRepository()
    
    init() {
        foodList = frepo.foodList
        starList = frepo.starList
        cartList = frepo.cartList
    }
    
    func fetchFood() {
        frepo.fetchFood()
    }
    
    func fetchCart(kullanici_adi: String) {
        frepo.fetchCart(kullanici_adi: kullanici_adi)
    }
    
    func addFoodToCart(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String ) {
        frepo.addFoodToCart(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
    }
    
    func deleteFoodFromCart(sepet_yemek_id: Int, kullanici_adi: String) {
        frepo.deleteFoodFromCart(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
    
    func addButtonClicked(food: FoodModel, cartList: [CartModel]) {

        var sameName = false
        var cartFood = CartModel()
        
        for i in cartList {
            if i.yemek_adi == food.yemek_adi {
                sameName = true
                cartFood = i
                break
            } else {
                sameName = false
            }
        }
        
        if sameName == true {
            frepo.deleteFoodFromCart(sepet_yemek_id: Int(cartFood.sepet_yemek_id!)!, kullanici_adi: currentUser())
            frepo.addFoodToCart(yemek_adi: food.yemek_adi!, yemek_resim_adi: food.yemek_resim_adi!, yemek_fiyat: Int(food.yemek_fiyat!)! , yemek_siparis_adet: Int(cartFood.yemek_siparis_adet!)! + 1  , kullanici_adi: currentUser())
            print("Yemek Sepete eklendi: \(food.yemek_adi!) ")
        } else {
            frepo.addFoodToCart(yemek_adi: food.yemek_adi!, yemek_resim_adi: food.yemek_resim_adi!, yemek_fiyat: Int(food.yemek_fiyat!)! , yemek_siparis_adet: 1 , kullanici_adi: currentUser())
            print("Yemek Sepete eklendi: \(food.yemek_adi!) ")
        }
    }
    
    func filterFoodListByAdi(adi: String, foodList: [FoodModel], starList: [String]) {
        filteredFoodList = []
        filteredStarList = []
        for (i,food) in foodList.enumerated() {
            if let yemekAdi = food.yemek_adi, yemekAdi.contains(adi) {
                filteredFoodList.append(food)
                filteredStarList.append(starList[i])
            }
        }
    }
    
    func currentUser() -> String{
        frepo.currentUser()
    }
}


