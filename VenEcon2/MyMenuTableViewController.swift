//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController {
    var selectedMenuItem : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserUpgraded), name: NSNotification.Name(rawValue: "UserUpgraded"), object: nil) // added 20171022. add this everywhere i want to check if user has subscribed and then the userupgraded function below
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 108, y: -25)
        label.textAlignment = NSTextAlignment.left
        label.text = "VENEZUELA ECON"
        label.textColor = UIColor.white
        self.view.addSubview(label)
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        //animated: true/false? changed. scrollpostiion?
        tableView.selectRow(at: IndexPath(row: selectedMenuItem, section: 0), animated: true, scrollPosition: .middle)
    }
    
    
    func UserUpgraded()
    {
        //here we just need to reload the table view
        tableView.reloadData()
        GoToViewControllerWithName(name: "UserUpgradedViewController")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func labels() -> [String] // Did same as func LabelsForViewControllers for labels hereon 20171023, a day after doing with Pay
    {
        if SubscriptionService.shared.isSubscriptionValid()
        {
            return [NSLocalizedString("Exchange Rates", comment: ""), " • "+NSLocalizedString("Calculator", comment: ""), "Bitcoin", NSLocalizedString("Foreign Reserves", comment: ""), NSLocalizedString("Inflation", comment: ""), /*NSLocalizedString("GDP", comment: ""), */NSLocalizedString("Tax Revenue", comment: ""), NSLocalizedString("Money Supply", comment: ""), NSLocalizedString("Minimum Wage", comment: ""), NSLocalizedString("Oil Prices", comment: ""), NSLocalizedString("Crude Production", comment: ""), NSLocalizedString("U.S. Oil", comment: ""), NSLocalizedString("Tax Unit", comment: ""), NSLocalizedString("About", comment: "")]
        }
        else
        {
            return [NSLocalizedString("Exchange Rates", comment: ""), " • "+NSLocalizedString("Calculator", comment: ""), "Bitcoin", "🔒 "+NSLocalizedString("Foreign Reserves", comment: ""), "🔒 "+NSLocalizedString("Inflation", comment: ""), /*"🔒 "+NSLocalizedString("GDP", comment: ""), */"🔒 "+NSLocalizedString("Tax Revenue", comment: ""), "🔒 "+NSLocalizedString("Money Supply", comment: ""), "🔒 "+NSLocalizedString("Minimum Wage", comment: ""), "🔒 "+NSLocalizedString("Oil Prices", comment: ""), "🔒 "+NSLocalizedString("Crude Production", comment: ""), "🔒 "+NSLocalizedString("U.S. Oil", comment: ""), "🔒 "+NSLocalizedString("Tax Unit", comment: ""), NSLocalizedString("About", comment: "")]
        }
    }


    func labelsForViewControllers() -> [String] // added for subscription service on 20171022. changed htis to a function rather than a variable/property below
    {
        if SubscriptionService.shared.isSubscriptionValid() // CHANGE THIS IF WANT TO TEST! 20171130
        {
            return ["ParentViewController", "FXCalcViewController", "ParentViewController", "ParentViewController", "ParentViewController",/* "GDPViewController",*/ "ParentViewController", "ParentViewController", "ParentViewController", "ParentViewController", "ParentViewController", "ParentViewController", "ParentViewController", "AboutViewController"]
        }
        else
        {
            return ["ParentViewController", "FXCalcViewController", "ParentViewController", "BuyViewController", "BuyViewController",/* "BuyViewController",*/ "BuyViewController", "BuyViewController", "BuyViewController", "BuyViewController", "BuyViewController", "BuyViewController", "BuyViewController", "AboutViewController"]
        }
    }
    
    
    var Indicators : [Indicator?] = [.FX, nil, .Bitcoin, .Reserves, .Inflation, .TaxRevenue, .MoneySupply, .MinimumWage, .OilPrices, .CrudeProduction, .USOil, .TaxUnit, nil]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.textColor = UIColor.orange
            let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        if ((indexPath as NSIndexPath).row==(labels().count-1)) // If the last label, then make it grey
        {
            cell!.textLabel?.textColor = UIColor.lightGray
        }
        
//        if !SubscriptionService.shared.IsSubscriber // on 20171023 as I do the UI, make it a nice color for those not subscribed rather than just the 🔒
//        {
//            var i : Int = 2
//            while (i<(labels().count-1))
//            {
//              cell!.textLabel?.textColor = UIColor.blue
//              i = i+1
//            }
//        }

         cell!.textLabel!.text = labels()[(indexPath as NSIndexPath).row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select row: \((indexPath as NSIndexPath).row)")
        
        if ((indexPath as NSIndexPath).row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = (indexPath as NSIndexPath).row
        
        
        GoToViewControllerAtIndex(index: indexPath.row)
        

    }
    
    func GoToViewControllerAtIndex(index : Int)
    {
        let name = labelsForViewControllers()[index] // Added on 20171214
        let indicator = Indicators[index]
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)  // Here we creating the View Controller that we want to go to. (commented on 20171028)
        let DestViewController = mainStoryboard.instantiateViewController(withIdentifier: name)
        if let parent = DestViewController as? ParentViewController
        {
            parent.Indicator = indicator!
        }
        
            sideMenuController()?.setContentViewController(DestViewController) // Set up the VC
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .middle)
    }
    
    
    func GoToViewControllerWithName(name : String)
    {

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)  // Here's we creating the View Controller that we want to go to. (commented on 20171028)
        let DestViewController = mainStoryboard.instantiateViewController(withIdentifier: name)
        
        sideMenuController()?.setContentViewController(DestViewController) // Set up the VC
        if let index = labelsForViewControllers().index(of: name) // this added on 20171028
        {
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
        }
        else if let index = tableView.indexPathForSelectedRow
        { //if tableview has anything selected, then unselect it
            tableView.deselectRow(at: index, animated: true)
        }
    }


}
