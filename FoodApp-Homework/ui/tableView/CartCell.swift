//
//  CartTableViewCell.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 15.10.2023.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var labelFoodCount: UILabel!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var labelFoodPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
