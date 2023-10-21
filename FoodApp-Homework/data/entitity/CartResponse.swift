//
//  CartResponse.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 5.10.2023.
//

import Foundation

class CartResponse: Codable {
    var sepet_yemekler: [CartModel]?
    var success: Int?
}
