//
//  SettingsTableViewController.swift
//  tippy
//
//  Created by Liqiang Ye on 8/12/17.
//  Copyright © 2017 Liqiang Ye. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let const = Constants()
    let defaults = UserDefaults.standard

    @IBOutlet weak var percentageSlider: UISlider!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet var currencyControl: UISegmentedControl!
    var defaultPercentage = Float(15)
    var defaultCurrencyIndex = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = const.SETTINGS_TITLE
        
        
        //load default tip percentage
        refreshDefaultValues()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view c	ontroller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            loadCurrency(currencyIndex: defaultCurrencyIndex)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    @IBAction func onPercentageChange(_ sender: AnyObject) {
        
        let tipPercentage = percentageSlider.value

        //update percentage label
        loadTipPercentage(tipPercentage: tipPercentage)
        
        //use UserDefaults to store the default value
        setDefaultTipPercentage(tipPercentage: tipPercentage)
    }
    
    func loadTipPercentage(tipPercentage: Float) {
        //update percentage label
        percentageLabel.text = (String(format: "%d%%", (Int(tipPercentage))))
    }
    
    func setDefaultTipPercentage(tipPercentage: Float){
        //use UserDefaults to store the default value
        defaults.set(tipPercentage, forKey: const.DEAFULT_TIP_PECENTAGE)
        defaults.synchronize()
    }
    
    @IBAction func onCurrencyChange(_ sender: AnyObject) {
        let currencyIndex = currencyControl.selectedSegmentIndex
        setDefaultCurrency(currencyIndex: currencyIndex)
    }
    
    func loadCurrency(currencyIndex: Int) {
        currencyControl.selectedSegmentIndex = currencyIndex
    }
    
    
    func setDefaultCurrency(currencyIndex: Int) {
        defaults.set(currencyIndex, forKey: const.DEFAULT_CURRENCY_INDEX)
        defaults.synchronize()
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
