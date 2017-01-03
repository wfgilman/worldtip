//
//  CountryTip.swift
//  WorldTip
//
//  Created by Will Gilman on 12/16/16.
//  Copyright © 2016 Will Gilman. All rights reserved.
//

import Foundation

class CountryTip {
    
    var _iso3: String!
    var _options: [Double]!
    var _defaultOption: Double!
    var _currencySymbol: String!
    var _currencyIso3: String!
    
    var iso3: String {
        return _iso3
    }
    
    var options: [Double] {
        return _options
    }
    
    var defaultOption: Double {
        return _defaultOption
    }
    
    var currencySymbol: String {
        return _currencySymbol
    }
    
    var currencyIso3: String {
        return _currencyIso3
    }
    
    init(iso3: String, options: [Double], defaultOption: Double, currencySymbol: String, currencyIso3: String!) {
        _iso3 = iso3
        _options = options
        _defaultOption = defaultOption
        _currencySymbol = currencySymbol
        _currencyIso3 = currencyIso3
    }
    
    func calculate(bill: Double, tipPct: Double) -> Double {
        let returnValue = bill * tipPct
        return returnValue
    }
}
