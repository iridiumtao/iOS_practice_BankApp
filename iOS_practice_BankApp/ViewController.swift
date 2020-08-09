//
//  ViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/3.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var currencyCollectionView: UICollectionView!
    @IBOutlet weak var functionCollectionView: UICollectionView!
    
    var currencyList: [Currency] = []
    var functionList: [MainPageFunction] = []
    
    fileprivate func decodeJson() {
        if let path1 = Bundle.main.path(forResource: "Currency", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path1), options: .alwaysMapped)
                currencyList = try! JSONDecoder().decode([Currency].self, from: data)
                print(currencyList)
            } catch {
                print("data read error!!!")
            }
        } else {
            print("file path error!!!")
        }
        
        if let path2 = Bundle.main.path(forResource: "FunctionContent", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path2), options: .alwaysMapped)
                functionList = try! JSONDecoder().decode([MainPageFunction].self, from: data)
            } catch {
                print("data read error!!!")
            }
        } else {
            print("file path error!!!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
        currencyCollectionView.isPagingEnabled = true;

        functionCollectionView.delegate = self
        functionCollectionView.dataSource = self
        
        decodeJson()
    }

}

// 能夠更改上方選單顯示的文字，比較好看
private typealias CollectionView = ViewController
extension CollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == currencyCollectionView {
            return 11
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            
            //cell.currencyTypeImageView.layer.shadowOpacity = 0.5
            //cell.currencyTypeImageView.layer.shadowRadius = 5.0
            //cell.currencyTypeImageView.clipsToBounds = true

            
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
            
            // TODO: 透過螢幕大小更改 constraints
            
            return cell
        } else {
            let cell =
              collectionView.dequeueReusableCell(
                  withReuseIdentifier: "Cell", for: indexPath)
            as! FunctionCollectionViewCell
            
            cell.imageView.image = UIImage(named: functionList[indexPath.row].image)
            cell.imageView.layer.cornerRadius = 10.0
            cell.imageView.layer.masksToBounds = true
            cell.label.text = functionList[indexPath.row].image
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == functionCollectionView {
            // todo seuge
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == functionCollectionView {
            let fullScreenSize = UIScreen.main.bounds.size
            return CGSize(width: (fullScreenSize.width - 60) / 3, height: (fullScreenSize.width - 60) / 3)
        } else {
            return CGSize(width: 192, height: 128)
        }
        
    }
    
    
    
}

