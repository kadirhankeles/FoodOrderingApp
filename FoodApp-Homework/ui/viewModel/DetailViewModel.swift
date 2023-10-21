//
//  DetailViewModel.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 12.10.2023.
//

import Foundation
import RxSwift

class DetailViewModel {
    
    var frepo = FoodDaoRepository()
    
    var foodCount = BehaviorSubject<Int>(value: 1)
    var totalPrice = BehaviorSubject<Int>(value: 0)
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    var foodDetail: [String:String] = ["Ayran":"Fermente yoğurt içeceği",
                                       "Baklava":"hamur ve fıstıkla döşenmiş Türk tatlısı",
                                       "Fanta":"Portakal aromalı gazlı içecek",
                                       "Izgara Somon":"Izgara edilmiş somon balığı ve haşlanmış sebzeler",
                                       "Izgara Tavuk":"Izgara edilmiş tavuk göğsü ve haşlanmış sebzeler",
                                       "Kadayıf":"Tatlı, ince hamur işi ve şerbetle yapılır",
                                       "Kahve":"Özenle öğütülmüş kahve çekirdekleriyle yapılan içecek",
                                       "Köfte":"Kırmızı et ve beraberinde gelen pilav, patates kızartması",
                                       "Lazanya":"Katmanlar arasında makarna ve sos içeren fırınlanmış yemek",
                                       "Makarna":"Köfte topları eşliğinde soslanmış lezzet şöleni",
                                       "Pizza":"İnce hamur, sos ve farklı malzemeler ile yapılır",
                                       "Su":"Temel içecek, ph derecesi 7",
                                       "Sütlaç":"Süt ve pirinçle yapılan sütlü tatlı",
                                       "Tiramisu":"kahve ve mascarpone peyniri içerir."]
    
    init() {
        totalPrice = frepo.totalPrice
        foodCount = frepo.foodCount
        cartList = frepo.cartList
    }
    
    func addFoodToCart(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String ) {
        frepo.addFoodToCart(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
    }
    
    func deleteFoodFromCart(sepet_yemek_id: Int, kullanici_adi: String) {
        frepo.deleteFoodFromCart(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
    
    func fetchCart(kullanici_adi: String) {
        frepo.fetchCart(kullanici_adi: kullanici_adi)
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
    
    func buttonAddClicked(foodObject: FoodModel, cartList: [CartModel]){
        var sameName = false
        var cartFood = CartModel()
        
        for i in cartList {
            if i.yemek_adi == foodObject.yemek_adi {
                sameName = true
                cartFood = i
                break
            } else {
                sameName = false
            }
        }
        
        if sameName == true {
            frepo.deleteFoodFromCart(sepet_yemek_id: Int(cartFood.sepet_yemek_id!)!, kullanici_adi: currentUser())
            let foodCountValue = (try? self.foodCount.value()) ?? 1
            frepo.addFoodToCart(yemek_adi: foodObject.yemek_adi!, yemek_resim_adi: foodObject.yemek_resim_adi!, yemek_fiyat: Int(foodObject.yemek_fiyat!)! , yemek_siparis_adet:foodCountValue + Int(cartFood.yemek_siparis_adet!)! , kullanici_adi: currentUser())
            print("Yemek Sepete eklendi: \(foodObject.yemek_adi!) - \(foodCountValue)")
            
        } else {
            let foodCountValue = (try? self.foodCount.value()) ?? 1
            frepo.addFoodToCart(yemek_adi: foodObject.yemek_adi!, yemek_resim_adi: foodObject.yemek_resim_adi!, yemek_fiyat: Int(foodObject.yemek_fiyat!)! , yemek_siparis_adet:foodCountValue , kullanici_adi: currentUser())
            //print("Yemek Sepete eklendi: \(foodObject.yemek_adi!) - \(foodCountValue)")
            
        }
    }

    func currentUser() -> String{
        frepo.currentUser()
    }
}
