//
//  LoginViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/26.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var nationalIDTextField: UITextField!
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rememberNationIDCheckButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
   
    var memberType = "mobileBank"
    let defaults = UserDefaults.standard
    var rememberNationID = false
    var blankPageText = ""
    
    var mobileBankUserDatabase = MobileBankUserDatabase()
    let creditCardUserDatabase = CreditCardUserDatabase()
    
    var loginCompletionHandler: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLayout()
        
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
        cancelButton.layer.cornerRadius = cancelButton.bounds.height / 2
        
        // 取得存在手機裡面的資料
        rememberNationID = defaults.bool(forKey: defaultsKeys.rememberNationID)
        if rememberNationID {
            nationalIDTextField.text = defaults.string(forKey: defaultsKeys.nationID)
        }
        setRememberNationIDCheckButtonImage()

    }
    
    // 按鈕「記住身分證字號/統一編號」
    @IBAction func rememberNationIDCheckButtonClicked(_ sender: UIButton) {
        if !checkID(nationalIDTextField.text!) {
            makeAlert(title: "提示訊息", message: "請輸入身分證字號/統一編號")
            return
        }
        
        rememberNationID = !rememberNationID
        setRememberNationIDCheckButtonImage()
        
        // 記住身分證字號/統一編號
        defaults.set(rememberNationID, forKey: defaultsKeys.rememberNationID)
        
    }
    
    func setRememberNationIDCheckButtonImage() {
        if rememberNationID {
            rememberNationIDCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            rememberNationIDCheckButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            memberType = "mobileBank"
            hintLabel.text = "請輸入銀行/行動銀行 會員代號與密碼"
        } else {
            memberType = "creditCard"
            hintLabel.text = "請輸入信用卡會員 會員代號與密碼"

        }
        
        
    }
    
    // 按鈕「立即登入」
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        let message = isUserInputValid()
        print(message)
        if message == "ok" {
            login()
            defaults.set(nationalIDTextField.text!, forKey: defaultsKeys.nationID)
        } else {
            makeAlert(title: "登入失敗", message: message)
        }
    }
    
    func isUserInputValid() -> String {
        if !checkID(nationalIDTextField.text!) {
            return "無法登入，請確認身分證號碼/統一編號或用戶代號輸入是否正確"
        }
        if !regexMatch(userIDTextField.text!, "[A-Za-z0-9]{6,18}") {
            return "用戶代號需為6~18位英數字"
        }
        if !regexMatch(passwordTextField.text!, "[A-Za-z0-9]{6,18}") || !regexMatch(passwordTextField.text!, "[A-Za-z]+\\d+|\\d+[A-Za-z]+"){
            return "理財密碼需為6~18位英數字夾雜"
        }
        
        return "ok"
    }
    
    func login() {
        var uuidOrErrorMessage = ""
        if memberType == "mobileBank" {
            uuidOrErrorMessage = mobileBankUserDatabase.searchData(nationalID: nationalIDTextField.text!, userID: userIDTextField.text!, password: passwordTextField.text!)
            
        } else {
            uuidOrErrorMessage = creditCardUserDatabase.searchData(nationalID: nationalIDTextField.text!, userID: userIDTextField.text!, password: passwordTextField.text!)
        }
        
        if regexMatch(uuidOrErrorMessage, "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}") {
            
            // 通知，因為要修改 completion，所以在這邊重新弄一個
            let controller = UIAlertController(title: "提示訊息", message: "登入成功", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                
                
                self.dismiss(animated: true, completion: nil)
                self.loginCompletionHandler?(uuidOrErrorMessage, self.memberType)
                
            })
            controller.addAction(okAction)
            
            present(controller, animated: true, completion: nil)
            
            
        } else {
            makeAlert(title: "登入失敗", message: uuidOrErrorMessage)
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        blankPageText = "「只要你懂海 海就會幫助你」\n\n不懂的話，去問問\n\n東太平洋漁場時價分析師兼操盤手暨洋流講師 - 海龍王 彼得\n\n他可能會告訴你答案。"
        performSegue(withIdentifier: "BlankPageSegue", sender: nil)
    }
    @IBAction func forgotPasswordButtonClicked(_ sender: Any) {
        blankPageText = """
        1. 忘記密碼？請填入您的用戶代碼、身分證字號、生日、任一張本行有效信用卡號後 6 碼，系統將會發送一組新的密碼到您設定的信箱。

        2. 帳號被鎖？密碼輸入錯誤連續 5 次，帳號將被鎖定無法登入，請您撥打客服專線 116721DD-F98A-4530-8BF7-BFB6B4001DDE 由專人為您服務。

        3. 忘記或不確定您設定的Email？請您撥打客服專線 116721DD-F98A-4530-8BF7-BFB6B4001DDE 由專人為您服務。

        4. 遺忘用戶代號？請您撥打客服專線 116721DD-F98A-4530-8BF7-BFB6B4001DDE 由專人為您服務。

        """
        performSegue(withIdentifier: "BlankPageSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "BlankPageSegue":
            let blankPageViewController = segue.destination as! BlankPageViewController
            blankPageViewController.receivedText = blankPageText
        case "LoginSegue":
            break
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func initializeLayout() {
           nationalIDTextField.layer.cornerRadius = nationalIDTextField.frame.height / 2
           nationalIDTextField.layer.masksToBounds = true
           nationalIDTextField.layer.borderWidth = 1.0
           nationalIDTextField.layer.borderColor = UIColor.systemGray5.cgColor
           
           userIDTextField.layer.cornerRadius = nationalIDTextField.frame.height / 2
           userIDTextField.layer.masksToBounds = true
           userIDTextField.layer.borderWidth = 1.0
           userIDTextField.layer.borderColor = UIColor.systemGray5.cgColor
           
           passwordTextField.layer.cornerRadius = nationalIDTextField.frame.height / 2
           passwordTextField.layer.masksToBounds = true
           passwordTextField.layer.borderWidth = 1.0
           passwordTextField.layer.borderColor = UIColor.systemGray5.cgColor
           
           rememberNationIDCheckButton.setImage(UIImage(systemName: "square"), for: .normal)
       }

}
