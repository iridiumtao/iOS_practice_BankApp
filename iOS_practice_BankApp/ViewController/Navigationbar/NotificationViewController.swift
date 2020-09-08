//
//  NotificationViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/9/3.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var notificationSettingButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var messageTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var messageDatabase = MessageDatabase()
    
    var messageType = "個人訊息"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    @IBAction func notificationSettingButtonClicked(_ sender: Any) {
        messageDatabase.createMessage()
        tableViewReloadDataAndClearLocalMessages()
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        editButton.setTitle((self.tableView.isEditing) ? "完成編輯" : "編輯訊息", for: .normal)
        tableView.reloadData()
    }
    

    @IBAction func messageTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            messageType = "個人訊息"
        } else {
            messageType = "好康優惠"
        }
        tableViewReloadDataAndClearLocalMessages()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDatabase.getMessageCount(messageType: messageType)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationTableViewCell
        let message = messageDatabase.loadData(messageType: messageType, userIndexRowInTableView: indexPath.row)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        cell.timeLabel.text = dateFormatter.string(from: message.time)
        cell.titleLabel.text = message.title
        cell.contentLabel.text = message.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // todo 儲存已讀
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("deleted")
            
            messageDatabase.deleteMessage(messageType: messageType, userIndexRowInTableView: indexPath.row)
            tableViewReloadDataAndClearLocalMessages()
            
        }
    }
    
    func tableViewReloadDataAndClearLocalMessages(){
        messageDatabase.clearLocalMessages()
        tableView.reloadData()
    }
}
