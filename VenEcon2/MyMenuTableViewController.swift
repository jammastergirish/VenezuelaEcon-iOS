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
        
        
        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.center = CGPointMake(108, -25)
        label.textAlignment = NSTextAlignment.Left
        label.text = "VENEZUELA ECON"
        label.textColor = UIColor.whiteColor()
        self.view.addSubview(label)
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        //animated: true/false? changed. scrollpostiion?
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: true, scrollPosition: .Middle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        let labels : [String] = ["Exchange Rates", "Foreign Reserves", "Inflation", "Money Supply", "Minimum Wage", "Oil Prices", "Crude Production", "U.S. Oil", "About"]

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.orangeColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        if (indexPath.row==(labels.count-1))
        {
            cell!.textLabel?.textColor = UIColor.grayColor()
        }

         cell!.textLabel!.text = labels[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FXViewController")
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ReservesViewController")
            break
        case 2:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("InflationViewController")
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("M2ViewController")
            break
        case 4:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MinWageViewController")
            break
        case 5:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("OilViewController")
            break
        case 6:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("CrudeProductionViewController")
            break
        case 7:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("USOilViewController")
            break
        case (labels.count-1):
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AboutViewController")
            break
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FXViewController")
            break
        }
        sideMenuController()?.setContentViewController(destViewController)
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
