//
//  ViewController+CollectionViewFunctions.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/20.
//  Copyright © 2020 歐東. All rights reserved.
//
import UIKit

// ViewController 中 CollectionView 相關 function 以及 prepare for segue
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == currencyCollectionView {
            // 匯率
            return 11
        } else {
            // 九宮格功能按鈕
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FunctionCollectionViewCell
            
            cell.imageView.image = UIImage(named: functionList[indexPath.row].image)
            
            cell.blurImage(intensity: CGFloat(imageIntensity))

            cell.imageView.layer.cornerRadius = 10.0
            cell.imageView.layer.masksToBounds = true
            cell.label.text = functionList[indexPath.row].image
            
            return cell
        }
    }
    
    // 按下功能後跳轉頁面，並傳值
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == functionCollectionView {
            functionSelectedIndexPath = indexPath.row
            performSegue(withIdentifier: "FunctionSegue", sender: nil)
            
        }
    }
    
    // 設定每個cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == functionCollectionView {
            // 透過螢幕解析度計算 cell 大小，支援SE2 ~ Pro Max
            let fullScreenSize = UIScreen.main.bounds.size
            return CGSize(width: (fullScreenSize.width - 60) / 3, height: (fullScreenSize.width - 60) / 3)
        } else {
            return CGSize(width: 192, height: 128)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "FunctionSegue":
            // 去功能頁面

            let functionViewController = segue.destination as! FunctionViewController
            
            // 設定要顯示的資料
            if let selectedId = functionSelectedIndexPath {
                functionViewController.setTitle(title: "功能 \(selectedId + 1)")
                functionViewController.setImage(imageName: functionList[selectedId].image)
                functionViewController.setTextViewText(content: functionList[selectedId].content, url: functionList[selectedId].url)
            }
        case "ImageBlurAdjustSegue":
            // 去調整圖片模糊度頁面

            let imageBlurAdjustViewController = segue.destination as! ImageBlurAdjustViewController
            print("imageIntensity prepare \(self.imageIntensity)")
            imageBlurAdjustViewController.sliderValue = imageIntensity
            imageBlurAdjustViewController.imageBlurAdjustCompletionHandler = { value in
                self.imageIntensity = value
                self.defaults.set(value, forKey: defaultsKeys.blurIntensity)
                print("imageIntensity completion \(self.imageIntensity)")
                self.functionCollectionView.reloadData()

            }
            
            break
        case "LoginSegue":
            // 去登入頁面

            let loginViewController = segue.destination as! LoginViewController
            loginViewController.loginCompletionHandler = { UUID, memberType in
                //todo 在那邊呼叫 getUsername()，透過 uuid 顯示 username
                print("main: " + UUID)
                self.successfullyLoggedIn(memberType, UUID)
            }
        
        case "BlankPageSegue":
            // 去空白頁面
            
            let blankPageViewController = segue.destination as! BlankPageViewController
            blankPageViewController.receivedText = blankPageText
        default:
            break
        }
    }

}
