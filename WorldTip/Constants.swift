//
//  Constants.swift
//  WorldTip
//
//  Created by Will Gilman on 1/2/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.fixer.io/"
let CURRENT_RATES = "latest"
let BASE_CURRENCY = "?base="
let CURRENCY = "USD"

let CURRENT_EXCHANGE_RATES = "\(BASE_URL)\(CURRENT_RATES)\(BASE_CURRENCY)\(CURRENCY)"

typealias DownloadComplete = () -> ()
