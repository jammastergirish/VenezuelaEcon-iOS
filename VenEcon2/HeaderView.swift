//
//  HeaderView.swift
//  VenEcon2
//
//  Created by Girish Gupta on 13/12/2017.
//  Copyright © 2017 Girish Gupta. All rights reserved.
//

// https://www.youtube.com/watch?v=H-55qZYc9qI 20171213 https://medium.com/@brianclouser/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960

import UIKit
protocol HeaderViewDelegate: class { //20171214 with Pat
    
    func ShowMenuTapped()
}

class HeaderView: UIView {

    @IBOutlet var view: UIView!
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        UINib(nibName: "HeaderView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }
    
    weak var delegate : HeaderViewDelegate?  // weak for memory management. difference between strong and weak 20171214
    
    @IBOutlet weak var HeaderLabel: UILabel!

//    self.sideMenuController()?.sideMenu?.delegate = self

    @IBAction func ShowMenu(_ sender: Any) {
        delegate?.ShowMenuTapped()
    }
    
//    func sideMenuWillOpen() {
//        print("sideMenuWillOpen")
//    }
//
//    func sideMenuWillClose() {
//        print("sideMenuWillClose")
//    }
//
//    func sideMenuShouldOpenSideMenu() -> Bool {
//        print("sideMenuShouldOpenSideMenu")
//        return true
//    }
//
//    func sideMenuDidClose() {
//        print("sideMenuDidClose")
//    }
//
//    func sideMenuDidOpen() {
//        print("sideMenuDidOpen")
//    }

    
}
