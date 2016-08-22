//
//  AboutCode.swift
//  VenEcon1
//

import UIKit
import MessageUI

class FXCalcCode: UIViewController, ENSideMenuDelegate {

    
    var BM = [String: Double]()
    var Official = [String: Double]()
    var Simadi = [String: Double]()
    
    @IBOutlet var Date: UIDatePicker!
    @IBOutlet var Number: UITextField!
    @IBOutlet var Currency: UISegmentedControl!
    @IBOutlet var Button: UIButton!
    
    @IBOutlet var Val: UILabel!
    @IBOutlet var BlackMarketVal: UILabel!
    @IBOutlet var SIMADIVal: UILabel!
    @IBOutlet var DIPROVal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BlackMarketVal.text = "..."
        SIMADIVal.text = "..."
        DIPROVal.text = "..."
        
        
        Number.becomeFirstResponder()
        //Date.setValue(UIColor.orangeColor(), forKeyPath: "textColor")
        //Date.maximumDate = NSDate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        //Internet download session
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        //Added this bit with Pat on 20160804, to download the file
        let url = NSURL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_fx&format=json&start=2016-08-01")!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            guard let data = data where error == nil else {
                print("Didn't download properly")
                return
            }
            
            guard let optionalJSON = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]],
                json = optionalJSON else
            {
                print("Did download but the data doesn't look like JSON")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in // Does this bit need to be in main thread? Much quicker if so
                
                self.Data(json)
                

                
                
            })
            
            
        }
        task.resume()

        
        
        
}
    
@IBAction func NumberChanged(sender: AnyObject) {
        if Double(Number.text!) != nil
        {
            print("Is number\n")
            
            Calculate()
            
        }
        else
        {
            print("Isn't number\n")
        }
    }
    
    @IBAction func CurrencySwapped(sender: AnyObject) {
        Calculate()
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    func Calculate()
    {
        if Currency.selectedSegmentIndex == 0
        {
            //Initial value was dollar
            BlackMarketVal.text = Utils.shared.NumberFormatter.stringFromNumber((Double(Number.text!)!*Utils.shared.GetLatestNonZeroValue(BM, date: Utils.shared.Today())))! + " BsF"
            SIMADIVal.text = Utils.shared.NumberFormatter.stringFromNumber((Double(Number.text!)!*Utils.shared.GetLatestNonZeroValue(Simadi, date: Utils.shared.Today())))! + " BsF"
            DIPROVal.text = Utils.shared.NumberFormatter.stringFromNumber((Double(Number.text!)!*Utils.shared.GetLatestNonZeroValue(Official, date: Utils.shared.Today())))! + " BsF"
        }
        else if Currency.selectedSegmentIndex == 1
        {
            //Initial value was BsF
            BlackMarketVal.text = Utils.shared.CurrencyFormatter.stringFromNumber((Double(Number.text!)!/Utils.shared.GetLatestNonZeroValue(BM, date: Utils.shared.Today())))!
            SIMADIVal.text = Utils.shared.CurrencyFormatter.stringFromNumber((Double(Number.text!)!/Utils.shared.GetLatestNonZeroValue(Simadi, date: Utils.shared.Today())))!
            DIPROVal.text = Utils.shared.CurrencyFormatter.stringFromNumber((Double(Number.text!)!/Utils.shared.GetLatestNonZeroValue(Official, date: Utils.shared.Today())))!
        }
    }
    
    
    func Data(json : [[String : AnyObject]]) {
        
        for dataPoint in json {
            
            guard let
                dateString = dataPoint["date"] as? String,
                OfficialVal = dataPoint["official"] as? String,
                BMVal = dataPoint["bm"] as? String,
                SimadiVal = dataPoint["simadi"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected")
                    return
            }
            
            if (BMVal != "0")
            {
                BM[dateString] = Double(BMVal) // Adds to my dictionary
            }
            
            if (OfficialVal != "0")
            {
                Official[dateString] = Double(OfficialVal)
            }
            
            if (SimadiVal != "0")
            {
                Simadi[dateString] = Double(SimadiVal)
            }
            
        }
    }
    
    
    
    @IBOutlet var ShowMenuButton: UIButton!
    
    @IBAction func ShowMenu(sender: AnyObject) {
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

    

}










