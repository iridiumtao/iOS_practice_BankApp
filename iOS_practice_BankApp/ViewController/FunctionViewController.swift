//
//  FunctionViewController.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/26.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class FunctionViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var receivedTitle = ""
    var receivedImage = UIImage()
    var receivedTextViewText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = receivedTitle
        imageView.image = receivedImage
        textView.text = receivedTextViewText
        

        imageView.layer.masksToBounds = false
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 10
        
    }
    
    func setTitle(title: String) {
        receivedTitle = title
    }
    
    func setImage(imageName: String) {
        receivedImage = UIImage(named: imageName)!
         
    }

    func setTextViewText(content: String, url: URL) {
        receivedTextViewText = "內文：\n\(content)\n\n網址：\n\(url)"
    }

    
}
