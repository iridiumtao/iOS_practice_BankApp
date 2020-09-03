//
//  ImageBlurAdjustViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/9/3.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class ImageBlurAdjustViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    var sliderValue = 10.0
    
    var imageBlurAdjustCompletionHandler:((Double) -> Void)?
    
    let blurView = APCustomBlurView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "neko")
        
        blurView.frame = imageView.bounds
        blurView.setBlurRadius(radius: CGFloat(sliderValue))
        
        imageView.addSubview(blurView)
        
        slider.value = Float(sliderValue)
        
    }
    

    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        sliderValue = Double(sender.value)
        //sliderValue = Double(String(format: "%.1f", sender.value))!
//        imageView.blurImage(intensity: CGFloat(sliderValue))
        print(sliderValue)
        

        
        blurView.frame = imageView.frame
        blurView.setBlurRadius(radius: CGFloat(sliderValue))
        
        view.addSubview(blurView)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        imageBlurAdjustCompletionHandler?(sliderValue)
    }
    

}

