//
//  FoodDaoRepository.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 5.10.2023.
//

import Foundation
import Alamofire
import RxSwift
import FirebaseAuth

class FoodDaoRepository {
    var foodList = BehaviorSubject<[FoodModel]>(value: [FoodModel]())
    var starList = BehaviorSubject<[String]>(value: [String]())
    var cartList = BehaviorSubject<[CartModel]>(value: [CartModel]())
    var foodCount = BehaviorSubject<Int>(value: 1)
    var totalPrice = BehaviorSubject<Int>(value: 0)
    var starGenerated = false
    
    func fetchFood() {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php")
        
        AF.request(url!, method: .get).response { response in
            if let data = response.data {
                do {
                    //let rawResponse = try JSONSerialization.jsonObject(with: data)
                    //print(rawResponse)
                    let dataResponse = try JSONDecoder().decode(FoodResponse.self, from: data)
                    if let list = dataResponse.yemekler {
                        self.foodList.onNext(list)
                        if self.starGenerated == false {
                            let randomStars = self.generateRandomStars(count: list.count)
                            self.starList.onNext(randomStars)
                            self.starGenerated = true
                        }

                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }

    }
    
    func fetchCart(kullanici_adi: String) {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php")
        let params:Parameters = ["kullanici_adi":kullanici_adi]
        
        AF.request(url!, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    //let rawResponse = try JSONSerialization.jsonObject(with: data)
                    //print(rawResponse)
                    
                    let dataResponse = try JSONDecoder().decode(CartResponse.self, from: data)
                    print("------- Fetch Cart -------")
                    if let list = dataResponse.sepet_yemekler {
                        self.cartList.onNext(list)
                        //print(self.cartList.count)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func addFoodToCart(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String ) {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php")
        let params:Parameters = ["yemek_adi":yemek_adi, "yemek_resim_adi":yemek_resim_adi, "yemek_fiyat":yemek_fiyat,"yemek_siparis_adet":yemek_siparis_adet, "kullanici_adi":kullanici_adi]
        
        AF.request(url!, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let dataResponse = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("------- Add Food to Cart -------")
                    print("Başarı : \(dataResponse.success!)")
                    print("Mesaj : \(dataResponse.message!)")
                    if dataResponse.success == 1 {
                        self.fetchCart(kullanici_adi: kullanici_adi)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func deleteFoodFromCart(sepet_yemek_id: Int, kullanici_adi: String) {
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php")
        let params:Parameters = ["sepet_yemek_id": sepet_yemek_id, "kullanici_adi": kullanici_adi]
        
        AF.request(url!, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let dataResponse = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("------- Delete Food From Cart -------")
                    print("Başarı : \(dataResponse.success!)")
                    print("Mesaj : \(dataResponse.message!)")
                    if dataResponse.success == 1 {
                        self.fetchCart(kullanici_adi: kullanici_adi)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    

    
    private func generateRandomStars(count: Int) -> [String] {
        var randomStars = [String]()
        for _ in 0..<count {
            let randomStar = String(format: "%.1f", Double.random(in: 3.0...5.0))
            randomStars.append(randomStar)
        }
        return randomStars
    }
    
    func increaseFoodCount() {
        let newCount = (try? foodCount.value()) ?? 1
        foodCount.onNext(newCount + 1)
    }
    
    func decreaseFoodCount() {
        let currentCount = (try? foodCount.value()) ?? 1
        let newCount = max(currentCount - 1, 1)
        foodCount.onNext(newCount)
    }
    
    func calculatePrice(price: Int) {
        let currentCount = (try? foodCount.value()) ?? 1
        let newTotalPrice = Int(currentCount) * price
        totalPrice.onNext(newTotalPrice)
    }
    
    func currentUser() -> String{
        if let user = Auth.auth().currentUser, let email = user.email {
            if let atIndex = email.firstIndex(of: "@") {
                let username = email.prefix(upTo: atIndex)
                return String(username)
            }
        }
        return ""
    }
}
