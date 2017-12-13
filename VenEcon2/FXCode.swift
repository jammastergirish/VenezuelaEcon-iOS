//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class FXCode: UIViewController, ENSideMenuDelegate, SChartDatasource {
    
    var interstitial: GADInterstitial!
    
    // 20160818 Decided not to use the following and just use Utils.shared.XXX
    // let utils = Utils.shared
    
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    
    //Variables to hold data
    var BM = [String: Double]()
    var Official = [String: Double]()
    var Simadi = [String: Double]()
    var Dicom = [String: Double]()
    var M2_Res = [String: Double]()
    
    //Variables to hold chart data
    var DataBM: [SChartDataPoint] = []
    var DataOfficial: [SChartDataPoint] = []
    var DataSimadi: [SChartDataPoint] = []
    var DataDicom: [SChartDataPoint] = []
    var DataSupp: [SChartDataPoint] = []
    var DataSitme: [SChartDataPoint] = []
    var DataSicad1: [SChartDataPoint] = []
    var DataSicad2: [SChartDataPoint] = []
    var DataM2_Res: [SChartDataPoint] = []
    
    @IBOutlet var Header: UILabel!
    
    //Axes
    let xAxis = SChartDiscontinuousDateTimeAxis()
    let yAxis = SChartNumberAxis()
    
    //Layouts
    @IBOutlet var AllText: UIStackView!
    @IBOutlet var DistanceBetweenAllTextAndChartSV: NSLayoutConstraint!
    @IBOutlet var ChartSVHeight: NSLayoutConstraint!
    @IBOutlet var ChartSVToTop: NSLayoutConstraint!
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if (toInterfaceOrientation == .portrait)
        {
            ChartSVHeight.isActive = false
            AllText.isHidden = false
            Header.isHidden = false
            DistanceBetweenAllTextAndChartSV.isActive = true
            ShowMenuButton.isHidden = false
            //self.ShareButton.isHidden = false
            ChartSVToTop.isActive = false
            if !SubscriptionService.shared.isSubscriptionValid() //20171111
            {
                self.Upgrade.isHidden = false
            }
        }
        else
        {
            ChartSVHeight.isActive = true
            ChartSVHeight.constant = view.frame.width
            AllText.isHidden = true
            Header.isHidden = true
            DistanceBetweenAllTextAndChartSV.isActive = false
            ShowMenuButton.isHidden = true
            //self.ShareButton.isHidden = true
            ChartSVToTop.isActive = true
            ChartSVToTop.constant = 0
            Upgrade.isHidden = true
        }
    }

    
    //Labels for main values
    @IBOutlet var BlackMarketVal: UILabel!
    @IBOutlet var DicomVal: UILabel!
    @IBOutlet var DIPROVal: UILabel!
    @IBOutlet var M2_ResVal: UILabel!
    
    //Labels for variation text
    @IBOutlet var BlackMarketYesterday: UILabel!
    @IBOutlet var BlackMarketMonth: UILabel!
    @IBOutlet var BlackMarketYear: UILabel!
    @IBOutlet var BlackMarketTwoYear: UILabel!
    @IBOutlet var BlackMarketThreeYear: UILabel!
    @IBOutlet var BlackMarketFourYear: UILabel!
    @IBOutlet var BlackMarketFiveYear: UILabel!
    @IBOutlet var DicomMonth: UILabel!
    @IBOutlet var DicomYesterday: UILabel!
    @IBOutlet var DicomYear: UILabel!
    
    //Chart
    @IBOutlet var chart: ShinobiChart!
    
    //DateFormatter for data for chart. Not sure why in this format with "required init..."
    let dateFormatter = DateFormatter()
    required init?(coder aDecoder: NSCoder) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        super.init(coder: aDecoder)
    }
    
    //Range Controller and Range Control functions
    @IBOutlet var RangeController: UISegmentedControl!
    @IBAction func RangeControl(_ sender: AnyObject) {
        var Start : String = Utils.shared.YearsAgo(4)
        switch RangeController.selectedSegmentIndex
        {
        case 0:
            Start = Utils.shared.YearsAgo(32)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 1:
            Start = Utils.shared.YearsAgo(16)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 2:
            Start = Utils.shared.YearsAgo(8)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 3:
            Start = Utils.shared.YearsAgo(4)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 4:
            Start = Utils.shared.YearsAgo(2)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
        default:
            break;
        }
        
        let startDate = dateFormatter.date(from: Start)
        let endDate = Date()
        
        chart.xAxis!.defaultRange = SChartDateRange(dateMinimum: startDate, andDateMaximum: endDate)
        
        chart.reloadData()
        chart.redraw()
    }
    
    //Internet download session
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if !SubscriptionService.shared.isSubscriptionValid()
        {
         interstitial = GADInterstitial(adUnitID: "ca-app-pub-7175811277195688/1463700737")
         //interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
         let requestad = GADRequest()
         interstitial.load(requestad)
         //https://developers.google.com/admob/ios/interstitial 20171125
         //https://apps.admob.com/v2/apps/7903495316/adunits/create?pli=1
        }
    
        
        //Layout
        ChartSVHeight.isActive = false
        ChartSVToTop.isActive = false

        //20170716 Need to work out why this Messeging.messaging().fcmToken doesn't always work
        //should i be doing this? https://stackoverflow.com/questions/40013764/correct-way-to-retrieve-token-for-fcm-ios-10-swift-3
        if let token : String = InstanceID.instanceID().token() //Messaging.messaging().fcmToken
        {
            
                    print ("This thing: " + token)
        
        //Update the language of notifications 20170715
        let session_ = URLSession(configuration: URLSessionConfiguration.default)
        
        let url_ = URL(string: "https://api.venezuelaecon.com/app/notifications.php?todo=update_lan&id=" + token + "&lan=" + (Locale.preferredLanguages.first?.components(separatedBy: "-")[0])!)!
        let request_ = URLRequest(url: url_)
        let task_ = session.dataTask(with: request_, completionHandler: { (data, response, error) -> Void in
            
            guard let data_ = data else {
                print("No internet connection")
                return
            }
            
            if let response_ = String(data: data!, encoding: String.Encoding.utf8)
            {
                print(response_)
                
            } else {
                print("Couldn't do")
            }
            
        })
        
        task_.resume()
        
        }
        else
        {
            print ("Firebase token not found?")
        }
        
        
        //For menu
        self.sideMenuController()?.sideMenu?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        
        //Telling what units we're using. Hopefully will be able to shift all this later
        let units : String = Utils.shared.currencies["VEF"]! + "/" + Utils.shared.currencies["USD"]!
        
        //Hide everything while loading
        self.Header.isHidden = true
        self.AllText.isHidden = true
        self.RangeController.isHidden = true
        self.chart.isHidden = true
        self.ShowMenuButton.isHidden = true
        //self.ShareButton.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.Upgrade.isHidden = true
        
        //Very nice addition on 20160823!
        loadLocalChartData()
        
        //Added this bit with Pat on 20160804, to download the file
        let url = URL(string: "https://api.venezuelaecon.com/output.php?table=ve_fx&format=json&start=2017-11-15&key=" + Utils.shared.APIKey)!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data , error == nil else {
                print("Didn't download properly")
                self.viewDidLoad() // After Apple rejected a version in Feb 2017, I added this to try again with downloading the data on 20170227 on flight to Panama
                return
            }
            
            guard let optionalJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: AnyObject]],
                let json = optionalJSON else
            {
                print("Did download but the data doesn't look like JSON")
                return
            }
            
         DispatchQueue.main.async(execute: { () -> Void in // Does this bit need to be in main thread? Much quicker if so

            self.Data(json)
            
            //Set all the text.
            var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Dicom, date: Utils.shared.Today()))! + " <font size=2>BsF/$</font></font>"
            var encodedData = text.data(using: String.Encoding.utf8)!
            var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.DicomVal.attributedText = attributedString
                
            } catch _ {}
            
            
            //Utils.shared.Compare(self.Dicom, date: Utils.shared.Yesterday(), label: self.DicomYesterday, type: "FX")
            Utils.shared.Compare(self.Dicom, date: Utils.shared.OneMonthAgo(), label: self.DicomMonth, type: "FX")
            //Utils.shared.Compare(self.Dicom, date: Utils.shared.YearsAgo(1), label: self.DicomYear, type: "FX")
            

             text = "<CENTER><font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.M2_Res, date: Utils.shared.Today()))! + " <font size=2>BsF/$</font></font></CENTER>"
             encodedData = text.data(using: String.Encoding.utf8)!
             attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.M2_ResVal.attributedText = attributedString
                
            } catch _ {}

             text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Official, date: Utils.shared.Today()))! + " <font size=2>BsF/$</font></font>"
             encodedData = text.data(using: String.Encoding.utf8)!
             attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.DIPROVal.attributedText = attributedString
                
            } catch _ {}

            text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.BM, date: Utils.shared.Today()))! + " <font size=2>BsF/$</font></font>"
            encodedData = text.data(using: String.Encoding.utf8)!
            attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.BlackMarketVal.attributedText = attributedString
                
            } catch _ {}
            
            
            //Utils.shared.Compare(self.BM, date: Utils.shared.Yesterday(), label: self.BlackMarketYesterday, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.OneMonthAgo(), label: self.BlackMarketMonth, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(1), label: self.BlackMarketYear, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(2), label: self.BlackMarketTwoYear, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(3), label: self.BlackMarketThreeYear, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(4), label: self.BlackMarketFourYear, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(5), label: self.BlackMarketFiveYear, type: "FX")
            
         


            //DRAW THE GRAPHS
            self.chart.canvasAreaBackgroundColor = UIColor.black
            self.chart.backgroundColor = UIColor.black
            self.chart.canvas.backgroundColor = UIColor.blue
            self.chart.plotAreaBackgroundColor = UIColor.black
            
          
            self.chart.legend.placement = .insidePlotArea
            self.chart.legend.position = .bottomMiddle
            self.chart.legend.style.areaColor = UIColor.black
            self.chart.legend.style.fontColor = UIColor.white
            self.chart.legend.isHidden = true
            
            
            self.chart.crosshair?.style.lineColor = UIColor.white
            self.chart.crosshair?.style.lineWidth = 1
            
        
            // Axes
            self.xAxis.title = NSLocalizedString("Date", comment: "")
            self.yAxis.title = NSLocalizedString("Exchange Rate", comment: "")+" (1,000 " + units + ")"
            if SubscriptionService.shared.isSubscriptionValid() //20171111
            {
                self.enablePanningAndZoomingOnAxis(self.xAxis)
                self.enablePanningAndZoomingOnAxis(self.yAxis)
            }
            self.xAxis.style.lineColor = UIColor.white
            self.yAxis.style.lineColor = UIColor.white
            self.xAxis.style.titleStyle.textColor = UIColor.white
            self.yAxis.style.titleStyle.textColor = UIColor.white
            self.xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
            self.yAxis.rangePaddingLow = 1
            self.yAxis.rangePaddingHigh = 1
            self.xAxis.style.majorGridLineStyle.showMajorGridLines = false
            self.xAxis.style.lineWidth = 1
            self.yAxis.style.lineWidth = 1
            self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: self.BM.values.max()!/1000 as NSNumber!)
            
            self.chart.xAxis = self.xAxis
            self.chart.yAxis = self.yAxis
            
            self.chart.clipsToBounds = false
            
            self.chart.datasource = self
            self.chart.positionLegend()
            
            if !SubscriptionService.shared.isSubscriptionValid() //20171111
            {
                var i : Int = 0
                while (i<(self.RangeController.numberOfSegments-2))
                {
                 self.RangeController.setEnabled(false, forSegmentAt: i)
                 i = i+1
                }
            }
    
            //All set to make everything visible again!
            self.Activity.isHidden = true
            self.Header.isHidden = false
            self.AllText.isHidden = false
            self.DicomMonth.isHidden = true // 20171111 as never changes any more
            self.DicomYear.isHidden = true
            self.RangeController.isHidden = false
            self.chart.isHidden = false
            self.ShowMenuButton.isHidden = false
            //self.ShareButton.isHidden = false
            if !SubscriptionService.shared.isSubscriptionValid() //20171111
            {
                self.Upgrade.isHidden = false
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            self.RangeControl(2 as AnyObject)


            
            })
   
            
        }) 
        task.resume()
        
        if !SubscriptionService.shared.isSubscriptionValid()
        {
         delay(6)
         {
             if self.interstitial.isReady {
                 self.interstitial.present(fromRootViewController: self)
             } else {
                 print("Ad wasn't ready")
             }
         }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet var ShowMenuButton: UIButton!
    //@IBOutlet var ShareButton: UIButton!

    @IBAction func ShowMenu(_ sender: AnyObject) {
                toggleSideMenuView()
    }
    
    
//    @IBAction func ShareButton(_ sender: UIButton) {
//        
//            let objectsToShare = ["Venezuela Econ", view.snapshotImage(afterScreenUpdates: false)!, NSURL(string: "http://appsto.re/gb/LaYucb.i")] as [Any]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//        
//            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
//            
//            activityVC.popoverPresentationController?.sourceView = sender
//            self.present(activityVC, animated: true, completion: nil)
//        
//        
//    }
    
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
    
    @IBOutlet var Upgrade: UIButton!
    @IBAction func UpgradeButton(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewController(withIdentifier: "BuyViewController")
        sideMenuController()?.setContentViewController(destViewController)
    }
    
/*This is how you switch to another View Controller
    @IBAction func Calculator(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FXCalcViewController")
        sideMenuController()?.setContentViewController(destViewController)
        
    }*/
    
func enablePanningAndZoomingOnAxis(_ axis: SChartAxis) {
    axis.enableGesturePanning = true
    axis.enableGestureZooming = true
}
    
    
//LOCAL LOADING
func loadLocalChartData() {
    
for dataPoint in Utils.shared.JSONDataFromFile("FXdata") {
            
    guard let
        dateString = dataPoint["date"] as? String,
        let OfficialVal = dataPoint["official"] as? String,
        let BMVal = dataPoint["bm"] as? String,
        let SimadiVal = dataPoint["simadi"] as? String,
        let DicomVal = dataPoint["dicom"] as? String,
        let SitmeVal = dataPoint["sitme"] as? String,
        let Sicad1Val = dataPoint["sicad1"] as? String,
        let Sicad2Val = dataPoint["sicad2"] as? String,
        let SuppVal = dataPoint["sicad2"] as? String,
        let M2_ResVal = dataPoint["m2_res"] as? String
        else {
            print("Data is JSON but not the JSON variables expected")
            return
    }
    
    //let date = dateFormatter.date(from: dateString)
    
    guard let date = dateFormatter.date(from: dateString) else
    {
        print(dateString)
        continue
    }
    
    if (BMVal != "0")
    {
        BM[dateString] = Double(BMVal) // Adds to my dictionary
        let DataPointBM = SChartDataPoint() // Adds to graph data
        DataPointBM.xValue = date
        DataPointBM.yValue = Double(BMVal)!/1000.0
        DataBM.append(DataPointBM)
    }
    
    if (OfficialVal != "0")
    {
        Official[dateString] = Double(OfficialVal)
        let DataPointOfficial = SChartDataPoint()
        DataPointOfficial.xValue = date
        DataPointOfficial.yValue = Double(OfficialVal)!/1000.0
        DataOfficial.append(DataPointOfficial)
    }
    
    if (SimadiVal != "0")
    {
        Simadi[dateString] = Double(SimadiVal)
        let DataPointSimadi = SChartDataPoint()
        DataPointSimadi.xValue = date
        DataPointSimadi.yValue = Double(SimadiVal)!/1000.0
        DataSimadi.append(DataPointSimadi)
    }
    
    if (DicomVal != "0")
    {
        Dicom[dateString] = Double(DicomVal)
        let DataPointDicom = SChartDataPoint()
        DataPointDicom.xValue = date
        DataPointDicom.yValue = Double(DicomVal)!/1000.0
        DataDicom.append(DataPointDicom)
    }
    
    if (M2_ResVal != "0")
    {
        M2_Res[dateString] = Double(M2_ResVal)
        let DataPointM2_Res = SChartDataPoint()
        DataPointM2_Res.xValue = date
        DataPointM2_Res.yValue = Double(M2_ResVal)!/1000.0
        DataM2_Res.append(DataPointM2_Res)
    }
    
    if (SitmeVal != "0")
    {
        let DataPointSitme = SChartDataPoint()
        DataPointSitme.xValue = date
        DataPointSitme.yValue = Double(SitmeVal)!/1000.0
        DataSitme.append(DataPointSitme)
    }
    
    if (Sicad1Val != "0")
    {
        let DataPointSicad1 = SChartDataPoint()
        DataPointSicad1.xValue = date
        DataPointSicad1.yValue = Double(Sicad1Val)!/1000.0
        DataSicad1.append(DataPointSicad1)
    }
    
    if (Sicad2Val != "0")
    {
        let DataPointSicad2 = SChartDataPoint()
        DataPointSicad2.xValue = date
        DataPointSicad2.yValue = Double(Sicad2Val)!/1000.0
        DataSicad2.append(DataPointSicad2)
    }
    
    if (SuppVal != "0")
    {
        let DataPointSupp = SChartDataPoint()
        DataPointSupp.xValue = date
        DataPointSupp.yValue = Double(SuppVal)!/1000.0
        DataSupp.append(DataPointSupp)
    }
    
    }

}

    
    
func Data(_ json : [[String : AnyObject]]) {
    
    for dataPoint in json {
        
        guard let
            dateString = dataPoint["date"] as? String,
            let OfficialVal = dataPoint["official"] as? String,
            let BMVal = dataPoint["bm"] as? String,
            let SimadiVal = dataPoint["simadi"] as? String,
            let DicomVal = dataPoint["dicom"] as? String,
            let SitmeVal = dataPoint["sitme"] as? String,
            let Sicad1Val = dataPoint["sicad1"] as? String,
            let Sicad2Val = dataPoint["sicad2"] as? String,
            let SuppVal = dataPoint["sicad2"] as? String,
            let M2_ResVal = dataPoint["m2_res"] as? String
            else {
                print("Data is JSON but not the JSON variables expected")
                return
        }
        
        //let date = dateFormatter.date(from: dateString)
        
        guard let date = dateFormatter.date(from: dateString) else
        {
            print(dateString)
            continue
        }
        
        if (BMVal != "0")
        {
            BM[dateString] = Double(BMVal) // Adds to my dictionary
            let DataPointBM = SChartDataPoint() // Adds to graph data
            DataPointBM.xValue = date
            DataPointBM.yValue = Double(BMVal)!/1000.0
            DataBM.append(DataPointBM)
        }
        
        if (OfficialVal != "0")
        {
            Official[dateString] = Double(OfficialVal)
            let DataPointOfficial = SChartDataPoint()
            DataPointOfficial.xValue = date
            DataPointOfficial.yValue = Double(OfficialVal)!/1000.0
            DataOfficial.append(DataPointOfficial)
        }
        
        if (SimadiVal != "0")
        {
            Simadi[dateString] = Double(SimadiVal)
            let DataPointSimadi = SChartDataPoint()
            DataPointSimadi.xValue = date
            DataPointSimadi.yValue = Double(SimadiVal)!/1000.0
            DataSimadi.append(DataPointSimadi)
        }
        
        if (DicomVal != "0")
        {
            Dicom[dateString] = Double(DicomVal)
            let DataPointDicom = SChartDataPoint()
            DataPointDicom.xValue = date
            DataPointDicom.yValue = Double(DicomVal)!/1000.0
            DataDicom.append(DataPointDicom)
        }
        
        if (M2_ResVal != "0")
        {
            M2_Res[dateString] = Double(M2_ResVal)
            let DataPointM2_Res = SChartDataPoint()
            DataPointM2_Res.xValue = date
            DataPointM2_Res.yValue = Double(M2_ResVal)!/1000.0
            DataM2_Res.append(DataPointM2_Res)
        }
        
        if (SitmeVal != "0")
        {
            let DataPointSitme = SChartDataPoint()
            DataPointSitme.xValue = date
            DataPointSitme.yValue = Double(SitmeVal)!/1000.0
            DataSitme.append(DataPointSitme)
        }
        
        if (Sicad1Val != "0")
        {
            let DataPointSicad1 = SChartDataPoint()
            DataPointSicad1.xValue = date
            DataPointSicad1.yValue = Double(Sicad1Val)!/1000.0
            DataSicad1.append(DataPointSicad1)
        }
        
        if (Sicad2Val != "0")
        {
            let DataPointSicad2 = SChartDataPoint()
            DataPointSicad2.xValue = date
            DataPointSicad2.yValue = Double(Sicad2Val)!/1000.0
            DataSicad2.append(DataPointSicad2)
        }
        
        if (SuppVal != "0")
        {
            let DataPointSupp = SChartDataPoint()
            DataPointSupp.xValue = date
            DataPointSupp.yValue = Double(SuppVal)!/1000.0
            DataSupp.append(DataPointSupp)
        }
        
    }
}


func numberOfSeries(inSChart chart: ShinobiChart) -> Int {
    return 8
}

    
func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
    
    let lineSeries = SChartLineSeries()
    lineSeries.style().lineWidth = 2
    lineSeries.animationEnabled = false
    lineSeries.crosshairEnabled = true
    
    let titles : [String] = [NSLocalizedString("Black Market", comment: ""), "DIPRO", "SIMADI", "DICOM", NSLocalizedString("M2/Reserves", comment: ""), "Sitme", "Sicad I", "Sicad II", NSLocalizedString("Supplementary", comment: "")]
    let colors : [UIColor] = [UIColor.red, UIColor.green, UIColor.brown, UIColor.orange, UIColor.white, UIColor.blue, UIColor.purple, UIColor.gray, UIColor.lightGray]
    
    lineSeries.title = titles[index]
    lineSeries.style().lineColor = colors[index]
    
    /*
    if index == 0 {
        lineSeries.title = "BM"
        lineSeries.style().lineColor = UIColor.redColor()
    } etc
 */
    
    
    return lineSeries
    
}
    
    
    
