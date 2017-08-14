//
//  ViewController.swift
//  tippy
//
//  Created by Liqiang Ye on 8/12/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    let const = Constants()
    let defaults = UserDefaults.standard
    let refreshBillAmountRate = Double(10 * 60) //600 seconds

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipPercentageSlidebarLabel: UILabel!
    @IBOutlet weak var tipPercentageSlidebar: UISlider!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var defaultPercentage = Float(15)
    var defaultCurrencyIndex = 0
    
    let currencyCodes = ["USD", "CAD", "CNY", "EUR", "GBP", "EGP"]
    let currencies = ["$","C$","¥","€","£","E£"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //record app launch timestamp
        saveAppLastLaunchTimestamp()
        
        //refresh and load default tip percentage and currency
        refreshDefaultValues()
        
        //refresh bill amount
        refreshBillAmount()
        
        //focus on UITextField without tapping it
        billField.becomeFirstResponder();
        
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func refreshDefaultValues() {
        
        if isKeyPresentInUserDefaults(key: const.DEAFULT_TIP_PECENTAGE) {
            defaultPercentage = Float(defaults.float(forKey: const.DEAFULT_TIP_PECENTAGE))
            loadTipPercentage(tipPercentage: defaultPercentage)
        }
                
        if isKeyPresentInUserDefaults(key: const.DEFAULT_CURRENCY_INDEX) {
            defaultCurrencyIndex = Int(defaults.integer(forKey: const.DEFAULT_CURRENCY_INDEX))
            loadCurrencySymbol(currencyIndex: defaultCurrencyIndex)
        }
    }
    
    func refreshBillAmount() {
        
        if isKeyPresentInUserDefaults(key: const.SAVED_BILL_AMOUNT) && isKeyPresentInUserDefaults(key: const.APP_LAST_LAUNCH_TIMESTAMP) {
            
            let savedBillAmount = defaults.double(forKey: const.SAVED_BILL_AMOUNT)
            let lastAppLaunchTimeDouble = defaults.double(forKey: const.APP_LAST_LAUNCH_TIMESTAMP)
            let lastAppLaunchTime = NSDate(timeIntervalSince1970: lastAppLaunchTimeDouble)
            
            
            if -lastAppLaunchTime.timeIntervalSinceNow <= refreshBillAmountRate {
                billField.text = (String(format: "%.2f", savedBillAmount))
                calculateTip(self)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        //refresh and load default tip percentage and currency
        refreshDefaultValues()
        
        //recalculate tip and total
        calculateTip(self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        //backItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal)
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        
        let tipPercentage = tipPercentageSlidebar.value
        
        tipPercentageSlidebarLabel.text = (String(format: "%d%%", ((Int(tipPercentage)))))
        
        
        let billText = String(billField.text!)
        let bill = Double(billText!) ?? 0
        if billText != nil && !(billText?.isEmpty)! {
            saveBillAmount(billAmount: bill)
        } else {
            defaults.removeObject(forKey: const.SAVED_BILL_AMOUNT)
        }
        
        let tip = bill * Double(Int(tipPercentage)) * 0.01
        let total = bill + tip
        
        tipLabel.text = formatCurrencyValue(currencyValue: tip)
        
        totalLabel.text = formatCurrencyValue(currencyValue: total)
    }
    
    func formatCurrencyValue (currencyValue: Double) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = currencyCodes[defaultCurrencyIndex]
        currencyFormatter.maximumFractionDigits = 2
        
        return currencyFormatter.string(from: NSNumber(value: currencyValue))!
    }
    
    func loadTipPercentage(tipPercentage: Float) {
        //update percentage label and slide bar
        tipPercentageSlidebar.value = tipPercentage
        tipPercentageSlidebarLabel.text = (String(format: "%d%%", ((Int(tipPercentage)))))
    }
    
    func loadCurrencySymbol(currencyIndex: Int) {
        //return bill currency placeholder
        let symbol = currencies[currencyIndex]
        currencyLabel.text = symbol
    }
    
    func saveBillAmount(billAmount: Double) {
        defaults.set(billAmount, forKey: const.SAVED_BILL_AMOUNT)
        defaults.synchronize()
    }
    
    func saveAppLastLaunchTimestamp() {
        defaults.set(NSDate().timeIntervalSince1970, forKey: const.APP_LAST_LAUNCH_TIMESTAMP)
        defaults.synchronize()
    }
    
}

