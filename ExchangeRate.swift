//
//  ExchangeRate.swift
//  WorldTip
//
//  Created by Will Gilman on 1/2/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import Foundation

class ExchangeRate {
    
    var _currencyIso3: String!
    var _rateToUSD: Double!
    
    var currencyIso3: String {
        return _currencyIso3
    }
    
    var rateToUSD: Double {
        return _rateToUSD
    }
    
    init(currencyIso3: String, rateToUSD: Double) {
        _currencyIso3 = currencyIso3
        _rateToUSD = rateToUSD
    }
}
