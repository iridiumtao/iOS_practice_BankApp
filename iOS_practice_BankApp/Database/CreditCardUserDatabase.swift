//
//  CreditCardUserDatabase.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/9/2.
//  Copyright © 2020 歐東. All rights reserved.
//

import Foundation
import RealmSwift

struct CreditCardUserDatabase {
    let realm = try! Realm()
    
    /// 透過搜尋來比對登入資料。
    ///
    /// 這或許不是一個好方法
    ///
    /// - Returns:
    ///   回傳UUID，用來傳給mainViewController，顯示username
    func searchData(nationalID: String, userID: String, password: String) -> String {
        print("\(realm.configuration.fileURL!)")

        let results =  realm.objects(RLM_MobileBankUser.self).filter("nationalID CONTAINS '\(nationalID)'")
        if results.count != 1 {
            return "此身分證字號尚未申請行動銀行業務，或是輸入錯誤"
        } else {
            for result in results {
                if result.userID == userID && result.password == password {
                    return result.uuid
                } else {
                    return "用戶ID或密碼錯誤"
                }
            }
        }
        
        return "1"
    }
    
    func createUser() {
        let user = RLM_CreditCardUser()
        user.nationalID = "A123456789"
        user.userID = "A1234567"
        user.password = "B1234567"
        try! realm.write {
            realm.add(user)
        }
    }
}

class RLM_CreditCardUser : Object {

    /// 自動產生UUID
    @objc dynamic var uuid = UUID().uuidString
    
    @objc dynamic var nationalID: String = ""
    @objc dynamic var userID: String = ""
    @objc dynamic var password: String = ""

    
    //設置索引主鍵
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
