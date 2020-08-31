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
    @IBOutlet weak var loginButton: UIButton!
    
    var currencyList: [Currency] = []
    var functionList: [MainPageFunction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
        currencyCollectionView.isPagingEnabled = true;

        functionCollectionView.delegate = self
        functionCollectionView.dataSource = self
        
        decodeJson()
        layoutSetting()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "LoginSegue", sender: nil)
    }
    
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
    
    fileprivate func layoutSetting() {
        // MARK: 根據螢幕大小調整 layout
        // constraint 的調整是透過 LayoutHelper，於 Storyboard 的 Constraints 中
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenHeight = UIScreen.main.bounds.height
        print(screenHeight)
        // iPhone 8 Plus 的長度
        if screenHeight > 736 {
            layout.minimumLineSpacing = 30
            loginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        } else {
            layout.minimumLineSpacing = 10
        }
        functionCollectionView.collectionViewLayout = layout
    }
}


