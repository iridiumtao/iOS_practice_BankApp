//
//  BlankPageViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/26.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class BlankPageViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var receivedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = receivedText
    }
}
