//
//  Currency.swift
//  iOS_practice_BankApp
//
//  Created by 歐東 on 2020/8/8.
//  Copyright © 2020 歐東. All rights reserved.
//

import Foundation

struct Currency: Decodable {
    let currencyName: String
    let image: String
    let buy: Double
    let sell: Double
}


