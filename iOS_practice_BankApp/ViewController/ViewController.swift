//
//  ViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/3.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var currencyCollectionView: UICollectionView!
    @IBOutlet weak var functionCollectionView: UICollectionView!
    @IBOutlet weak var loginButton: UIButton!
    
    var currencyList: [Currency] = []
    var functionList: [MainPageFunction] = []
    var functionSelectedIndexPath: Int? = nil
    var blankPageText = ""
    var isLogin = false
    
    var imageIntensity = 10.0
    
    // 存在手機內部的資料
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
        currencyCollectionView.isPagingEnabled = true;

        functionCollectionView.delegate = self
        functionCollectionView.dataSource = self
        
        decodeJson()
        layoutSetting()
        
        // Navigation bar 按鈕
        let notificationButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notificationButtonClicked))
        let qrcodeButton = UIBarButtonItem(image: UIImage(systemName: "qrcode"), style: .plain, target: self, action: #selector(qrcodeButtonClicked))
        let locationButton = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(locationButtonClicked))

        // 將按鈕加入 navigation bar
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.setLeftBarButton(notificationButton, animated: true)
        navigationItem.setRightBarButtonItems([qrcodeButton, locationButton], animated: true)
        
        // 長按手勢(用於顯示圖片虛化的頁面)
        let longPressGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        longPressGestureRecognizer.minimumPressDuration = 0.5
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.delaysTouchesBegan = true
        self.functionCollectionView?.addGestureRecognizer(longPressGestureRecognizer)
        
        // 標題
        self.navigationItem.title = "銀行App"
        
        // 取得存在手機裡面的資料
        imageIntensity = defaults.double(forKey: defaultsKeys.blurIntensity)

        // 如果是第一次打開 App，回傳 false
        let isNotFirstTimeOpenApp = defaults.bool(forKey: defaultsKeys.isNotFirstTimeOpenApp)
        if !isNotFirstTimeOpenApp {
            imageIntensity = 10.0
            defaults.set(true, forKey: defaultsKeys.isNotFirstTimeOpenApp)
        }
        
    }
    
    // Navigation bar 的按鈕們
    @objc func notificationButtonClicked() {
        if isLogin {
            performSegue(withIdentifier: "NotificationSegue", sender: nil)
        } else {
            makeAlert(title: "提示訊息", message: "你必須登入才能查看通知。")
        }
        
    }

    @objc func qrcodeButtonClicked() {
        blankPageText = "此功能尚未開放"
        performSegue(withIdentifier: "BlankPageSegue", sender: nil)
    }

    @objc func locationButtonClicked() {
        blankPageText = "此功能尚未開放"
        performSegue(withIdentifier: "BlankPageSegue", sender: nil)
    }
    
    // 長按了之後時候
    @objc func onLongPress(gestureRecognizer : UILongPressGestureRecognizer) {
        // 抄來的，我也不知道是什麼
        if (gestureRecognizer.state != UIGestureRecognizer.State.ended){
            return
        }
        performSegue(withIdentifier: "ImageBlurAdjustSegue", sender: nil)
    }
    
    // 登入按鈕
    // 如果已經登入了，要變成立即登出，跳出Alert確認
    @IBAction func loginButtonClicked(_ sender: Any) {
        if isLogin{
            let controller = UIAlertController(title: "提示訊息", message: "確定要登出嗎", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .destructive, handler: {(_) in
                self.logout()
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(okAction)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "LoginSegue", sender: nil)
        }
    }
    
    func successfullyLoggedIn(_ memberType: String, _ UUID: String) {
        isLogin = true
        if memberType == "mobileBank" {
            let mobileBankUserDatabase = MobileBankUserDatabase()
            
            let username = mobileBankUserDatabase.getUsername(UUID: UUID)
            
            self.loginButton.setTitle("歡迎回來，\(username)。點擊此登出帳戶", for: .normal)
            self.loginButton.backgroundColor = UIColor.red
        } else {
            self.loginButton.setTitle("登出", for: .normal)
            self.loginButton.backgroundColor = UIColor.red
        }
    }
    
    func logout() {
        isLogin = false
        loginButton.setTitle("立即登入", for: .normal)
        loginButton.backgroundColor = UIColor.link
    }
    
    fileprivate func decodeJson() {
        if let path1 = Bundle.main.path(forResource: "Currency", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path1), options: .alwaysMapped)
                currencyList = try! JSONDecoder().decode([Currency].self, from: data)
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
        // iPhone 8 Plus 的長度
        if screenHeight > 736 {
            layout.minimumLineSpacing = 30
            loginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        } else {
            layout.minimumLineSpacing = 5
        }
        functionCollectionView.collectionViewLayout = layout
    }
}


