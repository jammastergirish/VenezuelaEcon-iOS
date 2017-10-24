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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func labels() -> [String] // Did same as func LabelsForViewControllers for labels hereon 20171023, a day after doing with Pay
    {
        if SubscriptionService.shared.IsSubscriber
        {
            return [NSLocalizedString("Exchange Rates", comment: ""), " • "+NSLocalizedString("Calculator", comment: ""), "Bitcoin", NSLocalizedString("Foreign Reserves", comment: ""), NSLocalizedString("Inflation", comment: ""), /*NSLocalizedString("GDP", comment: ""), */NSLocalizedString("Tax Revenue", comment: ""), NSLocalizedString("Money Supply", comment: ""), NSLocalizedString("Minimum Wage", comment: ""), NSLocalizedString("Oil Prices", comment: ""), NSLocalizedString("Crude Production", comment: ""), NSLocalizedString("U.S. Oil", comment: ""), NSLocalizedString("Tax Unit", comment: ""), NSLocalizedString("About", comment: "")]
        }
        else
        {
            return [NSLocalizedString("Exchange Rates", comment: ""), " • "+NSLocalizedString("Calculator", comment: ""), "🔒 Bitcoin", "🔒 "+NSLocalizedString("Foreign Reserves", comment: ""), "🔒 "+NSLocalizedString("Inflation", comment: ""), /*"🔒 "+NSLocalizedString("GDP", comment: ""), */"🔒 "+NSLocalizedString("Tax Revenue", comment: ""), "🔒 "+NSLocalizedString("Money Supply", comment: ""), "🔒 "+NSLocalizedString("Minimum Wage", comment: ""), "🔒 "+NSLocalizedString("Oil Prices", comment: ""), "🔒 "+NSLocalizedString("Crude Production", comment: ""), "🔒 "+NSLocalizedString("U.S. Oil", comment: ""), "🔒 "+NSLocalizedString("Tax Unit", comment: ""), NSLocalizedString("About", comment: "")]
        }
    }
    
    
//        let labels : [String] = [NSLocalizedString("Exchange Rates", comment: ""), " • "+NSLocalizedString("Calculator", comment: ""), "Bitcoin", NSLocalizedString("Foreign Reserves", comment: ""), NSLocalizedString("Inflation", comment: ""), /*NSLocalizedString("GDP", comment: ""), */NSLocalizedString("Tax Revenue", comment: ""), NSLocalizedString("Money Supply", comment: ""), NSLocalizedString("Minimum Wage", comment: ""), NSLocalizedString("Oil Prices", comment: ""), NSLocalizedString("Crude Production", comment: ""), NSLocalizedString("U.S. Oil", comment: ""), NSLocalizedString("Tax Unit", comment: ""), NSLocalizedString("About", comment: "")]
    
    

    func labelsForViewControllers() -> [String] // added for subscription service on 20171022. changed htis to a function rather than a variable/property below
    {
        if SubscriptionService.shared.IsSubscriber
        {
            return ["FXViewController", "FXCalcViewController", "BitcoinViewController", "ReservesViewController", "InflationViewController",/* "GDPViewController",*/ "TaxRevViewController", "M2ViewController", "MinWageViewController", "OilViewController", "CrudeProductionViewController", "USOilViewController", "TaxUnitViewController", "AboutViewController"]
        }
        else
        {
            return ["FXViewController", "FXCalcViewController", "BuyViewController", "BuyViewController", "BuyViewController",/* "BuyViewController",*/ "BuyViewController", "BuyViewController", "BuyViewController", "BuyViewController", "BuyViewController", "BuyViewController", "BuyViewController", "AboutViewController"]
        }
    }
    
    //let labelsForViewControllers = ["FXViewController", "FXCalcViewController", "BitcoinViewController", "ReservesViewController", "InflationViewController",/* "GDPViewController",*/ "TaxRevViewController", "M2ViewController", "MinWageViewController", "OilViewController", "CrudeProductionViewController", "USOilViewController", "TaxUnitViewController", "AboutViewController"]


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
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        
        GoToViewControllerWithName(name: labelsForViewControllers()[indexPath.row])
        
//        switch ((indexPath as NSIndexPath).row) {
        

            
//        case 0:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "FXViewController")
//            break
//        case 1:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "FXCalcViewController")
//            break
//        case 2:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ReservesViewController")
//            break
//        case 3:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "InflationViewController")
//            break
//        case 4:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "M2ViewController")
//            break
//        case 5:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "MinWageViewController")
//            break
//        case 6:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "OilViewController")
//            break
//        case 7:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "CrudeProductionViewController")
//            break
//        case 8:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "USOilViewController")
//            break
//        case (labels.count-1):
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "AboutViewController")
//            break
//        default:
//            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "FXViewController")
//            break
//        }
//        sideMenuController()?.setContentViewController(destViewController)
    }
    
    func GoToViewControllerWithName(name : String)
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let DestViewController = mainStoryboard.instantiateViewController(withIdentifier: name)
        sideMenuController()?.setContentViewController(DestViewController)
        tableView.selectRow(at: IndexPath(row: labelsForViewControllers().index(of: name)!, section: 0), animated: true, scrollPosition: .middle)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
