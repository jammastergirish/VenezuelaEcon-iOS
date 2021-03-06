//
//  AboutCode.swift
//  VenEcon1
//

import UIKit
import MessageUI

class FXCalcCode: UIViewController, ENSideMenuDelegate, HeaderViewDelegate {

    @IBOutlet weak var Header: HeaderView!
    
    var BM = [String: Double]()
    var Official = [String: Double]()
    var Dicom = [String: Double]()
    
    @IBOutlet var Date: UIDatePicker!
    @IBOutlet var Number: UITextField!
    @IBOutlet var Currency: UISegmentedControl!
    @IBOutlet var Button: UIButton!
    
    @IBOutlet var Val: UILabel!
    @IBOutlet var BlackMarketVal: UILabel!
    @IBOutlet var DICOMVal: UILabel!
    
    
    var DataDownloaded : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Header.HeaderLabel.text = "FX Calculator"
        Header.delegate = self
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        BlackMarketVal.text = "..."
        DICOMVal.text = "..."
        Val.text = ""

        
        
        Number.becomeFirstResponder()
        //Date.setValue(UIColor.orangeColor(), forKeyPath: "textColor")
        //Date.maximumDate = NSDate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FXCalcCode.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        //Internet download session
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        //Added this bit with Pat on 20160804, to download the file
        let url = URL(string: "https://api.venezuelaecon.com/output.php?table=ve_fx&format=json&start=2017-06-01&key=" + Utils.shared.APIKey)!
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
                DICOMVal.text = Utils.shared.NumberFormatter.string(for: (Double((Utils.shared.NumberFormatter.number(from: ((Number.text!))))!)*Utils.shared.GetLatestNonZeroValue(Dicom, date: Utils.shared.Today())))! + " BsF"
            }
            else if Currency.selectedSegmentIndex == 1
            {
                Val.text = Utils.shared.NumberFormatter.string(from: Utils.shared.NumberFormatter.number(from: ((Number.text!)))!)! + " BsF"
                //Initial value was BsF
                BlackMarketVal.text = Utils.shared.CurrencyFormatter.string(for: (Double((Utils.shared.NumberFormatter.number(from: ((Number.text!))))!)/Utils.shared.GetLatestNonZeroValue(BM, date: Utils.shared.Today())))!
                DICOMVal.text = Utils.shared.CurrencyFormatter.string(for: (Double((Utils.shared.NumberFormatter.number(from: ((Number.text!))))!)/Utils.shared.GetLatestNonZeroValue(Dicom, date: Utils.shared.Today())))!
            }
            
        }
        else
        {
            print("Isn't number or is zero\n")
            BlackMarketVal.text = "..."
            DICOMVal.text = "..."
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
                let DicomVal = dataPoint["dicom"] as? String
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
            
            if (DicomVal != "0")
            {
                Dicom[dateString] = Double(DicomVal)
            }
            
        }
    }
    
    
    
    @IBOutlet var ShowMenuButton: UIButton!
    
    @IBAction func ShowMenu(_ sender: AnyObject) {
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










