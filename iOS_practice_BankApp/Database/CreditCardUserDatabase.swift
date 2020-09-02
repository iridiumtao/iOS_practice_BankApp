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
