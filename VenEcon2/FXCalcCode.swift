//
//  AboutCode.swift
//  VenEcon1
//

import UIKit
import MessageUI

class FXCalcCode: UIViewController, ENSideMenuDelegate {

    
    @IBOutlet var Date: UIDatePicker!
    @IBOutlet var Number: UITextField!
    @IBOutlet var Currency: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Date.setValue(UIColor.orangeColor(), forKeyPath: "textColor")
        Date.maximumDate = NSDate()
}

}