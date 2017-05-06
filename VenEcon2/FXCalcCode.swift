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
    
    
    var DataDownloaded : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        BlackMarketVal.text = "..."
        SIMADIVal.text = "..."
        DIPROVal.text = "..."
        Val.text = ""

        
        
        Number.becomeFirstResponder()
        //Date.setValue(UIColor.orangeColor(), forKeyPath: "textColor")
        //Date.maximumDate = NSDate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FXCalcCode.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        //Internet download session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        //Added this bit with Pat on 20160804, to download the file
        let url = URL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_fx&format=json&start=2016-08-01")!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data , error == nil else {
                print("Didn't download properly")
                self.viewDidLoad() 
                return
            }
            
            guard let optionalJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: AnyObject]],
                let json = optionalJSON else
            {
                print("Did download but the data doesn't look like JSON")
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.Data(json)
                

                self.DataDownloaded = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.Calculate()
                
            })
            
            
        }) 
        task.resume()

        
        
        
}
    
@IBAction func NumberChanged(_ sender: AnyObject) {
        Calculate()
    }
    
    @IBAction func CurrencySwapped(_ sender: AnyObject) {
        Calculate()
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    
    
    func Calculate()
    {
        if DataDownloaded
        {
        //if (Double(Number.text!) != nil)
            if Utils.shared.NumberFormatter.number(from: ((Number.text!))) != nil
        {
            print("Is number\n")
            if Currency.selectedSegmentIndex == 0
            {
                Val.text = Utils.shared.CurrencyFormatter.string(from: Utils.shared.NumberFormatter.number(from: ((Number.text!)))!)
                //Initial value was dollar
                BlackMarketVal.text = Utils.shared.NumberFormatter.string(for: (Double((Utils.shared.NumberFormatter.number(from: ((Number.text!))))!)*Utils.shared.GetLatestNonZeroValue(BM, date: Utils.shared.Today())))! + " BsF"
                SIMADIVal.text = Utils.shared.NumberFormatter.string(for: (Double((Utils.shared.NumberFormatter.number(from: ((Number.text!))))!)*Utils.shared.GetLatestNonZeroValue(Simadi, date: Utils.shared.Today())))! + " BsF"
                DIPROVal.text = Utils.shared.NumberFormatter.string(for: (Double((Utils.shared.NumberFormatter.number(from: ((Number.text!))))!)*Utils.shared.GetLatestNonZeroValue(Official, date: Utils.shared.Today())))! + " BsF"
            }
            else if Currency.selectedSegmentIndex == 1
            {
                Val.text = Utils.shared.NumberFormatter.string(from: Utils.shared.NumberFormatter.number(from: ((Number.text!)))!)! + " BsF"
                //Initial value was BsF
                BlackMarketVal.text = Utils.shared.CurrencyFormatter.string(for: (Double((Utils.shared.NumberFormatter.number(from: ((Number.text!))))!)/Utils.shared.GetLatestNonZeroValue(BM, date: Utils.shared.Today())))!
                SIMADIVal.text = Utils.shared.CurrencyFormatter.string(for: (Double((Utils.shared.NumberFormatter.number(from: ((Number.text!))))!)/Utils.shared.GetLatestNonZeroValue(Simadi, date: Utils.shared.Today())))!
                DIPROVal.text = Utils.shared.CurrencyFormatter.string(for: (Double((Utils.shared.NumberFormatter.number(from: ((Number.text!))))!)/Utils.shared.GetLatestNonZeroValue(Official, date: Utils.shared.Today())))!
            }
            
        }
        else
        {
            print("Isn't number or is zero\n")
            BlackMarketVal.text = "..."
            SIMADIVal.text = "..."
            DIPROVal.text = "..."
            Val.text = ""
        }
        }
    }
    
    
    func Data(_ json : [[String : AnyObject]]) {
        
        for dataPoint in json {
            
            guard let
                dateString = dataPoint["date"] as? String,
                let OfficialVal = dataPoint["official"] as? String,
                let BMVal = dataPoint["bm"] as? String,
                let SimadiVal = dataPoint["simadi"] as? String
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
    
    @IBOutlet var ShareButton: UIButton!
    @IBAction func ShowMenu(_ sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func ShareButton(_ sender: UIButton) {
        let objectsToShare = ["Venezuela Econ", view.snapshotImage(afterScreenUpdates: false)!, NSURL(string: "http://appsto.re/gb/LaYucb.i")] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
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










