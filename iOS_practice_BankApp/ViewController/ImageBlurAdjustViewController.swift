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
    
    // 基本上這個值不會被用到，segue prepare 的時候會覆寫掉
    var sliderValue = 10.0
    
    var imageBlurAdjustCompletionHandler:((Double) -> Void)?
    
    // 網路上的方法，使用方法如同 UIVisualEffectView，但是可以 setBlurRadius
    let blurView = APCustomBlurView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "neko")
        
        // 把 blur 的範圍設定的跟圖片的邊界一樣，大小沒有設定
        blurView.frame = imageView.bounds
        
        blurView.setBlurRadius(radius: CGFloat(sliderValue))
        
        imageView.addSubview(blurView)
        
        slider.value = Float(sliderValue)
    }

    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        sliderValue = Double(sender.value)
        
        blurView.frame = imageView.frame
        blurView.setBlurRadius(radius: CGFloat(sliderValue))
        
        view.addSubview(blurView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 利用閉包將 slider 的值回傳
        imageBlurAdjustCompletionHandler?(sliderValue)
    }
    

}

