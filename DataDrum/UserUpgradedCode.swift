//
//  BuyUpgradeCode.swift
//  VenEcon2
//
//  Created by Girish Gupta on 22/10/2017.
//  Copyright © 2017 Girish Gupta. All rights reserved.
//

import UIKit

class UserUpgradedCode: UIViewController, HeaderViewDelegate {
    
    @IBOutlet weak var Header: HeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Header.HeaderLabel.text = "Thank You"
        Header.delegate = self
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
    func ShowMenuTapped()
    {
        toggleSideMenuView()
    }
    
}


