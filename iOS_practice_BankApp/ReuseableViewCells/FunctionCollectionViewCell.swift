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
    
    // 這行如果放在下面的function的話，好像也會變成只有最後一個cell有效果
    let blurView = APCustomBlurView()
    
    /// 虛化影像
    /// 從 cellForItemAt 中呼叫
    ///
    /// 由於在 cellForItemAt 中 addSubview 會導致眾多問題（僅最後一個cell有效果，或是效果會被重複疊加），因此透過 cellForItemAt 呼叫，並傳入 intensity。
    ///
    /// - parameter intensity: 圖片虛化的程度，0~20
    func blurImage(intensity: CGFloat) {
        blurView.setBlurRadius(radius: intensity)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
    }
}
