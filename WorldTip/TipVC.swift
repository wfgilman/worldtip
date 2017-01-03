//
//  TipVC.swift
//  WorldTip
//
//  Created by Will Gilman on 12/16/16.
//  Copyright © 2016 Will Gilman. All rights reserved.
//

import UIKit
import Alamofire

class TipVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var tipSelector: UISegmentedControl!
    @IBOutlet weak var billLbl: UITextField!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var totalUSDLbl: UILabel!
    
    var country = [Country]()
    var countryTip = [CountryTip]()
    var currentCountryTip = [CountryTip]()
    var exchangeRates = [ExchangeRate]()
    var currentExchangeRate = [ExchangeRate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let c1 = Country(iso3: "USA", countryName: "United States")
        let c2 = Country(iso3: "FRA", countryName: "France")
        let c3 = Country(iso3: "GER", countryName: "Germany")
        let c4 = Country(iso3: "GBR", countryName: "Great Britain")
        let c5 = Country(iso3: "RUS", countryName: "Russia")
        
        let ct1 = CountryTip(iso3: "USA",
                             options: [0.15, 0.18, 0.20],
                             defaultOption: 0.15,
                             currencySymbol: "$",
                             currencyIso3: "USD")
        let ct2 = CountryTip(iso3: "FRA",
                             options: [0],
                             defaultOption: 0,
                             currencySymbol: "€",
                             currencyIso3: "EUR")
        let ct3 = CountryTip(iso3: "GER",
                             options: [0.05, 0.075, 0.10],
                             defaultOption: 0.05,
                             currencySymbol: "€",
                             currencyIso3: "EUR")
        let ct4 = CountryTip(iso3: "GBR",
                             options: [0.05, 0.075, 0.10],
                             defaultOption: 0.05,
                             currencySymbol: "£",
                             currencyIso3: "GBP")
        let ct5 = CountryTip(iso3: "RUS",
                             options: [0.05, 0.10, 0.15],
                             defaultOption: 0.10,
                             currencySymbol: "₽",
                             currencyIso3: "RUB")
        
        country.append(c1)
        country.append(c2)
        country.append(c3)
        country.append(c4)
        country.append(c5)
        
        countryTip.append(ct1)
        countryTip.append(ct2)
        countryTip.append(ct3)
        countryTip.append(ct4)
        countryTip.append(ct5)
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        currentCountryTip = [countryTip.first!]
        updateSegments(newSegments: currentCountryTip[0].options)
        
        downloadExchangeRates {
            
        }
        
        billLbl.becomeFirstResponder()
    }
    
    func downloadExchangeRates(completed: @escaping DownloadComplete) {
        
        let exchangeRateURL = URL(string: CURRENT_EXCHANGE_RATES)!
        
        Alamofire.request(exchangeRateURL).responseJSON { response in
            // print("\(exchangeRateURL)")
            let result = response.result
         
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let rates = dict["rates"] as? Dictionary<String, AnyObject> {
                    
                    for i in 0...self.countryTip.count - 1 {
                        
                        let currencyIso3 = self.countryTip[i].currencyIso3
                    
                        if let xchange = rates[currencyIso3] as? Double {
                        
                            let exchangeRate = ExchangeRate(currencyIso3: currencyIso3,
                                                            rateToUSD: xchange)
                            self.exchangeRates.append(exchangeRate)
                            print("\(currencyIso3):\(xchange)")
                        }
                    }
                }
            }

            completed()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return country.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return country[row].countryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let iso3 = country[row].iso3
        currentCountryTip = countryTip.filter({$0.iso3.range(of: iso3) != nil})
        
        let currencyIso3 = currentCountryTip[0].currencyIso3
        currentExchangeRate = exchangeRates.filter({$0.currencyIso3.range(of: currencyIso3) != nil})
            
        updateSegments(newSegments: currentCountryTip[0].options)
        tipSelector.selectedSegmentIndex = 0
        calculateTip(nil)
    }
    
    func updateSegments(newSegments: [Double]) {
        // Remove existing segments
        for i in 0..<(tipSelector.numberOfSegments - 1) {

            tipSelector.removeSegment(at: i, animated: false)
        }
        
        // Insert new ones based on country defaults
        for i in 0..<newSegments.count {
            tipSelector.insertSegment(
                withTitle: String(describing: String(format: "%.1f%%", newSegments[i] * 100)),
                at: i,
                animated: false
            )
        }
        
        // Remove last segment
        tipSelector.removeSegment(at: (tipSelector.numberOfSegments - 1), animated: false)
        
        tipSelector.selectedSegmentIndex = 0
        
        if currentCountryTip[0].iso3 == "FRA" {
            
            noteLbl.text = "Included (Service Compris)"
        } else {
            
            noteLbl.text = ""
        }
    }
    
    @IBAction func calculateTip(_ sender: AnyObject?) {
        
        let tipPct = currentCountryTip[0].options[tipSelector.selectedSegmentIndex]
        let bill = Double(billLbl.text!) ?? 0
        let tip = currentCountryTip[0].calculate(bill: bill,
                                                 tipPct: tipPct)
        let total = bill + tip
        let symbol = currentCountryTip[0].currencySymbol
        
        tipLbl.text = String(format: "\(symbol)%.2f", tip)
        totalLbl.text = String(format: "\(symbol)%.2f", total)
        
        if currentCountryTip[0].iso3 == "USA" {
            
            totalUSDLbl.text = String(format: "\(symbol)%.2f", total)
            
        } else {
            
            totalUSDLbl.text = String(format: "$%.2f", total / currentExchangeRate[0].rateToUSD)
        }
    }
    
}
