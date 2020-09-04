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
    var rememberNationID = false
    var blankPageText = ""
    
    var mobileBankUserDatabase = MobileBankUserDatabase()
    
    var loginCompletionHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLayout()
        
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
        cancelButton.layer.cornerRadius = cancelButton.bounds.height / 2
        
        print(mobileBankUserDatabase.searchData(nationalID: "1", userID: "1", password: "1"))

    }
    
    // 按鈕「記住身分證字號/統一編號」
    @IBAction func rememberNationIDCheckButtonClicked(_ sender: UIButton) {
        if !checkID(nationalIDTextField.text!) {
            makeAlert(title: "提示訊息", message: "請輸入身分證字號/統一編號")
            return
        }
        
        rememberNationID = !rememberNationID
        if rememberNationID {
            rememberNationIDCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            rememberNationIDCheckButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
        // todo 記住身分證字號/統一編號
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
    
    // 按鈕「立即登入「
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        let message = isUserInputValid()
        print("message " + message)
        if message == "ok" {
            login()
            
            
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
            
        }
        
        if regexMatch(uuidOrErrorMessage, "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}") {
            
            // 通知，因為要修改 completion，所以在這邊重新弄一個
            let controller = UIAlertController(title: "提示訊息", message: "登入成功", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                
                
                self.dismiss(animated: true, completion: nil)
                self.loginCompletionHandler?(uuidOrErrorMessage)
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

extension LoginViewController {
    /// 利用此function達到類似Java String.match()的功能
    /// 若輸入文字為空值會直接return false
    ///
    /// - Parameters:
    ///   - validateString: 要驗證的文字
    ///   - regex: 驗證規則
    /// - Returns: 回傳是否符合的 Bool
    func regexMatch(_ validateString:String, _ regex:String) -> Bool {
        if validateString == "" {
            return false
        }
        let regexResult = regularExpression(validateString: validateString, regex: regex)
        return (regexResult == validateString)
    }
    
    /// 正則匹配
    ///
    /// - Parameters:
    ///   - validateString: 要驗證的文字
    ///   - regex: 驗證規則
    /// - Returns: 返回符合的 String
    func regularExpression(validateString:String, regex:String) -> String{
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: regex, options: [])
            let matches = regex.matches(in: validateString, options: [], range: NSMakeRange(0, validateString.count))
            var data:String = ""
            for item in matches {
                let string = (validateString as NSString).substring(with: item.range)
                data += string
            }
            return data
        }
        catch {
            print("哭啊")
            return ""
        }
    }
    //A 台北市 J 新竹縣 S 高雄縣
    //B 台中市 K 苗栗縣 T 屏東縣
    //C 基隆市 L 台中縣 U 花蓮縣
    //D 台南市 M 南投縣 V 台東縣
    //E 高雄市 N 彰化縣 W 金門縣
    //F 台北縣 O 新竹市 X 澎湖縣
    //G 宜蘭縣 P 雲林縣 Y 陽明山
    //H 桃園縣 Q 嘉義縣 Z 連江縣
    //I 嘉義市 R 台南縣
    func checkID(_ source: String) -> Bool {
        
        /// 轉成小寫字母
        let lowercaseSource = source.lowercased()
        
        /// 檢查格式，是否符合 開頭是英文字母＋後面9個數字
        func validateFormat(str: String) -> Bool {
            let regex: String = "^[a-z]{1}[1-2]{1}[0-9]{8}$"
            let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
            return predicate.evaluate(with: str)
        }
        
        if validateFormat(str: lowercaseSource) {
            
            /// 判斷是不是真的，規則在這邊(http://web.htps.tn.edu.tw/cen/other/files/pp/)
            let cityAlphabets: [String: Int] =
                ["a":10,"b":11,"c":12,"d":13,"e":14,"f":15,"g":16,"h":17,"i":34,"j":18,
                 "k":19,"l":20,"m":21,"n":22,"o":35,"p":23,"q":24,"r":25,"s":26,"t":27,
                 "u":28,"v":29,"w":30,"x":31,"y":32,"z":33]

            /// 把 [Character] 轉換成 [Int] 型態
            let ints = lowercaseSource.compactMap{ Int(String($0)) }

            /// 拿取身分證第一位英文字母所對應當前城市的
            guard let key = lowercaseSource.first,
                let cityNumber = cityAlphabets[String(key)] else {
                return false
            }
     
            /// 經過公式計算出來的總和
            let firstNumberConvert = (cityNumber / 10) + ((cityNumber % 10) * 9)
            let section1 = (ints[0] * 8) + (ints[1] * 7) + (ints[2] * 6)
            let section2 = (ints[3] * 5) + (ints[4] * 4) + (ints[5] * 3)
            let section3 = (ints[6] * 2) + (ints[7] * 1) + (ints[8] * 1)
            let total = firstNumberConvert + section1 + section2 + section3

            /// 總和如果除以10是正確的那就是真的
            if total % 10 == 0 { return true }
        }
        
        return false
    }
    
    func makeAlert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }

}
