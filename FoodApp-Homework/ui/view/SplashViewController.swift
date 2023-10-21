//
//  SplashViewController.swift
//  FoodApp-Homework
//
//  Created by Kadirhan Keles on 19.10.2023.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animationView = .init(name: "splash")
        view.addSubview(animationView!)
        
        animationView?.frame = view.bounds
        animationView?.center = view.center
        animationView?.alpha = 1
        
        animationView!.play { _ in
          UIView.animate(withDuration: 0.3, animations: {
            self.animationView?.alpha = 0
          }, completion: { _ in
            self.animationView?.isHidden = true
            self.animationView?.removeFromSuperview()
          })
        }
    }
    

}
