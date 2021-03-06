//
//  BuyUpgradeCode.swift
//  VenEcon2
//
//  Created by Girish Gupta on 22/10/2017.
//  Copyright © 2017 Girish Gupta. All rights reserved.
//

import UIKit

class BuyUpgradeCode: UIViewController, HeaderViewDelegate {

    @IBOutlet weak var Header: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Header.HeaderLabel.text = "Upgrade"
        Header.delegate = self

        // Do any additional setup after loading the view.
        
        PriceLabel.text = SubscriptionService.shared.PriceAsString + " / " + NSLocalizedString("month", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RestorePreviousPurchasePress(_ sender: Any) {
        SubscriptionService.shared.Restore()
    }
    
    @IBAction func BuyPress(_ sender: Any) {
          SubscriptionService.shared.PurchaseSubscription()
    }
    @IBOutlet var PriceLabel: UILabel!
    
    
    @IBAction func SideMenu(_ sender: Any) {
        toggleSideMenuView()
    }
    
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    
    @IBAction func GoToPP(_ sender: Any) {
        if let url = URL(string: "https://web.venezuelaecon.com/appprivacy.php") {
            UIApplication.shared.openURL(url)
        }
    }
    

    func ShowMenuTapped()
    {
        toggleSideMenuView()
    }
    
}
