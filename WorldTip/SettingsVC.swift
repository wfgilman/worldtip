//
//  SettingsVC.swift
//  WorldTip
//
//  Created by Will Gilman on 1/3/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var countryImg: UIImageView!
    @IBOutlet weak var basicTxt: UITextField!
    @IBOutlet weak var goodTxt: UITextField!
    @IBOutlet weak var generousTxt: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let countryIso3 = defaults.string(forKey: "country")
        let tipOptions = defaults.object(forKey: countryIso3!) as! [Double]

        updateUI(countryIso3: countryIso3!, tipOptions: tipOptions)
        
        if countryIso3 != "FRA" {
            
            basicTxt.becomeFirstResponder()
        }
    }
    
    func updateUI(countryIso3: String, tipOptions: [Double]) {
        
        countryImg.image = UIImage(named: countryIso3)
        
        if countryIso3 != "FRA" {
            
            basicTxt.text = String(format: "%.1f%%", tipOptions[0] * 100)
            goodTxt.text = String(format: "%.1f%%", tipOptions[1] * 100)
            generousTxt.text = String(format: "%.1f%%", tipOptions[2] * 100)
        } else {
            
            basicTxt.text = "N/A"
            goodTxt.text = "N/A"
            generousTxt.text = "N/A"
        }
    }
    
    @IBAction func updateDefaults(_ sender: AnyObject?) {
        
        let countryIso3 = defaults.string(forKey: "country")
        
        if countryIso3 != "FRA" {
            
            let basic = Double(basicTxt.text!.replacingOccurrences(of: "%", with: ""))! / 100
            let good = Double(goodTxt.text!.replacingOccurrences(of: "%", with: ""))! / 100
            let generous = Double(generousTxt.text!.replacingOccurrences(of: "%", with: ""))! / 100
            let newTipOptions = [basic, good, generous]
            
            defaults.set(newTipOptions, forKey: countryIso3!)
            defaults.synchronize()
        }
    }


}
