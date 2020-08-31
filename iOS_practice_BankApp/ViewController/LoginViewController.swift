//
//  LoginViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/26.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var memberType = "mobileBank"
    var rememberNationID = false
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    @IBAction func rememberNationIDCheckButtonClicked(_ sender: UIButton) {
        rememberNationID = !rememberNationID
        if rememberNationID {
            rememberNationIDCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)

        } else {
            rememberNationIDCheckButton.setImage(UIImage(systemName: "square"), for: .normal)


        }
        
        
        print(rememberNationID)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            memberType = "mobileBank"
        } else {
            memberType = "creditCard"
        }
    }
    
    

}
