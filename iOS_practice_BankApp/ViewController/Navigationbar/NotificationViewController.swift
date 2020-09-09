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
    
    var didSelectedMessageContext = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    @IBAction func notificationSettingButtonClicked(_ sender: Any) {
        // 為了做出動畫而修改寫法，同刪除 cell 的部分
        messageDatabase.createMessage(messageType: messageType)
        messageDatabase.clearLocalMessages()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        //tableView.isEditing = !tableView.isEditing
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
        
        // cell 內的文字
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        cell.timeLabel.text = dateFormatter.string(from: message.time)
        cell.titleLabel.text = message.title
        cell.contentLabel.text = message.content
        
        // 如果已讀
        if message.isRead {
            cell.timeLabel.textColor = UIColor.gray
            cell.titleLabel.textColor = UIColor.gray
            cell.contentLabel.textColor = UIColor.gray
        } else {
            cell.timeLabel.textColor = UIColor.label
            cell.titleLabel.textColor = UIColor.label
            cell.contentLabel.textColor = UIColor.label
        }
        
        return cell
    }
    
    // tableView cell 被選
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! NotificationTableViewCell
        didSelectedMessageContext = """
        \(cell.timeLabel.text!)
        
        \(cell.titleLabel.text!)
        
        \(cell.contentLabel.text!)
        """
        print(didSelectedMessageContext)
        print(indexPath.row)
        
        messageDatabase.readMessage(messageType: messageType, userIndexRowInTableView: indexPath.row)
        
        tableViewReloadDataAndClearLocalMessages()
        performSegue(withIdentifier: "BlankPageSegue", sender: nil)

    }
    
    // 編輯(刪除) tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("deleted")
            
            // 為了要使刪除 cell 有動畫，因此調動 tableView.deleteRows()。
            // 需要先移除該筆資料，再調動 deleteRows()
            messageDatabase.deleteMessage(messageType: messageType, userIndexRowInTableView: indexPath.row)
            messageDatabase.clearLocalMessages()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        }
    }
    
    func tableViewReloadDataAndClearLocalMessages(){
        messageDatabase.clearLocalMessages()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BlankPageSegue" {
            let blankPageViewController = segue.destination as! BlankPageViewController
            blankPageViewController.receivedText = didSelectedMessageContext
        }
    }
}
