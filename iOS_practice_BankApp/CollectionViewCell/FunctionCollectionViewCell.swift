//
//  FunctionCollectionViewCell.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/9.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class FunctionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    var imageIntensity = 10.0
    
    let blurView = APCustomBlurView()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib \(imageIntensity)")
        
    }
    
    func blurImage() {
        
        blurView.setBlurRadius(radius: CGFloat(imageIntensity))
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
    }
    

    
    
}
