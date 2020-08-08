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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
        currencyCollectionView.isPagingEnabled = true;

        functionCollectionView.delegate = self
        functionCollectionView.dataSource = self
        
        if let path = Bundle.main.path(forResource: "currency", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                currencyList = try! JSONDecoder().decode([Currency].self, from: data)
                print(currencyList)
            } catch {
                print("data read error!!!")
            }
        } else {
            print("file path error!!!")
        }
        
    }

}

// 能夠更改上方選單顯示的文字，比較好看
private typealias CollectionView = ViewController
extension CollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == currencyCollectionView {
            return 3
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
            cell.currencyTypeLabel.text = currencyList[indexPath.row].currencyName
            cell.buyLabel.text = String(format: "%.4f", currencyList[indexPath.row].buy)
            cell.sellLabel.text = String(format: "%.4f", currencyList[indexPath.row].sell)
            return cell
        } else {
            let cell =
              collectionView.dequeueReusableCell(
                  withReuseIdentifier: "Cell", for: indexPath)
            as! FunctionCollectionViewCell
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == functionCollectionView {
            // todo seuge
        }
    }
    
    
}

