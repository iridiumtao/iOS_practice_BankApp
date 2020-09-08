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
    
    mutating func loadData(messageType:String, userIndexRowInTableView index: Int) -> Message {
        if messages == nil {
            loadDataFromDatabase(messageType: messageType)
            return loadData(messageType: messageType, userIndexRowInTableView: index)
        } else {
            if let messages = messages {
                return Message(UUID: messages[index].UUID, messageType: messages[index].messageType, time: messages[index].time, title: messages[index].title, content: messages[index].content, isRead: messages[index].isRead)
            } else {
                // 應該不會發生
                return Message(UUID: "error", messageType: "error", time: Date(), title: "title", content: "content", isRead: false)
            }
        }
    }
    
    mutating func clearLocalMessages() {
        messages = nil
    }
    
    private mutating func loadDataFromDatabase(messageType: String) {
        messages = []
        let messagesFromDB = realm.objects(RLM_Message.self).sorted(byKeyPath: "time", ascending: false)
        for messageFromDB in messagesFromDB {
            if messageFromDB.messageType == messageType {
                messages?.append(Message(UUID: messageFromDB.uuid,
                                     messageType: messageFromDB.messageType,
                                     time: messageFromDB.time,
                                     title: messageFromDB.title,
                                     content: messageFromDB.content,
                                     isRead: messageFromDB.isRead))
            }
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
        print(message.messageType + "訊息已創建")
        
        try! realm.write {
            realm.add(message)
        }
    }
    
    mutating func getMessageCount(messageType: String) -> Int {
        
        if messages == nil {
            loadDataFromDatabase(messageType: messageType)
            return getMessageCount(messageType: messageType)
        } else {
            var count = 0
            if let messages = messages {
                for message in messages {
                    if message.messageType == messageType {
                        count += 1
                    }
                }
                return count
            } else {
                // 如果 message 沒有被初始化
                print("message 沒有被初始化")
                return 0
            }
        }
    }
    
    mutating func readMessage(messageType:String, userIndexRowInTableView index: Int) {
        //todo 已讀訊息
    }
    
    mutating func deleteMessage(messageType:String, userIndexRowInTableView index: Int) {
        
        //todo index to uuid
        
        
        // 確保 messages 存在
        if let messages = messages {
            print(messages[index])
            
            let message = realm.objects(RLM_Message.self).filter("uuid = %@", messages[index].UUID)
            
            try! realm.write {
                realm.delete(message)
            }
        }
        

    }
    
    
}

public struct Message {
    var UUID: String
    var messageType: String = ""
    var time: Date = Date()
    var title: String = ""
    var content: String = ""
    var isRead: Bool
}

class RLM_Message : Object {

    /// 自動產生UUID
    @objc dynamic var uuid = UUID().uuidString
    
    @objc dynamic var messageType: String = ""
    @objc dynamic var time: Date = Date()
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var isRead: Bool = false
    
    //設置索引主鍵
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
