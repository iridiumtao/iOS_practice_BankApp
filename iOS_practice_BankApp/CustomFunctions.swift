//
//  CustomFunctions.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/9/5.
//  Copyright © 2020 歐東. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
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

