//
//  Country.swift
//  WorldTip
//
//  Created by Will Gilman on 12/16/16.
//  Copyright © 2016 Will Gilman. All rights reserved.
//

import Foundation

class Country {
    
    var _iso3: String!
    var _countryName: String!
    
    var iso3: String {
        return _iso3
    }
    
    var countryName: String! {
        return _countryName
    }
    
    init(iso3: String, countryName: String) {
        _iso3 = iso3
        _countryName = countryName
    }
    
}
