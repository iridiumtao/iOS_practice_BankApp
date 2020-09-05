//
//  MessageDatabase.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/4.
//  Copyright © 2020 歐東. All rights reserved.
//

import Foundation
import RealmSwift

struct MessageDatabase {
    let realm = try! Realm()
    
    private var messages: [Message]? = nil
    
    mutating func loadData(userIndexRowInTableView index: Int) -> Message {
        if messages == nil {
            loadDataFromDatabase()
            return loadData(userIndexRowInTableView: index)
        } else {
            if let messages = messages {
                return Message(UUID: messages[index].UUID, messageType: messages[index].messageType, time: messages[index].time, title: messages[index].title, content: messages[index].content)
            } else {
                // 應該不會發生
                return Message(UUID: "error", messageType: "error", time: Date(), title: "title", content: "content")
            }
        }
    }
    
    mutating func clearLocalMessages() {
        messages = nil
    }
    
    private mutating func loadDataFromDatabase() {
        messages = []
        let messagesFromDB = realm.objects(RLM_Message.self)
        for messageFromDB in messagesFromDB {
            messages?.append(Message(UUID: messageFromDB.uuid,
                                     messageType: messageFromDB.messageType,
                                     time: messageFromDB.time,
                                     title: messageFromDB.title,
                                     content: messageFromDB.content))
        }
    }
    
    func createMessage() {
        let message = RLM_Message()
        
        let number = Int.random(in: 0..<2)
        
        if number == 0 {
            message.messageType = "個人訊息"
        } else {
            message.messageType = "好康優惠"
        }
        
        message.time = Date.init()
        message.title = "測試訊息"
        message.content = "此訊息為測試訊息，標題為測試訊息。補字補字補字補字補字補字補字補字補字"
        
        
        try! realm.write {
            realm.add(message)
        }
    }
    // todo getDataCount
}

public struct Message {
    var UUID: String
    var messageType: String = ""
    var time: Date = Date()
    var title: String = ""
    var content: String = ""
}

class RLM_Message : Object {

    /// 自動產生UUID
    @objc dynamic var uuid = UUID().uuidString
    
    @objc dynamic var messageType: String = ""
    @objc dynamic var time: Date = Date()
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    
    //設置索引主鍵
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
