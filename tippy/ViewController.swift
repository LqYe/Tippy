//
//  ViewController.swift
//  tippy
//
//  Created by Liqiang Ye on 8/12/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import Foundation
import UIKit
import Social

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
    
    var sharedTipAmount = "0.00"
    
    let currencyCodes = ["Local", "USD", "CAD", "CNY", "EUR", "GBP", "EGP"]
    let currencies = ["Local", "$","C$","¥","€","£","E£"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        }
        
        loadCurrencySymbol(currencyIndex: defaultCurrencyIndex)

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
        
        let tipAmount = formatCurrencyValue(currencyValue: tip)
        tipLabel.text = tipAmount
        sharedTipAmount = tipAmount
        
        let totalAmount = formatCurrencyValue(currencyValue: total)
        totalLabel.text = totalAmount
        
    }
    
    func formatCurrencyValue (currencyValue: Double) -> String{
        
        let currencyFormatter = NumberFormatter()
        
        if(defaultCurrencyIndex > 0) {
            currencyFormatter.numberStyle = .currency
            currencyFormatter.currencyCode = currencyCodes[defaultCurrencyIndex]
        } else {
            currencyFormatter.numberStyle = .currency
        }
        
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
        var symbol = "$"
        
        if(currencyIndex > 0) {
            symbol = currencies[currencyIndex]
        } else {
            let locale = Locale.current
            symbol = locale.currencySymbol!
        }
        
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
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Share", message: "Share your tips", preferredStyle: .actionSheet)
        
        //Share on Facebook
        let actionFb = UIAlertAction(title: "Share on Facebook", style: .default) { (action) in
            
            //check if user is connected to Facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                
                post.setInitialText("I tipped " + self.sharedTipAmount)
                
                self.present(post, animated: true, completion: nil)
            } else {self.showAlert(service: "Facebook")}
            
        }
        
        //Share on Twitter
        let actionTw = UIAlertAction(title: "Share on Twitter", style: .default) { (action) in
            
            //check if user is connected to Facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                
                post.setInitialText("I tipped " + self.sharedTipAmount)
                
                self.present(post, animated: true, completion: nil)
            } else {self.showAlert(service: "Twitter")}
            
        }
        
        //Share on Sina Weibo
        let actionWb = UIAlertAction(title: "Share on Weibo", style: .default) { (action) in
            
            //check if user is connected to Facebook
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeSinaWeibo) {
                
                let post = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)!
                
                post.setInitialText("I tipped " + self.sharedTipAmount)
                
                self.present(post, animated: true, completion: nil)
            } else {self.showAlert(service: "Weibo")}
            
        }
        
        //Cancel
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        
        //Add action to action sheet
        alert.addAction(actionFb)
        alert.addAction(actionTw)
        alert.addAction(actionWb)
        alert.addAction(actionCancel)
        
        //display alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func showAlert(service:String) {
        let alert = UIAlertController(title: "Opps...", message: "You are not connected to \(service)", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