func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
    
    let counts : [Int] = [DataBM.count,DataOfficial.count,DataSimadi.count, DataDicom.count, DataM2_Res.count, DataSitme.count, DataSicad1.count, DataSicad2.count, DataSupp.count]
    
    return counts[seriesIndex]
    
    /* if seriesIndex == 0
     {
     return DataBM.count
     } etc */
    
}

func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
    
    if seriesIndex == 0
    {
        return DataBM[dataIndex]
    }
    if seriesIndex == 1
    {
        return DataOfficial[dataIndex]
    }
    if seriesIndex == 2
    {
        return DataSimadi[dataIndex]
    }
    if seriesIndex == 3
    {
        return DataDicom[dataIndex]
    }
    if seriesIndex == 4
    {
        return DataM2_Res[dataIndex]
    }
    if seriesIndex == 5
    {
        return DataSitme[dataIndex]
    }
    if seriesIndex == 6
    {
        return DataSicad1[dataIndex]
    }
    if seriesIndex == 7
    {
        return DataSicad2[dataIndex]
    }
    if seriesIndex == 8
    {
        return DataSupp[dataIndex]
    }
    else { return DataM2_Res[dataIndex] }
    }


}

//https://stackoverflow.com/questions/38031137/how-to-program-a-delay-in-swift-3 20171125
func delay(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}


