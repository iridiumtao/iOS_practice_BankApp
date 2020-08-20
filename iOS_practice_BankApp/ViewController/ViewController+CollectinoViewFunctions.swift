//
//  ViewController+CollectinoViewFunctions.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/20.
//  Copyright © 2020 歐東. All rights reserved.
//
import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == currencyCollectionView {
            return 11
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 匯率的 cell
        if collectionView == currencyCollectionView {
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "Cell", for: indexPath)
              as! CurrencyCollectionViewCell
            
            // 設定文字 及 圖片
            cell.currencyTypeLabel.text = currencyList[indexPath.row].currencyName
            cell.buyLabel.text = String(format: "%.4f", currencyList[indexPath.row].buy)
            cell.sellLabel.text = String(format: "%.4f", currencyList[indexPath.row].sell)
            cell.currencyTypeImageView.image = UIImage(named: currencyList[indexPath.row].image)
            
            // 設定圓角
            cell.contentView.layer.cornerRadius = 10.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true

            // 設定陰影
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 10.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            cell.layer.backgroundColor = UIColor.clear.cgColor
            
            // euro icon by https://icons8.com/
            // nation icon made by Freepik from https://www.flaticon.com/
            
            
            return cell
            
        // 功能的 cell
        } else {
            let cell =
              collectionView.dequeueReusableCell(
                  withReuseIdentifier: "Cell", for: indexPath)
            as! FunctionCollectionViewCell
            
            
            cell.imageView.image = UIImage(named: functionList[indexPath.row].image)
            
            // 暫時先把圖片全部隱藏，之後弄成一個swichBar來開關
            cell.imageView.blurImage(intensity: 0.2)

            cell.imageView.layer.cornerRadius = 10.0
            cell.imageView.layer.masksToBounds = true
            cell.label.text = functionList[indexPath.row].image
            
            return cell
        }
    }
    
    // 按下功能後跳轉頁面，並傳值
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == functionCollectionView {
            // todo seuge
        }
    }
    
    // 設定每個cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == functionCollectionView {
            // 透過螢幕解析度計算 cell 大小
            let fullScreenSize = UIScreen.main.bounds.size
            return CGSize(width: (fullScreenSize.width - 60) / 3, height: (fullScreenSize.width - 60) / 3)
        } else {
            return CGSize(width: 192, height: 128)
        }
        
    }

}

extension UIImageView{
    /// 直接模糊化圖片
    func blurImage()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    /// 需要參數地模糊化圖片
    func blurImage(intensity: CGFloat) {
        let blurEffect = CustomIntensityVisualEffectView(effect: UIBlurEffect(style: .dark), intensity: intensity)
        blurEffect.frame = self.bounds
        blurEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // for supporting device rotation
        self.addSubview(blurEffect)
    }
}

/// 可調整參數地模糊化圖片
class CustomIntensityVisualEffectView: UIVisualEffectView {

    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
        animator.fractionComplete = intensity
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private var animator: UIViewPropertyAnimator!

}
