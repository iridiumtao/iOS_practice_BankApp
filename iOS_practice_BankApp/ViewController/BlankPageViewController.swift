//
//  BlankPageViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/26.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class BlankPageViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var receivedText = ""
    
    var tapTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = receivedText
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BlankPageViewController.tapFunction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        if label.text!.count == 67 {
            tapTime += 1
        }
        if tapTime == 7 {
            let mobileBankUserDatabase = MobileBankUserDatabase()
            let creditCardUserDatabase = CreditCardUserDatabase()
            
            let uuid = mobileBankUserDatabase.searchData(nationalID: "A123456789", userID: "A1234567", password: "B1234567")
            if regexMatch(uuid, "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}") {
                makeAlert(title: "提示訊息", message: "東太平洋漁場時價分析師兼操盤手暨洋流講師 - 海龍王 彼得\n悄悄的對你說：「幹你娘雞掰」")
                return
            } else {
                mobileBankUserDatabase.createUser()
                creditCardUserDatabase.createUser()
                
                makeAlert(title: "提示訊息", message: "你已經成功創建帳號")
            }
        }
    }
    
}
