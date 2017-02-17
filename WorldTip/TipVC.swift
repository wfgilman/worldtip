//
//  TipVC.swift
//  WorldTip
//
//  Created by Will Gilman on 12/16/16.
//  Copyright © 2016 Will Gilman. All rights reserved.
//

import UIKit
import Alamofire
import AMPopTip

class TipVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var tipSelector: UISegmentedControl!
    @IBOutlet weak var billLbl: UITextField!
    @IBOutlet weak var tipLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var totalUSDLbl: UILabel!
    @IBOutlet weak var resultsStackView: UIStackView!
    
    var country = [Country]()
    var countryTip = [CountryTip]()
    var currentCountryTip = [CountryTip]()
    var exchangeRates = [ExchangeRate]()
    var currentExchangeRate = [ExchangeRate]()
    let defaults = UserDefaults.standard
    var numberFormatter = NumberFormatter()
    
    var popTip: AMPopTip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let c1 = Country(iso3: "USA", countryName: "United States")
        let c2 = Country(iso3: "FRA", countryName: "France")
        let c3 = Country(iso3: "GER", countryName: "Germany")
        let c4 = Country(iso3: "GBR", countryName: "Great Britain")
        let c5 = Country(iso3: "MEX", countryName: "Mexico")
        let c6 = Country(iso3: "RUS", countryName: "Russia")
        
        let usa = [0.10, 0.15, 0.20]
        let fra = [0.0]
        let ger = [0.05, 0.075, 0.10]
        let gbr = [0.05, 0.075, 0.10]
        let rus = [0.05, 0.10, 0.15]
        let mex = [0.10, 0.15, 0.20]
        
        let ct1 = CountryTip(iso3: "USA",
                             options: usa,
                             defaultOption: 1,
                             currencySymbol: "$",
                             currencyIso3: "USD")
        let ct2 = CountryTip(iso3: "FRA",
                             options: fra,
                             defaultOption: 0,
                             currencySymbol: "€",
                             currencyIso3: "EUR")
        let ct3 = CountryTip(iso3: "GER",
                             options: ger,
                             defaultOption: 0,
                             currencySymbol: "€",
                             currencyIso3: "EUR")
        let ct4 = CountryTip(iso3: "GBR",
                             options: gbr,
                             defaultOption: 0,
                             currencySymbol: "£",
                             currencyIso3: "GBP")
        let ct5 = CountryTip(iso3: "MEX",
                             options: mex,
                             defaultOption: 1,
                             currencySymbol: "$",
                             currencyIso3: "MXN")
        let ct6 = CountryTip(iso3: "RUS",
                             options: rus,
                             defaultOption: 0,
                             currencySymbol: "₽",
                             currencyIso3: "RUB")
        
        country.append(c1)
        country.append(c2)
        country.append(c3)
        country.append(c4)
        country.append(c5)
        country.append(c6)
        
        countryTip.append(ct1)
        countryTip.append(ct2)
        countryTip.append(ct3)
        countryTip.append(ct4)
        countryTip.append(ct5)
        countryTip.append(ct6)
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        currentCountryTip = [countryTip.first!]
        updateSegments(newSegments: currentCountryTip[0].options, countryIso3: currentCountryTip[0].iso3)
        
        downloadExchangeRates {
            
        }
        
        defaults.set("USA", forKey: "country")
        defaults.set(usa, forKey: "USA")
        defaults.set(fra, forKey: "FRA")
        defaults.set(ger, forKey: "GER")
        defaults.set(gbr, forKey: "GBR")
        defaults.set(mex, forKey: "MEX")
        defaults.set(rus, forKey: "RUS")
        defaults.synchronize()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        billLbl.becomeFirstResponder()
        
        self.popTip = AMPopTip()
        self.popTip?.shouldDismissOnTap = true
        self.popTip?.edgeMargin = 5
        self.popTip?.offset = 0
        self.popTip?.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.popTip?.popoverColor = UIColor.darkGray
        self.popTip?.alpha = 1
        
        let tipTap = UITapGestureRecognizer(target: self, action: #selector(TipVC.tipTapFunction))
        tipLbl.isUserInteractionEnabled = true
        tipLbl.addGestureRecognizer(tipTap)
        
        let totalTap = UITapGestureRecognizer(target: self, action: #selector(TipVC.totalTapFunction))
        totalLbl.isUserInteractionEnabled = true
        totalLbl.addGestureRecognizer(totalTap)
        
        let totalUSDTap = UITapGestureRecognizer(target: self, action: #selector(TipVC.totalUSDTapFunction))
        totalUSDLbl.isUserInteractionEnabled = true
        totalUSDLbl.addGestureRecognizer(totalUSDTap)
        
        tipLbl.text = "\(currentCountryTip[0].currencySymbol)"
        totalLbl.text = "\(currentCountryTip[0].currencySymbol)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let country = defaults.string(forKey: "country")
        let tipOptions = defaults.object(forKey: country!) as! [Double]
       
        updateSegments(newSegments: tipOptions, countryIso3: country!)
        
        billLbl.becomeFirstResponder()
    }
    
    func downloadExchangeRates(completed: @escaping DownloadComplete) {
        
        let exchangeRateURL = URL(string: CURRENT_EXCHANGE_RATES)!
        
        Alamofire.request(exchangeRateURL).responseJSON { response in

            let result = response.result
         
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let rates = dict["rates"] as? Dictionary<String, AnyObject> {
                    
                    for i in 0...self.countryTip.count - 1 {
                        
                        let currencyIso3 = self.countryTip[i].currencyIso3
                    
                        if let xchange = rates[currencyIso3] as? Double {
                        
                            let exchangeRate = ExchangeRate(currencyIso3: currencyIso3,
                                                            rateToUSD: xchange)
                            self.exchangeRates.append(exchangeRate)
                            // print("\(currencyIso3):\(xchange)")
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
        
        let countryIso3 = country[row].iso3
        currentCountryTip = countryTip.filter({$0.iso3.range(of: countryIso3) != nil})
        
        let currencyIso3 = currentCountryTip[0].currencyIso3
        currentExchangeRate = exchangeRates.filter({$0.currencyIso3.range(of: currencyIso3) != nil})
        
        let tipOptions = defaults.object(forKey: countryIso3) as! [Double]
        
        backgroundImg.image = UIImage(named: countryIso3)
        updateSegments(newSegments: tipOptions, countryIso3: countryIso3)
        
        defaults.set(countryIso3, forKey: "country")
        defaults.synchronize()
        
        calculateTip(nil)
    }
    
    func updateSegments(newSegments: [Double], countryIso3: String) {
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
        
        let currentCountryTip = countryTip.filter({$0.iso3.range(of: countryIso3) != nil})
        let defaultOption = currentCountryTip[0].defaultOption
        
        tipSelector.selectedSegmentIndex = defaultOption
    }
    
    @IBAction func calculateTip(_ sender: AnyObject?) {
        
        myTextFieldDidChange(billLbl)
        
        let countryIso3 = currentCountryTip[0].iso3
        let symbol = currentCountryTip[0].currencySymbol
        let tipOptions = defaults.object(forKey: countryIso3) as! [Double]
        let tipPct = tipOptions[tipSelector.selectedSegmentIndex]
        let bill = deformatBill(formattedBill: billLbl.text!, currencySymbol: symbol)
        let tip = currentCountryTip[0].calculate(bill: bill, tipPct: tipPct)
        let total = bill + tip
        
        tipLbl.text = currencyText(number: tip, currencySymbol: symbol)
        totalLbl.text = currencyText(number: total, currencySymbol: symbol)
        
        if currentCountryTip[0].iso3 == "USA" {
            
            totalUSDLbl.text = currencyText(number: total, currencySymbol: symbol)
            
        } else {
            
            let rate = currentExchangeRate[0].rateToUSD
            totalUSDLbl.text = currencyText(number: total / rate, currencySymbol: "$")
            
        }
        
        billLbl.placeholder = symbol
    }
    
    func deformatBill(formattedBill: String, currencySymbol: String) -> Double {
     
        let deformatCurrencySymbol = formattedBill.replacingOccurrences(of: currencySymbol, with: "")
        let deformattedBill = deformatCurrencySymbol.replacingOccurrences(of: ",", with: "")
        
        return Double(deformattedBill) ?? 0
    }
    
    func currencyText(number: Double, currencySymbol: String) -> String {
        
        if number > Double(1000) {
         
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
            
            return "\(currencySymbol)" + numberFormatter.string(from: NSDecimalNumber(decimal: Decimal(number)))!
            
        } else {
            
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            
            return "\(currencySymbol)" + numberFormatter.string(from: NSDecimalNumber(decimal: Decimal(number)))!
        }
    }
    
   func tipTapFunction(sender: UIGestureRecognizer) {
        self.popTip?.showText("Tip in local currency", direction: AMPopTipDirection.down, maxWidth: 100, in: self.resultsStackView, fromFrame: self.tipLbl.frame)
        dismissPopUp(seconds: 1.0)
    }
    
    func totalTapFunction(sender: UIGestureRecognizer) {
        self.popTip?.showText("Bill Total in local currency", direction: AMPopTipDirection.down, maxWidth: 100, in: self.resultsStackView, fromFrame: self.totalLbl.frame)
        dismissPopUp(seconds: 1.0)
    }
    
    func totalUSDTapFunction(sender: UIGestureRecognizer) {
        self.popTip?.showText("Bill Total in USD", direction: AMPopTipDirection.down, maxWidth: 100, in: self.resultsStackView, fromFrame: self.totalUSDLbl.frame)
        dismissPopUp(seconds: 1.0)
    }
    
    func dismissPopUp(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.popTip?.hide()
        }
    }
    
    func myTextFieldDidChange(_ textField: UITextField) {
        
        let symbol = currentCountryTip[0].currencySymbol
        
        if let billString = textField.text?.currencyInputFormatting(symbol: symbol) {
            textField.text = billString
        }
    }
    
}
