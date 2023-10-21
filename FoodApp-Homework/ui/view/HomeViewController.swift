//
//  ViewController.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 5.10.2023.
//

import UIKit
import RxSwift
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var foodList = [FoodModel]()
    var starList = [String]()
    var viewModel = HomeViewModel()
    var cartList = [CartModel]()
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // viewModel.addFoodToCart(yemek_adi: "Su", yemek_resim_adi: "Su.png", yemek_fiyat: 2, yemek_siparis_adet: 4, kullanici_adi: "batu")
        //viewModel.deleteFoodFromCart(sepet_yemek_id: 27652, kullanici_adi: "batu")
        searchBar.delegate = self
        _ = viewModel.foodList.subscribe(onNext: { list in
            self.foodList = list
            self.collectionView.reloadData()
        })
        
        _ = viewModel.starList.subscribe(onNext: { doubleList in
            self.starList = doubleList
            self.collectionView.reloadData()
        })
        
        _ = viewModel.cartList.subscribe(onNext: { list in
            self.cartList = list
            print("Sepetin Güncel Hali: \(self.cartList.count)")
        })
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let kullanici_adi = viewModel.currentUser()
        print(kullanici_adi)
        viewModel.fetchFood()
        viewModel.fetchCart(kullanici_adi: kullanici_adi)
    }

    func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let design = UICollectionViewFlowLayout()
        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        design.minimumLineSpacing = 15
        design.minimumInteritemSpacing = 15
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 35) / 2
        design.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.4)
        collectionView.collectionViewLayout = design
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let data = sender as? FoodDetailData {
                let detailVC = segue.destination as! DetailViewController
                detailVC.food = data.food
                detailVC.star = data.star
            }
        }
    }
    
    @objc func buttonAddToCart(sender: UIButton) {
        sender.isEnabled = false
        let indexPath = IndexPath(row: sender.tag, section: 0)
        var food: FoodModel
        if viewModel.search {
            food = viewModel.filteredFoodList[indexPath.row]
        } else {
            food = foodList[indexPath.row]
        }
        viewModel.addButtonClicked(food: food, cartList: cartList)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.isEnabled = true
        }
    }
    
    func searchFood(adi: String) {
        if adi.isEmpty {
            viewModel.search = false
        } else {
            viewModel.filterFoodListByAdi(adi: adi, foodList: foodList, starList: starList )
            viewModel.search = true
        }
        collectionView.reloadData()
    }

    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.search == false ? foodList.count : viewModel.filteredFoodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCell
        cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.3
        var food: FoodModel
        if viewModel.search {
            food = viewModel.filteredFoodList[indexPath.row]
            cell.labelStar.text = viewModel.filteredStarList[indexPath.row]
        } else {
            food = foodList[indexPath.row]
            cell.labelStar.text = starList[indexPath.row]
        }
        cell.labelFoodName.text = food.yemek_adi
        if let imageURL = food.yemek_resim_adi, let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(imageURL)") {
            cell.imageFood.kf.setImage(with: url)
        }
        
        cell.labelPrice.text = "\(food.yemek_fiyat!)₺"

        cell.buttonAddToCart.tag = indexPath.row
        cell.buttonAddToCart.addTarget(self, action: #selector(buttonAddToCart), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedFood: FoodModel
        var selectedStar: String
        if viewModel.search {
            selectedFood = viewModel.filteredFoodList[indexPath.row]
            selectedStar = viewModel.filteredStarList[indexPath.row]
        } else {
            selectedFood = foodList[indexPath.row]
            selectedStar = starList[indexPath.row]
        }
        
        
        let data = FoodDetailData(food: selectedFood, star: selectedStar)
        performSegue(withIdentifier: "toDetail", sender: data)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFood(adi: searchText)
    }
}
