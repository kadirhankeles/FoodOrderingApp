//
//  CartViewModel.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 15.10.2023.
//

import Foundation
import RxSwift

class CartViewModel {
    var totalPrice = 0
    var frepo = FoodDaoRepository()
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    var foodPrice = BehaviorSubject<Int>(value: 0)
    var foodCount = BehaviorSubject<Int>(value: 1)
    
    var addingFood = false
    init() {
        cartList = frepo.cartList
        foodCount = frepo.foodCount
        foodPrice = frepo.totalPrice
    }
    
    func fetchCart(kullanici_adi: String) {
        frepo.fetchCart(kullanici_adi: kullanici_adi)
    }
    
    func deleteFoodFromCart(sepet_yemek_id: Int, kullanici_adi: String) {
        frepo.deleteFoodFromCart(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
    
    func increaseFoodCount() {
        frepo.increaseFoodCount()
    }
    
    func decreaseFoodCount() {
        frepo.decreaseFoodCount()
    }
    
    func calculatePrice(price: Int) {
        frepo.calculatePrice(price: price)
    }
    
    func totalPrice(cartList: [CartModel]) -> Int {
        totalPrice = 0
        for i in cartList {
            totalPrice += Int(i.yemek_siparis_adet!)! * Int(i.yemek_fiyat!)!
        }
        return totalPrice
    }
    
    func currentUser() -> String{
        frepo.currentUser()
    }
    
}
