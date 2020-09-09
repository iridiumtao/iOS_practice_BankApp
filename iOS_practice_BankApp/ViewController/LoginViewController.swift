//
//  LoginViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/26.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import LocalAuthentication

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
        
        // 如果不是第一次打開，設定預設 memberType 及調整 segmentedControl 的顯示
        if defaults.bool(forKey: defaultsKeys.isNotFirstTimeOpenApp) {
        
            memberType = defaults.string(forKey: defaultsKeys.memberType) ?? "mobileBank"
            if memberType == "mobileBank" {
                segmentedControl.selectedSegmentIndex = 0
            } else {
                segmentedControl.selectedSegmentIndex = 1
            }
        }
        setRememberNationIDCheckButtonImage()
        
        // 若使用生物認證
        if defaults.bool(forKey: defaultsKeys.isDeviceOwnerAuthentication) {
            deviceOwnerAuthentication()
        }

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
        defaults.set(memberType, forKey: defaultsKeys.memberType)
        
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
            successfullyLoginAction(uuid: uuidOrErrorMessage)
        } else {
            makeAlert(title: "登入失敗", message: uuidOrErrorMessage)
        }
    }
    
    // 登入成功後的動作
    func successfullyLoginAction(uuid: String) {
        if !defaults.bool(forKey: defaultsKeys.isDeviceOwnerAuthentication) {
            askDeviceOwnerAuthentication(uuid: uuid)
            
        } else {
        
            // 通知Alert，因為要修改 completion，所以在這邊重新弄一個
            let controller = UIAlertController(title: "提示訊息", message: "登入成功", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                
                // 按下OK後：關閉登入頁面、傳送登入資訊
                self.dismiss(animated: true, completion: nil)
                self.loginCompletionHandler?(uuid, self.memberType)
                
            })
            controller.addAction(okAction)
            
            present(controller, animated: true, completion: nil)
        }
    }
    
    // 詢問是否使用生物認證
    func askDeviceOwnerAuthentication(uuid: String) {
        let controller = UIAlertController(title: "登入成功", message: "是否要儲存登入資料，並在未來透過生物認證自動登入？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "儲存並使用", style: .default, handler: { (_) in
            
            // 按下「儲存並使用」後：透過 SwiftKeychainWrapper 儲存資料，並設定使用生物認證自動登入
            KeychainWrapper.standard.set(self.nationalIDTextField.text!, forKey: keyChainKeys.nationID)
            KeychainWrapper.standard.set(self.userIDTextField.text!, forKey: keyChainKeys.userID)
            KeychainWrapper.standard.set(self.passwordTextField.text!, forKey: keyChainKeys.password)
            
            // 存在預設中
            self.defaults.set(true, forKey: defaultsKeys.isDeviceOwnerAuthentication)
            
            self.dismiss(animated: true, completion: nil)
            self.loginCompletionHandler?(uuid, self.memberType)
            
        })
        let noAction = UIAlertAction(title: "不使用", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
            self.loginCompletionHandler?(uuid, self.memberType)
        })
        controller.addAction(okAction)
        controller.addAction(noAction)
        present(controller, animated: true, completion: nil)
    }
    
    // source: https://medium.com/jeremy-xue-s-blog/swift-%E7%8E%A9%E7%8E%A9-touch-id-faceid-%E9%A9%97%E8%AD%89-d30be0ac803b
    /// 使用生物認證登入
    func deviceOwnerAuthentication() {
        
        // 創建 LAContext 實例
        let context = LAContext()
        // 設置取消按鈕標題
        context.localizedCancelTitle = "取消"
        // 宣告一個變數接收 canEvaluatePolicy 返回的錯誤
        var error: NSError?
        // 評估是否可以針對給定方案進行身份驗證
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // 描述使用身份辨識的原因
            let reason = "Log in to your account"
            // 評估指定方案
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        
                        let nationID = KeychainWrapper.standard.string(forKey: keyChainKeys.nationID)!
                        let userID = KeychainWrapper.standard.string(forKey: keyChainKeys.userID)!
                        let password = KeychainWrapper.standard.string(forKey: keyChainKeys.password)!
                        
                        var uuid = ""
                        
                        if self.memberType == "mobileBank" {
                            uuid = self.mobileBankUserDatabase.searchData(nationalID: nationID,
                                                                        userID: userID,
                                                                        password: password)
                        } else {
                            uuid = self.creditCardUserDatabase.searchData(nationalID: nationID,
                                                                        userID: userID,
                                                                        password: password)
                        }
                        
                        
                        // 由於使用生物認證就不需要 successfullyLoginAction() 中的 alert，
                        // 故直接於此回傳 UUID，並於 viewDidLoad() 中，
                        // 呼叫此 function 的地方 dismiss() 登入頁面
                        self.loginCompletionHandler?(uuid, self.memberType)
                        self.justDismiss()
                    }
                } else {
                    DispatchQueue.main.async { [unowned self] in
                        self.makeAlert(title: "認證失敗", message: error?.localizedDescription ?? "")
                        self.defaults.set(false, forKey: defaultsKeys.isDeviceOwnerAuthentication)
                    }
                }
            }
        } else {
            makeAlert(title: "失敗", message: error?.localizedDescription ?? "")
        }
    }
    
    func justDismiss() {
        dismiss(animated: true, completion: nil)
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
