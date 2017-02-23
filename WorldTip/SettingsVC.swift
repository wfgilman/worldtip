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
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var defaultsStackView: UIStackView!
    @IBOutlet var settingsView: UIView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let countryIso3 = defaults.string(forKey: "country")
        let tipOptions = defaults.object(forKey: countryIso3!) as! [Double]

        updateUI(countryIso3: countryIso3!, tipOptions: tipOptions)
        
        basicTxt.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        countryImg.alpha = 0.15
        defaultsStackView.center.x += settingsView.bounds.width
        messageLbl.center.y -= settingsView.bounds.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        animateBackgroundImage()
    }
    
    func updateUI(countryIso3: String, tipOptions: [Double]) {
        
        countryImg.image = UIImage(named: countryIso3)
        
        if countryIso3 != "FRA" {
            
            messageLbl.isHidden = true
            defaultsStackView.isHidden = false
            basicTxt.text = String(format: "%.1f%%", tipOptions[0] * 100)
            goodTxt.text = String(format: "%.1f%%", tipOptions[1] * 100)
            generousTxt.text = String(format: "%.1f%%", tipOptions[2] * 100)
            animateContent()
            
        } else {
            
            messageLbl.isHidden = false
            defaultsStackView.isHidden = true
            animateContent()
        }
    }
    
    @IBAction func updateDefaults(_ sender: AnyObject?) {
        
        let countryIso3 = defaults.string(forKey: "country")
        
        if countryIso3 != "FRA" {
            
            let basic = deformatTipPct(formattedTipPct: basicTxt.text!)
            let good = deformatTipPct(formattedTipPct: goodTxt.text!)
            let generous = deformatTipPct(formattedTipPct: generousTxt.text!)
            let newTipOptions = [basic, good, generous]
            
            defaults.set(newTipOptions, forKey: countryIso3!)
            defaults.synchronize()
        }
    }
    
    func deformatTipPct(formattedTipPct: String) -> Double {
        
        let deformattedTipPct = Double(formattedTipPct.replacingOccurrences(of: "%", with: ""))! / 100
        
        return deformattedTipPct
    }
    
    func animateContent() {
        UIView.animate(withDuration: 1.5, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: [], animations: {
            self.defaultsStackView.center.x -= self.settingsView.bounds.width
            self.messageLbl.center.y += self.settingsView.bounds.height
        }, completion: nil)
    }
    
    func animateBackgroundImage() {
        UIView.animate(withDuration: 0.5, animations: {
            self.countryImg.alpha = 0.0
        }, completion: nil)
    }
    

}
