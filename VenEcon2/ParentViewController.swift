//
//  ParentViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 14/12/2017.
//  Copyright © 2017 Girish Gupta. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds



enum Indicator : String
   {
        case FX, Bitcoin, Reserves, Inflation, TaxRevenue, MoneySupply, MinimumWage, OilPrices, CrudeProduction, USOil, TaxUnit
    
        var RawValue : String
        {
            return self.rawValue
        }
    
        var HeaderText : String
        {
            switch self
            {
                case .FX : return NSLocalizedString("Exchange Rates", comment: "")
                case .Bitcoin : return NSLocalizedString("Bitcoin", comment: "")
                case .Reserves : return NSLocalizedString("Foreign Reserves", comment: "")
                case .Inflation : return NSLocalizedString("Inflation", comment: "")
                case .TaxRevenue : return NSLocalizedString("Tax Revenue", comment: "")
                case .MoneySupply : return NSLocalizedString("Money Supply", comment: "")
                case .MinimumWage : return NSLocalizedString("Minimum Wage", comment: "")
                case .OilPrices : return NSLocalizedString("Oil Prices", comment: "")
                case .CrudeProduction : return NSLocalizedString("Crude Production", comment: "")
                case .USOil : return NSLocalizedString("U.S. Oil", comment: "")
                case .TaxUnit : return NSLocalizedString("Tax Unit", comment: "")
            }
        }
    
        var mySQLTableName : String
        {
            switch self
            {
                case .FX : return Utils.shared.CountryCode + "_" + "fx"
                case .Bitcoin : return Utils.shared.CountryCode + "_" + "fx"
                case .Reserves : return Utils.shared.CountryCode + "_" + "res"
                case .Inflation : return Utils.shared.CountryCode + "_" + "inf2"
                case .TaxRevenue : return Utils.shared.CountryCode + "_" + "tax"
                case .MoneySupply : return Utils.shared.CountryCode + "_" + "m2"
                case .MinimumWage :  return Utils.shared.CountryCode + "_" + "mw"
                case .OilPrices :  return Utils.shared.CountryCode + "_" + "oil"
                case .CrudeProduction :  return Utils.shared.CountryCode + "_" + "crudeproduction"
                case .USOil :  return Utils.shared.CountryCode + "_" + "USimpexp"
                case .TaxUnit : return Utils.shared.CountryCode + "_" + "ut"
            }
        }
    
        var StartDate : String
        {
            switch self
            {
                case .FX : return "2017-11-15"
                case .Bitcoin : return "2017-11-15"
                case .Reserves : return "2017-11-15"
                case .TaxRevenue : return "2017-07-31"
                case .MoneySupply : return "2017-07-28"
                case .OilPrices :  return "2017-08-09"
                case .CrudeProduction :  return "2017-12-01"
                case .USOil :  return "2016-12-15"
                case .Inflation : return "2017-12-31"
                default: return "1970-01-01"
            }
        }
    
        var JSONFile : String?
        {
            switch self
            {
                case .FX : return "FXdata"
                case .Bitcoin : return "FXdata"
                case .Reserves : return "ResData"
                case .TaxRevenue : return "TaxRevData"
                case .MoneySupply : return "M2Data"
                case .OilPrices :  return "OilData"
                case .USOil : return "USOilData"
                case . CrudeProduction: return "CrudeProductionData"
                case .Inflation: return "InfData"
                default: return nil
            }
        }
    
        var numberOfSeries : Int
        {
            switch self
            {
                case .FX:
                    return 8
                case .Inflation, .OilPrices:
                    return 4
                case .CrudeProduction:
                    return 2
                case .USOil:
                    return 2
                case .MoneySupply:
                    return 2
                default:
                    return 1
            }
        }
    
    
    
    
    }

class ParentViewController: UIViewController, HeaderViewDelegate, ENSideMenuDelegate, SChartDatasource
{
    //Variables to hold data
    var BM = [String: Double]()
    var Official = [String: Double]()
    var Simadi = [String: Double]()
    var Dicom = [String: Double]()
    var M2_Res = [String: Double]()
    
    var Bitcoin = [String: Double]()
    
    var Reserves = [String: Double]()
    
    var CEDICE = [String: Double]()
    var Ecoanalitica = [String: Double]()
    var NA = [String: Double]()
    var BPP = [String: Double]()
    
    var TaxRev = [String: Double]()
    
    var M0 = [String: Double]()
    var M2 = [String: Double]()
    
    var DollarMinWage = [String: Double]()
    var BolivarMinWage = [String: Double]()
    
    var WTI = [String: Double]()
    var Brent = [String: Double]()
    var Ven = [String: Double]()
    var OPEC = [String: Double]()
    
    var Direct = [String: Double]()
    var Secondary = [String: Double]()
    
    var USexports = [String: Double]()
    var USimports = [String: Double]()
    
    var TaxUnit = [String: Double]()
    
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
    
    var DataBitcoin: [SChartDataPoint] = []
    
    var DataReserves: [SChartDataPoint] = []
    
    var DataCEDICE: [SChartDataPoint] = []
    var DataEcoanalitica: [SChartDataPoint] = []
    var DataNA: [SChartDataPoint] = []
    var DataBPP: [SChartDataPoint] = []
    
    var DataTaxRev: [SChartDataPoint] = []
    
    var DataM0: [SChartDataPoint] = []
    var DataM2: [SChartDataPoint] = []
    
    var DataDollarMinWage: [SChartDataPoint] = []
    var DataBolivarMinWage: [SChartDataPoint] = []
    
    var DataWTI: [SChartDataPoint] = []
    var DataBrent: [SChartDataPoint] = []
    var DataVen: [SChartDataPoint] = []
    var DataOPEC: [SChartDataPoint] = []
    
    var DataDirect: [SChartDataPoint] = []
    var DataSecondary: [SChartDataPoint] = []
    
    var DataUSexports: [SChartDataPoint] = []
    var DataUSimports: [SChartDataPoint] = []

    var DataTaxUnit: [SChartDataPoint] = []
    
    //Axes
    let xAxis = SChartDiscontinuousDateTimeAxis()
    let yAxis = SChartNumberAxis()
    //let yAxis = SChartLogarithmicAxis()
    
    var Indicator : Indicator = .FX // for when first open app (and default)
    
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var Header: HeaderView!
    @IBOutlet weak var ContainerForChild: UIView!
    @IBOutlet weak var StackForChartAndSegmentedControl: UIStackView!
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    @IBOutlet weak var Chart: ShinobiChart!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    

//    @IBAction func SegmentedControl(_ sender: AnyObject)
//    {
//        var Start : String = Utils.shared.YearsAgo(4)
//        switch SegmentedControl.selectedSegmentIndex
//        {
//            case 0:
//                Start = Utils.shared.YearsAgo(32)
//                xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
//            case 1:
//                Start = Utils.shared.YearsAgo(16)
//                xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
//            case 2:
//                Start = Utils.shared.YearsAgo(8)
//                xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
//            case 3:
//                Start = Utils.shared.YearsAgo(4)
//                xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
//            case 4:
//                Start = Utils.shared.YearsAgo(2)
//                xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
//            default:
//                break;
//        }
//
//        let startDate = Utils.shared.dateFormatter.date(from: Start)
//        let endDate = Date()
//
//        Chart.xAxis!.defaultRange = SChartDateRange(dateMinimum: startDate, andDateMaximum: endDate)
//
//        Chart.reloadData()
//        Chart.redraw()
//   }

    
//    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval)
//    {
//        if (toInterfaceOrientation == .portrait)
//        {
//            Header.isHidden = false
//            ContainerForChild.isHidden = false
//        }
//        else
//        {
//            Header.isHidden = true
//            ContainerForChild.isHidden = true
//            
//            //THESE ABOVE AND HERE
////            ChartSVHeight.isActive = true
////            ChartSVHeight.constant = view.frame.width
////            DistanceBetweenAllTextAndChartSV.isActive = false
////            ChartSVToTop.isActive = true
////            ChartSVToTop.constant = 0
//        }
//    }
//    
    
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    var child : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ContainerForChild.isHidden = true
        StackForChartAndSegmentedControl.isHidden = true
        
        ActivityIndicator.hidesWhenStopped = true
        ActivityIndicator.startAnimating()

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
                
                guard let data_ = data
                else
                {
                    print("No internet connection")
                    return
                }
                
                if let response_ = String(data: data!, encoding: String.Encoding.utf8)
                {
                    print(response_)
                    
                }
                else
                {
                    print("Couldn't do")
                }
                
            })
            
            task_.resume() 
            
        }
        else
        {
            print ("Firebase token not found?")
        }
        
        
        
        
        
        
        
        
        if !SubscriptionService.shared.isSubscriptionValid()
        {
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-7175811277195688/1463700737") //LIVE
            //interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") // DEVELOPMENT
            let requestad = GADRequest()
            if (Utils.shared.DevelopmentMode==false)
            {
                interstitial.load(requestad)
            }
            //https://developers.google.com/admob/ios/interstitial 20171125 https://apps.admob.com/v2/apps/7903495316/adunits/create?pli=1
        }
        
    
        
    
        switch Indicator
        {
            case .FX:
                child = (storyboard?.instantiateViewController(withIdentifier: "FXChild")) as! FXChild
            case .Bitcoin:
                child = (storyboard?.instantiateViewController(withIdentifier: "SingleColumnChild")) as! SingleColumnChild
            case .Reserves:
                child = (storyboard?.instantiateViewController(withIdentifier: "SingleColumnChild")) as! SingleColumnChild
            case .Inflation:
                child = (storyboard?.instantiateViewController(withIdentifier: "QuadChild")) as! QuadChild
            case .TaxRevenue:
                child = (storyboard?.instantiateViewController(withIdentifier: "SingleColumnChild")) as! SingleColumnChild
            case .MoneySupply:
                child = (storyboard?.instantiateViewController(withIdentifier: "TwoColumnChild")) as! TwoColumnChild
            case .MinimumWage:
                child = (storyboard?.instantiateViewController(withIdentifier: "TwoColumnChild")) as! TwoColumnChild
            case .OilPrices:
                child = (storyboard?.instantiateViewController(withIdentifier: "QuadChild")) as! QuadChild
            case .CrudeProduction:
                child = (storyboard?.instantiateViewController(withIdentifier: "TwoColumnChild")) as! TwoColumnChild
            case .USOil:
                child = (storyboard?.instantiateViewController(withIdentifier: "TwoColumnChild")) as! TwoColumnChild
            case .TaxUnit:
                child = (storyboard?.instantiateViewController(withIdentifier: "SingleColumnChild")) as! SingleColumnChild
        }
        
        child.willMove(toParentViewController: self)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        ContainerForChild.addSubviewAndFill(child.view)
        addChildViewController(child)
        child.didMove(toParentViewController: self)
        
        Header.HeaderLabel.text = Indicator.HeaderText
        Header.delegate = self
        
        if !SubscriptionService.shared.isSubscriptionValid()
        {
            Utils.shared.delay(6)
            {
                if self.interstitial.isReady
                {
                    //Temporarily ditching ads after Apple issue. Will get back at some point. 20180327
                    //self.interstitial.present(fromRootViewController: self)
                }
                else
                {
                    print("Ad not ready")
                }
            }
        }
        
        if (Indicator.JSONFile != nil)
        {
            Data(Utils.shared.JSONDataFromFile(Indicator.JSONFile!)) // 0180108. This gets the local data.
        }
        
        //Added this bit with Pat on 20160804, to download the file
        let url = URL(string: Utils.shared.APIDomain + "/output.php?table=" + Indicator.mySQLTableName + "&format=json&start=" + Indicator.StartDate + "&key=" + Utils.shared.APIKey)!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data , error == nil else
            {
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
            
            DispatchQueue.main.async(execute: { () -> Void in
                
            self.Data(json)
         
            switch self.Indicator
            {
                case .FX:
                    self.FXData()
                case .Bitcoin:
                    self.BitcoinData()
                case .Reserves:
                    self.ReservesData()
                case .Inflation:
                    self.InflationData()
                case .TaxRevenue:
                    self.TaxRevenueData()
                case .MoneySupply:
                    self.MoneySupplyData()
                case .MinimumWage:
                    self.MinimumWageData()
                case .OilPrices:
                    self.OilPricesData()
                case .CrudeProduction:
                    self.CrudeProductionData()
                case .USOil:
                    self.USOilData()
                case .TaxUnit:
                    self.TaxUnitData()
            }
            self.ContainerForChild.isHidden = false
                
                //DRAW THE GRAPHS
                self.Chart.canvasAreaBackgroundColor = UIColor.black
                self.Chart.backgroundColor = UIColor.black
                self.Chart.canvas.backgroundColor = UIColor.blue
                self.Chart.plotAreaBackgroundColor = UIColor.black
                
                self.Chart.legend.placement = .insidePlotArea
                self.Chart.legend.position = .bottomMiddle
                self.Chart.legend.style.areaColor = UIColor.black
                self.Chart.legend.style.fontColor = UIColor.white
                self.Chart.legend.isHidden = true
                
                self.Chart.crosshair?.style.lineColor = UIColor.white
                self.Chart.crosshair?.style.lineWidth = 1
                
                self.xAxis.title = NSLocalizedString("Date", comment: "")
                
                switch self.Indicator
                {
                    case .FX:
                        self.yAxis.title = NSLocalizedString("Exchange Rate", comment: "")+" (1,000 BsF/$)"
                    case .Bitcoin:
                        self.yAxis.title = "Bitcoin ("+NSLocalizedString("million", comment: "") + " BsF / BTC)"
                    case .Reserves:
                        self.yAxis.title = NSLocalizedString("Foreign Reserves", comment: "")+" ($ "+NSLocalizedString("billion", comment: "")+")"
                    case .Inflation:
                        self.yAxis.title = NSLocalizedString("Monthly Inflation", comment: "")+" (%)"
                    case .TaxRevenue:
                        self.yAxis.title = NSLocalizedString("Tax Revenue", comment: "") + " ("+NSLocalizedString("billion", comment: "") + " BsF))"
                    case .MoneySupply:
                        self.yAxis.title = NSLocalizedString("Money Supply", comment: "")+" ("+NSLocalizedString("trillion", comment: "")+" BsF)"
                    case .MinimumWage:
                        self.yAxis.title = NSLocalizedString("Minimum Wage", comment: "")+" ($ / "+NSLocalizedString("month", comment: "")+")"
                    case .OilPrices:
                        self.yAxis.title = NSLocalizedString("Oil Price", comment: "")+" ($ / "+NSLocalizedString("barrel", comment: "")+")"
                    case .CrudeProduction:
                        self.yAxis.title = ""+NSLocalizedString("Crude Production", comment: "")+" ("+NSLocalizedString("million", comment: "")+" "+NSLocalizedString("barrels", comment: "")+"/"+NSLocalizedString("day", comment: "")+")"
                    case .USOil:
                        self.yAxis.title = NSLocalizedString("U.S. Imports/Exports", comment: "")+" ("+NSLocalizedString("million", comment: "")+" "+NSLocalizedString("barrels", comment: "")+" / "+NSLocalizedString("month", comment: "")+")"
                    case .TaxUnit:
                        self.yAxis.title = NSLocalizedString("Tax Unit", comment: "") + " (BsF)"
                }
                
                self.enablePanningAndZoomingOnAxis(self.xAxis)
                self.enablePanningAndZoomingOnAxis(self.yAxis)

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
                switch self.Indicator
                {
                    case .FX:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: self.BM.values.max()!/1000 as NSNumber!)
                    case .Bitcoin:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: NSNumber(floatLiteral: self.Bitcoin.values.max()!))
                    case .Reserves:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: NSNumber(floatLiteral: self.Reserves.values.max()!/1000))
                    case .Inflation:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: self.BPP.values.max()! as NSNumber!)
                    case .TaxRevenue:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: NSNumber(floatLiteral: self.TaxRev.values.max()!))
                    case .MoneySupply:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: NSNumber(floatLiteral: self.M2.values.max()!/1000000000))
                    case .MinimumWage:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: self.DollarMinWage.values.max()! as NSNumber!)
                    case .OilPrices:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: self.WTI.values.max()! as NSNumber!)
                    case .CrudeProduction:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: NSNumber(floatLiteral: self.Secondary.values.max()!/1000))
                    case .USOil:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: NSNumber(floatLiteral: self.USimports.values.max()!/1000))
                    case .TaxUnit:
                        self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: NSNumber(floatLiteral: self.TaxUnit.values.max()!))
                }
                
                
                self.Chart.xAxis = self.xAxis
                self.Chart.yAxis = self.yAxis
                
                self.Chart.clipsToBounds = false
                
                self.Chart.datasource = self
                
                self.Chart.positionLegend()
                
                self.Chart.xAxis?.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
                self.Chart.xAxis!.defaultRange = SChartDateRange(dateMinimum: Utils.shared.dateFormatter.date(from: Utils.shared.YearsAgo(5)), andDateMaximum: Date()) // Added while we don't have the SegmentedControl
                
                
                if !SubscriptionService.shared.isSubscriptionValid() //20171111
                {
                    var i : Int = 0
                    while (i<(self.SegmentedControl.numberOfSegments-2))
                    {
                        self.SegmentedControl.setEnabled(false, forSegmentAt: i)
                        i = i+1
                    }
                }
                
                //All set to make everything visible again!
                
                
                //self.SegmentedControl(2 as AnyObject)
                
                self.StackForChartAndSegmentedControl.isHidden = false
                self.ActivityIndicator.stopAnimating()
            })
            
            
        })
        task.resume()
        
        
    
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    func FXData()
    {
        guard let child = self.child as? FXChild else {return} //20180107 - get here and if the child is FX then do the following:
        
        let units:String = "BsF/$"

        Utils.shared.HTMLText(child.DicomVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Dicom, date: Utils.shared.Today()))!, Units: units)
        Utils.shared.Compare(self.Dicom, date: Utils.shared.OneMonthAgo(), label: child.DicomMonth, type: "FX")
        child.DicomYear.isHidden = true
        child.DicomMonth.isHidden = true
        Utils.shared.HTMLText(child.BlackMarketVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.BM, date: Utils.shared.Today()))!, Units: units)
        Utils.shared.Compare(self.BM, date: Utils.shared.OneMonthAgo(), label: child.BlackMarketMonth, type: "FX")
        Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(1), label: child.BlackMarketYear, type: "FX")
        Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(2), label: child.BlackMarketTwoYear, type: "FX")
        Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(3), label: child.BlackMarketThreeYear, type: "FX")
        Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(4), label: child.BlackMarketFourYear, type: "FX")
        Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(5), label: child.BlackMarketFiveYear, type: "FX")
        Utils.shared.HTMLText(child.M2_ResVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.M2_Res, date: Utils.shared.Today()))!, Units: units)
    }
    
    
    
    func BitcoinData()
    {
        guard let child = self.child as? SingleColumnChild else {return} //20180107 - get here and if the child is a stype of single child then do the following:
        
        child.TopLine.isHidden = true
        
        Utils.shared.HTMLText(child.MainVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Bitcoin, date: Utils.shared.Today()))!, Units: "BsF/BTC")
        
        Utils.shared.Compare(self.Bitcoin, date: Utils.shared.Yesterday(), label: child.Line1, type: nil)
        Utils.shared.Compare(self.Bitcoin, date: Utils.shared.OneMonthAgo(), label: child.Line2, type: nil)
        Utils.shared.Compare(self.Bitcoin, date: Utils.shared.YearsAgo(1), label: child.Line3, type: nil)
        Utils.shared.Compare(self.Bitcoin, date: Utils.shared.YearsAgo(2), label: child.Line4, type: nil)
        Utils.shared.Compare(self.Bitcoin, date: Utils.shared.YearsAgo(3), label: child.Line5, type: nil)
      
    }
    
    
    func ReservesData()
    {
        guard let child = self.child as? SingleColumnChild else {return} //20180107 - get here and if the child is a stype of single child then do the following:
        
        child.TopLine.isHidden = true
        //child.TopLine.text = Utils.shared.dateFormatterText.string(from: Utils.shared.dateFormatter.date(from:Utils.shared.GetLatestNonZeroKey(self.Reserves, date: Utils.shared.Today())[0])!)
        
        Utils.shared.HTMLText(child.MainVal, Text: "$"+Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Reserves, date: Utils.shared.Today()))!, Units: "billion")
        Utils.shared.Compare(self.Reserves, date: Utils.shared.Yesterday(), label: child.Line1, type: nil)
        Utils.shared.Compare(self.Reserves, date: Utils.shared.OneMonthAgo(), label: child.Line2, type: nil)
        Utils.shared.Compare(self.Reserves, date: Utils.shared.YearsAgo(1), label: child.Line3, type: nil)
        Utils.shared.Compare(self.Reserves, date: Utils.shared.YearsAgo(2), label: child.Line4, type: nil)
        Utils.shared.Compare(self.Reserves, date: Utils.shared.YearsAgo(3), label: child.Line5, type: nil)
        
    }
    
    
    
    
    func InflationData()
    {
        guard let child = self.child as? QuadChild else {return}
        
        let units: String = "%"
        
        Utils.shared.HTMLText(child.TopLeftMainVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.CEDICE, date: Utils.shared.Today()))!, Units: units)
        
        child.TopLeftTop.text = "CEDICE"
        child.TopLeftLine1.text = Utils.shared.dateFormatterText.string(from: Utils.shared.dateFormatter.date(from:Utils.shared.GetLatestNonZeroKey(self.CEDICE, date: Utils.shared.Today())[0])!)
        
        
        
        Utils.shared.HTMLText(child.TopRightMainVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Ecoanalitica, date: Utils.shared.Today()))!, Units: units)
        
        child.TopRightTop.text = "Ecoanalítica"
        child.TopRightLine1.text = Utils.shared.dateFormatterText.string(from: Utils.shared.dateFormatter.date(from:Utils.shared.GetLatestNonZeroKey(self.Ecoanalitica, date: Utils.shared.Today())[0])!)
        
        
        
        Utils.shared.HTMLText(child.BottomLeftMainVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.NA, date: Utils.shared.Today()))!, Units: units)
        
        child.BottomLeftTop.text = "National Assembly"
        child.BottomLeftLine1.text = Utils.shared.dateFormatterText.string(from: Utils.shared.dateFormatter.date(from:Utils.shared.GetLatestNonZeroKey(self.NA, date: Utils.shared.Today())[0])!)
        

        Utils.shared.HTMLText(child.BottomRightMainVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.BPP, date: Utils.shared.Today()))!, Units: units)
        
        child.BottomRightTop.text = "MIT Billion Prices"
        child.BottomRightLine1.text = Utils.shared.dateFormatterText.string(from: Utils.shared.dateFormatter.date(from:Utils.shared.GetLatestNonZeroKey(self.BPP, date: Utils.shared.Today())[0])!)
        
        child.TopLeftLine2.isHidden = true
        child.TopLeftLine3.isHidden = true
        child.TopRightLine2.isHidden = true
        child.TopRightLine3.isHidden = true
        child.BottomLeftLine2.isHidden = true
        child.BottomLeftLine3.isHidden = true
        child.BottomRightLine2.isHidden = true
        child.BottomRightLine3.isHidden = true
    }
    
    func TaxRevenueData()
    {
        guard let child = self.child as? SingleColumnChild else {return}
 
        Utils.shared.HTMLText(child.MainVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.TaxRev, date: Utils.shared.Today()))!, Units: NSLocalizedString("billion", comment: "")+" BsF")
        
        child.TopLine.text = Utils.shared.dateFormatterText.string(from: Utils.shared.dateFormatter.date(from:Utils.shared.GetLatestNonZeroKey(self.TaxRev, date: Utils.shared.Today())[0])!)
        
        Utils.shared.Compare(self.TaxRev, date: Utils.shared.OneMonthAgo(), label: child.Line1, type: nil)
        Utils.shared.Compare(self.TaxRev, date: Utils.shared.YearsAgo(1), label: child.Line2, type: nil)
        Utils.shared.Compare(self.TaxRev, date: Utils.shared.YearsAgo(2), label: child.Line3, type: nil)
        Utils.shared.Compare(self.TaxRev, date: Utils.shared.YearsAgo(3), label: child.Line4, type: nil)
        Utils.shared.Compare(self.TaxRev, date: Utils.shared.YearsAgo(4), label: child.Line5, type: nil)
    }
    
    
    
    func MoneySupplyData()
    {
        guard let child = self.child as? TwoColumnChild else {return}
        
        child.LeftTop.text = "M0"
        child.RightTop.text = "M2"
        
        Utils.shared.HTMLText(child.LeftMain, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.M0, date: Utils.shared.Today())/1000000000)!, Units: NSLocalizedString("trillion", comment: "")+" BsF")
        
        Utils.shared.Compare(self.M0, date: Utils.shared.OneMonthAgo(), label: child.Left1, type: nil)
        Utils.shared.Compare(self.M0, date: Utils.shared.YearsAgo(1), label: child.Left2, type: nil)
        Utils.shared.Compare(self.M0, date: Utils.shared.YearsAgo(2), label: child.Left3, type: nil)
        Utils.shared.Compare(self.M0, date: Utils.shared.YearsAgo(3), label: child.Left4, type: nil)
        Utils.shared.Compare(self.M0, date: Utils.shared.YearsAgo(4), label: child.Left5, type: nil)
        
        Utils.shared.HTMLText(child.RightMain, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.M2, date: Utils.shared.Today())/1000000000)!, Units: NSLocalizedString("trillion", comment: "")+" BsF")
        
        Utils.shared.Compare(self.M2, date: Utils.shared.OneMonthAgo(), label: child.Right1, type: nil)
        Utils.shared.Compare(self.M2, date: Utils.shared.YearsAgo(1), label: child.Right2, type: nil)
        Utils.shared.Compare(self.M2, date: Utils.shared.YearsAgo(2), label: child.Right3, type: nil)
        Utils.shared.Compare(self.M2, date: Utils.shared.YearsAgo(3), label: child.Right4, type: nil)
        Utils.shared.Compare(self.M2, date: Utils.shared.YearsAgo(4), label: child.Right5, type: nil)
    }
    
    func MinimumWageData()
    {
        guard let child = self.child as? TwoColumnChild else {return}
        
        child.LeftTop.text = "U.S dollars"
        child.RightTop.text = "Venezuelan bolivars"
        
        Utils.shared.HTMLText(child.LeftMain, Text: "$"+Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.DollarMinWage, date: Utils.shared.Today()))!, Units: "/ "+NSLocalizedString("month", comment: ""))
        Utils.shared.HTMLText(child.RightMain, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.BolivarMinWage, date: Utils.shared.Today())/1000)!, Units: "1,000 BsF / "+NSLocalizedString("month", comment: ""))
        
        Utils.shared.Compare(self.DollarMinWage, date: Utils.shared.OneMonthAgo(), label: child.Left1, type: nil)
        Utils.shared.Compare(self.DollarMinWage, date: Utils.shared.YearsAgo(1), label: child.Left2, type: nil)
        Utils.shared.Compare(self.DollarMinWage, date: Utils.shared.YearsAgo(2), label: child.Left3, type: nil)
        Utils.shared.Compare(self.DollarMinWage, date: Utils.shared.YearsAgo(3), label: child.Left4, type: nil)
        Utils.shared.Compare(self.DollarMinWage, date: Utils.shared.YearsAgo(4), label: child.Left5, type: nil)
        
        Utils.shared.Compare(self.BolivarMinWage, date: Utils.shared.OneMonthAgo(), label: child.Right1, type: nil)
        Utils.shared.Compare(self.BolivarMinWage, date: Utils.shared.YearsAgo(1), label: child.Right2, type: nil)
        Utils.shared.Compare(self.BolivarMinWage, date: Utils.shared.YearsAgo(2), label: child.Right3, type: nil)
        Utils.shared.Compare(self.BolivarMinWage, date: Utils.shared.YearsAgo(3), label: child.Right4, type: nil)
        Utils.shared.Compare(self.BolivarMinWage, date: Utils.shared.YearsAgo(4), label: child.Right5, type: nil)
    }
    
    func OilPricesData()
    {
        
        guard let child = self.child as? QuadChild else {return}
        
        let units: String = "/ " + NSLocalizedString("barrel", comment: "")
        
        child.TopLeftTop.text = "WTI"
        child.TopRightTop.text = "Venezuela"
        child.BottomLeftTop.text = "Brent"
        child.BottomRightTop.text = "OPEC"
        
        Utils.shared.HTMLText(child.TopLeftMainVal, Text: "$" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.WTI, date: Utils.shared.Today()))!, Units: units)
        Utils.shared.HTMLText(child.BottomLeftMainVal, Text: "$" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Brent, date: Utils.shared.Today()))!, Units: units)
        Utils.shared.HTMLText(child.TopRightMainVal, Text: "$" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Ven, date: Utils.shared.Today()))!, Units: units)
        Utils.shared.HTMLText(child.BottomRightMainVal, Text: "$" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.OPEC, date: Utils.shared.Today()))!, Units: units)
        
        Utils.shared.Compare(self.WTI, date: Utils.shared.OneMonthAgo(), label: child.TopLeftLine1, type: nil)
        Utils.shared.Compare(self.WTI, date: Utils.shared.YearsAgo(1), label: child.TopLeftLine2, type: nil)
        Utils.shared.Compare(self.WTI, date: Utils.shared.YearsAgo(2), label: child.TopLeftLine3, type: nil)
        
        Utils.shared.Compare(self.Brent, date: Utils.shared.OneMonthAgo(), label: child.BottomLeftLine1, type: nil)
        Utils.shared.Compare(self.Brent, date: Utils.shared.YearsAgo(1), label: child.BottomLeftLine2, type: nil)
        Utils.shared.Compare(self.Brent, date: Utils.shared.YearsAgo(2), label: child.BottomLeftLine3, type: nil)
        
        Utils.shared.Compare(self.Ven, date: Utils.shared.OneMonthAgo(), label: child.TopRightLine1, type: nil)
        Utils.shared.Compare(self.Ven, date: Utils.shared.YearsAgo(1), label: child.TopRightLine2, type: nil)
        Utils.shared.Compare(self.Ven, date: Utils.shared.YearsAgo(2), label: child.TopRightLine3, type: nil)
        
        Utils.shared.Compare(self.OPEC, date: Utils.shared.OneMonthAgo(), label: child.BottomRightLine1, type: nil)
        Utils.shared.Compare(self.OPEC, date: Utils.shared.YearsAgo(1), label: child.BottomRightLine2, type: nil)
        Utils.shared.Compare(self.OPEC, date: Utils.shared.YearsAgo(2), label: child.BottomRightLine3, type: nil)
    }
    
    
    func CrudeProductionData()
    {
        guard let child = self.child as? TwoColumnChild else {return}
        
        var units: String = NSLocalizedString("million", comment: "")+" "+NSLocalizedString("barrels", comment: "")+" / "+NSLocalizedString("day", comment: "")
        
        child.LeftTop.text = "Direct comm. with OPEC"
        child.RightTop.text = "Secondary sources to OPEC"

        let screenWidth = UIScreen.main.bounds.width
        //let screenHeight = screenSize.height
        //https://stackoverflow.com/questions/24110762/swift-determine-ios-screen-size
        if (screenWidth<667)
        {
            child.LeftTop.text = "Direct comm."
            child.RightTop.text = "Sec. sources"
            units = NSLocalizedString("m", comment: "")+" "+NSLocalizedString("barrels", comment: "")+" / "+NSLocalizedString("day", comment: "")
        }
        
        Utils.shared.HTMLText(child.LeftMain, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Direct, date: Utils.shared.Today())/1000)!, Units: units)
        Utils.shared.HTMLText(child.RightMain, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Secondary, date: Utils.shared.Today())/1000)!, Units: units)
        
        Utils.shared.Compare(self.Direct, date: Utils.shared.YearsAgo(1), label: child.Left1, type: nil)
        Utils.shared.Compare(self.Direct, date: Utils.shared.YearsAgo(2), label: child.Left2, type: nil)
        Utils.shared.Compare(self.Direct, date: Utils.shared.YearsAgo(3), label: child.Left3, type: nil)
        Utils.shared.Compare(self.Direct, date: Utils.shared.YearsAgo(4), label: child.Left4, type: nil)
        Utils.shared.Compare(self.Direct, date: Utils.shared.YearsAgo(5), label: child.Left5, type: nil)
        Utils.shared.Compare(self.Secondary, date: Utils.shared.YearsAgo(1), label: child.Right1, type: nil)
        Utils.shared.Compare(self.Secondary, date: Utils.shared.YearsAgo(2), label: child.Right2, type: nil)
        Utils.shared.Compare(self.Secondary, date: Utils.shared.YearsAgo(3), label: child.Right3, type: nil)
        Utils.shared.Compare(self.Secondary, date: Utils.shared.YearsAgo(4), label: child.Right4, type: nil)
        Utils.shared.Compare(self.Secondary, date: Utils.shared.YearsAgo(4), label: child.Right5, type: nil)
    }
    
    func USOilData()
    {
        guard let child = self.child as? TwoColumnChild else {return}

        let units: String = NSLocalizedString("million", comment: "")+" "+NSLocalizedString("barrels", comment: "")+" / "+NSLocalizedString("month", comment: "")
        
        child.LeftTop.text = "Exports to Venezuela"
        child.RightTop.text = "Imports from Venezuela"
        
        Utils.shared.HTMLText(child.LeftMain, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.USexports, date: Utils.shared.Today())/1000)!, Units: units)
        Utils.shared.HTMLText(child.RightMain, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.USimports, date: Utils.shared.Today())/1000)!, Units: units)

        Utils.shared.Compare(self.USexports, date: Utils.shared.YearsAgo(2), label: child.Left1, type: nil)
        Utils.shared.Compare(self.USexports, date: Utils.shared.YearsAgo(3), label: child.Left2, type: nil)
        Utils.shared.Compare(self.USexports, date: Utils.shared.YearsAgo(4), label: child.Left3, type: nil)
        Utils.shared.Compare(self.USexports, date: Utils.shared.YearsAgo(5), label: child.Left4, type: nil)
        Utils.shared.Compare(self.USexports, date: Utils.shared.YearsAgo(6), label: child.Left5, type: nil)
        Utils.shared.Compare(self.USimports, date: Utils.shared.YearsAgo(2), label: child.Right1, type: nil)
        Utils.shared.Compare(self.USimports, date: Utils.shared.YearsAgo(3), label: child.Right2, type: nil)
        Utils.shared.Compare(self.USimports, date: Utils.shared.YearsAgo(4), label: child.Right3, type: nil)
        Utils.shared.Compare(self.USimports, date: Utils.shared.YearsAgo(5), label: child.Right4, type: nil)
        Utils.shared.Compare(self.USimports, date: Utils.shared.YearsAgo(6), label: child.Right5, type: nil)
    }
    
    
    func TaxUnitData()
    {
        guard let child = self.child as? SingleColumnChild else {return}
        
        child.TopLine.text = Utils.shared.dateFormatterText.string(from: Utils.shared.dateFormatter.date(from:Utils.shared.GetLatestNonZeroKey(self.TaxUnit, date: Utils.shared.Today())[0])!)
        
        Utils.shared.HTMLText(child.MainVal, Text: Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.TaxUnit, date: Utils.shared.Today()))!, Units: "BsF")
        
        Utils.shared.Compare(self.TaxUnit, date: Utils.shared.YearsAgo(1), label: child.Line1, type: nil)
        Utils.shared.Compare(self.TaxUnit, date: Utils.shared.YearsAgo(2), label: child.Line2, type: nil)
        Utils.shared.Compare(self.TaxUnit, date: Utils.shared.YearsAgo(3), label: child.Line3, type: nil)
        Utils.shared.Compare(self.TaxUnit, date: Utils.shared.YearsAgo(4), label: child.Line4, type: nil)
        Utils.shared.Compare(self.TaxUnit, date: Utils.shared.YearsAgo(5), label: child.Line5, type: nil)
    }
    
    
    
    func enablePanningAndZoomingOnAxis(_ axis: SChartAxis) {
        axis.enableGesturePanning = true
        axis.enableGestureZooming = true
    }
    
    
    
    
    func Data(_ json : [[String : AnyObject]])
    {
        
        for dataPoint in json {
            
            if (Indicator == .FX)
            {
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
                    else
                    {
                        print("Data is JSON but not the JSON variables expected")
                        return
                    }
        
            
                    guard let date = Utils.shared.dateFormatter.date(from: dateString) else
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
            else if (Indicator == .Bitcoin)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let BitcoinVal = dataPoint["bitcoin"] as? String
                    else
                {
                    print("Data is JSON but not the JSON variables expected")
                    return
                }
                
                let date = Utils.shared.dateFormatter.date(from: dateString)
                
                if (BitcoinVal != "0")
                {
                    Bitcoin[dateString] = Double(BitcoinVal)!/1000000 // Adds to my dictionary
                    let DataPointBitcoin = SChartDataPoint() // Adds to graph data
                    DataPointBitcoin.xValue = date
                    DataPointBitcoin.yValue = Double(BitcoinVal)!/1000000
                    DataBitcoin.append(DataPointBitcoin)
                }
            }
            else if (Indicator == .Reserves)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let ReservesVal = dataPoint["res"] as? String
                    else
                    {
                        print("Data is JSON but not the JSON variables expected")
                        return
                    }
                
                    let date = Utils.shared.dateFormatter.date(from: dateString)
                
                    if (ReservesVal != "0")
                    {
                        Reserves[dateString] = Double(ReservesVal) // Adds to my dictionary
                        let DataPointReserves = SChartDataPoint() // Adds to graph data
                        DataPointReserves.xValue = date
                        DataPointReserves.yValue = Double(ReservesVal)!/1000
                        DataReserves.append(DataPointReserves)
                    }
            }
            else if (Indicator == .Inflation)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let CEDICEVal = dataPoint["cedice"] as? String,
                    let EcoanaliticaVal = dataPoint["eco_monthly"] as? String, //,
                    let NAVal = dataPoint["na"] as? String,
                    let BPPVal = dataPoint["bpp"] as? String
                    else
                    {
                        print("Data is JSON but not the JSON variables expected")
                        return
                    }
                
                    let date = Utils.shared.dateFormatter.date(from: dateString)
                
                    if (CEDICEVal != "0")
                    {
                        CEDICE[dateString] = Double(CEDICEVal) // Adds to my dictionary
                        let DataPointCEDICE = SChartDataPoint() // Adds to graph data
                        DataPointCEDICE.xValue = date
                        DataPointCEDICE.yValue = Double(CEDICEVal)
                        DataCEDICE.append(DataPointCEDICE)
                    }
                
                    if (EcoanaliticaVal != "0")
                    {
                        Ecoanalitica[dateString] = Double(EcoanaliticaVal)
                        let DataPointEcoanalitica = SChartDataPoint()
                        DataPointEcoanalitica.xValue = date
                        DataPointEcoanalitica.yValue = Double(EcoanaliticaVal)
                        DataEcoanalitica.append(DataPointEcoanalitica)
                    }
                
                    if (NAVal != "0")
                    {
                        NA[dateString] = Double(NAVal)
                        let DataPointNA = SChartDataPoint()
                        DataPointNA.xValue = date
                        DataPointNA.yValue = Double(NAVal)
                        DataNA.append(DataPointNA)
                    }
                
                    if (BPPVal != "0")
                    {
                        BPP[dateString] = Double(BPPVal)
                        let DataPointBPP = SChartDataPoint()
                        DataPointBPP.xValue = date
                        DataPointBPP.yValue = Double(BPPVal)
                        DataBPP.append(DataPointBPP)
                    }
            }
            else if (Indicator == .TaxRevenue)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let TaxRevVal = dataPoint["tax"] as? String
                    else
                    {
                        print("Data is JSON but not the JSON variables expected 4")
                        return
                    }
                
                    let date = Utils.shared.dateFormatter.date(from: dateString)
                
                    if (TaxRevVal != "0")
                    {
                        TaxRev[dateString] = Double(TaxRevVal)!/1000000000 // Adds to my dictionary
                        let DataPointTaxRev = SChartDataPoint() // Adds to graph data
                        DataPointTaxRev.xValue = date
                        DataPointTaxRev.yValue = Double(TaxRevVal)!/1000000000
                        DataTaxRev.append(DataPointTaxRev)
                    }
            }
            else if (Indicator == .MoneySupply)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let M0Val = dataPoint["m0"] as? String,
                    let M2Val = dataPoint["m2"] as? String
                    else
                    {
                        print("Data is JSON but not the JSON variables expected")
                        return
                    }
                
                    let date = Utils.shared.dateFormatter.date(from: dateString)
                
                    if (M0Val != "0")
                    {
                        M0[dateString] = Double(M0Val)! // Adds to my dictionary
                        let DataPointM0 = SChartDataPoint() // Adds to graph data
                        DataPointM0.xValue = date
                        DataPointM0.yValue = Double(M0Val)!/1000000000
                        DataM0.append(DataPointM0)
                    }
                
                    if (M2Val != "0")
                    {
                        M2[dateString] = Double(M2Val)! // Adds to my dictionary
                        let DataPointM2 = SChartDataPoint() // Adds to graph data
                        DataPointM2.xValue = date
                        DataPointM2.yValue = Double(M2Val)!/1000000000
                        DataM2.append(DataPointM2)
                    }
            }
            else if (Indicator == .MinimumWage)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let DollarMinWageVal = dataPoint["usd_bm"] as? String,
                    let BolivarMinWageVal = dataPoint["mw"] as? String
                    else
                    {
                        print("Data is JSON but not the JSON variables expected")
                        return
                    }
                
                    let date = Utils.shared.dateFormatter.date(from: dateString)
                
                    if (DollarMinWageVal != "0")
                    {
                        DollarMinWage[dateString] = Double(DollarMinWageVal)! // Adds to my dictionary
                        let DataPointDollarMinWage = SChartDataPoint() // Adds to graph data
                        DataPointDollarMinWage.xValue = date
                        DataPointDollarMinWage.yValue = Double(DollarMinWageVal)!
                        DataDollarMinWage.append(DataPointDollarMinWage)
                    }
                
                    if (BolivarMinWageVal != "0")
                    {
                        BolivarMinWage[dateString] = Double(BolivarMinWageVal)! // Adds to my dictionary
                        let DataPointBolivarMinWage = SChartDataPoint() // Adds to graph data
                        DataPointBolivarMinWage.xValue = date
                        DataPointBolivarMinWage.yValue = Double(BolivarMinWageVal)!
                        DataBolivarMinWage.append(DataPointBolivarMinWage)
                    }
            }
            else if (Indicator == .OilPrices)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let WTIVal = dataPoint["wti"] as? String,
                    let BrentVal = dataPoint["brent"] as? String,
                    let VenVal = dataPoint["ven"] as? String,
                    let OPECVal = dataPoint["opec"] as? String
                    else
                    {
                        print("Data is JSON but not the JSON variables expected")
                        return
                    }
                
                    let date = Utils.shared.dateFormatter.date(from: dateString)
                
                    if (WTIVal != "0")
                    {
                        WTI[dateString] = Double(WTIVal) // Adds to my dictionary
                        let DataPointWTI = SChartDataPoint() // Adds to graph data
                        DataPointWTI.xValue = date
                        DataPointWTI.yValue = Double(WTIVal)
                        DataWTI.append(DataPointWTI)
                    }
                
                    if (BrentVal != "0")
                    {
                        Brent[dateString] = Double(BrentVal)
                        let DataPointBrent = SChartDataPoint()
                        DataPointBrent.xValue = date
                        DataPointBrent.yValue = Double(BrentVal)
                        DataBrent.append(DataPointBrent)
                    }
                
                    if (VenVal != "0")
                    {
                        Ven[dateString] = Double(VenVal)
                        let DataPointVen = SChartDataPoint()
                        DataPointVen.xValue = date
                        DataPointVen.yValue = Double(VenVal)
                        DataVen.append(DataPointVen)
                    }
                
                    if (OPECVal != "0")
                    {
                        OPEC[dateString] = Double(OPECVal)
                        let DataPointOPEC = SChartDataPoint()
                        DataPointOPEC.xValue = date
                        DataPointOPEC.yValue = Double(OPECVal)
                        DataOPEC.append(DataPointOPEC)
                    }
            }
            if (Indicator == .CrudeProduction)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let DirectVal = dataPoint["direct"] as? String,
                    let SecondaryVal = dataPoint["secondary"] as? String
                    else
                    {
                        print("Data is JSON but not the JSON variables expected")
                        return
                    }
                
                    let date = Utils.shared.dateFormatter.date(from: dateString)
                
                    if (DirectVal != "0")
                    {
                        Direct[dateString] = Double(DirectVal) // Adds to my dictionary
                        let DataPointDirect = SChartDataPoint() // Adds to graph data
                        DataPointDirect.xValue = date
                        DataPointDirect.yValue = Double(DirectVal)!/1000
                        DataDirect.append(DataPointDirect)
                    }
                
                    if (SecondaryVal != "0")
                    {
                        Secondary[dateString] = Double(SecondaryVal) // Adds to my dictionary
                        let DataPointSecondary = SChartDataPoint() // Adds to graph data
                        DataPointSecondary.xValue = date
                        DataPointSecondary.yValue = Double(SecondaryVal)!/1000
                        DataSecondary.append(DataPointSecondary)
                    }
                
            }
            if (Indicator == .USOil)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let USexportsVal = dataPoint["exp"] as? String,
                    let USimportsVal = dataPoint["imp"] as? String
                    else
                    {
                        print("Data is JSON but not the JSON variables expected")
                        return
                    }
                
                    let date = Utils.shared.dateFormatter.date(from: dateString)
                
                    if (USexportsVal != "0")
                    {
                        USexports[dateString] = Double(USexportsVal) // Adds to my dictionary
                        let DataPointUSexports = SChartDataPoint() // Adds to graph data
                        DataPointUSexports.xValue = date
                        DataPointUSexports.yValue = Double(USexportsVal)!/1000
                        DataUSexports.append(DataPointUSexports)
                    }
                
                    if (USimportsVal != "0")
                    {
                        USimports[dateString] = Double(USimportsVal) // Adds to my dictionary
                        let DataPointUSimports = SChartDataPoint() // Adds to graph data
                        DataPointUSimports.xValue = date
                        DataPointUSimports.yValue = Double(USimportsVal)!/1000
                        DataUSimports.append(DataPointUSimports)
                    }
            }
            if (Indicator == .TaxUnit)
            {
                guard let
                    dateString = dataPoint["date"] as? String,
                    let TaxUnitVal = dataPoint["ut"] as? String
                    else
                    {
                        print("Data is JSON but not the JSON variables expected 3")
                        return
                    }
                
                    let date = Utils.shared.dateFormatter.date(from: dateString)
                
                    if (TaxUnitVal != "0")
                    {
                        TaxUnit[dateString] = Double(TaxUnitVal)! // Adds to my dictionary
                        let DataPointTaxUnit = SChartDataPoint() // Adds to graph data
                        DataPointTaxUnit.xValue = date
                        DataPointTaxUnit.yValue = Double(TaxUnitVal)!
                        DataTaxUnit.append(DataPointTaxUnit)
                    }
            }
        }
    }
    
    
    func numberOfSeries(inSChart chart: ShinobiChart) -> Int
    {
        return Indicator.numberOfSeries
    }
    
    
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        
        let lineSeries = SChartLineSeries()
        lineSeries.style().lineWidth = 2
        lineSeries.animationEnabled = false
        lineSeries.crosshairEnabled = true
        
        var titles : [String] = ["XXX"]
        var colors : [UIColor] = [UIColor.red]
        
        if (Indicator == .FX)
        {
            titles = [NSLocalizedString("Black Market", comment: ""), "DIPRO", "SIMADI", "DICOM", NSLocalizedString("M2/Reserves", comment: ""), "Sitme", "Sicad I", "Sicad II", NSLocalizedString("Supplementary", comment: "")]
            colors = [UIColor.red, UIColor.green, UIColor.brown, UIColor.orange, UIColor.white, UIColor.blue, UIColor.purple, UIColor.gray, UIColor.lightGray]
        }
        else if (Indicator == .Bitcoin)
        {
            titles = ["Bitcoin"]
            colors = [UIColor.red]
        }
        else if (Indicator == .Reserves)
        {
            titles = ["Reserves"]
            colors = [UIColor.red]
        }
        else if (Indicator == .Inflation)
        {
            titles = ["CEDICE", "Ecoanalitica", "National Assembly", "MIT Billion Prices"]
            colors = [UIColor.orange, UIColor.green, UIColor.white, UIColor.red]
        }
        else if (Indicator == .TaxRevenue)
        {
            titles = ["Tax Revenue"]
            colors = [UIColor.red]
        }
        else if (Indicator == .MoneySupply)
        {
            titles = ["M0", "M2"]
            colors = [UIColor.green, UIColor.red]
        }
        else if (Indicator == .MinimumWage)
        {
            titles = ["Minimum Wage"]
            colors = [UIColor.red]
        }
        else if (Indicator == .OilPrices)
        {
            titles = ["WTI", "Brent", "Venezuela", "OPEC"]
            colors = [UIColor.orange, UIColor.blue, UIColor.green, UIColor.purple]
        }
        else if (Indicator == .CrudeProduction)
        {
            titles = ["Crude Production (million barrels/day)", "Crude Production (million barrels/day)"]
            colors = [UIColor.green, UIColor.red]
        }
        else if (Indicator == .USOil)
        {
            titles = ["US exports (million barrels/year)", "US imports (million barrels/year)"]
            colors = [UIColor.green, UIColor.red]
        }
        else if (Indicator == .TaxUnit)
        {
            titles = ["Tax Unit"]
            colors = [UIColor.red]
        }
        
        
        lineSeries.title = titles[index]
        lineSeries.style().lineColor = colors[index]
        
        return lineSeries
        
    }
    
    
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int
    {
        var counts : [Int]
        
        switch Indicator
        {
            case .FX:
                counts = [DataBM.count,DataOfficial.count,DataSimadi.count, DataDicom.count, DataM2_Res.count, DataSitme.count, DataSicad1.count, DataSicad2.count, DataSupp.count]
            case .Bitcoin:
                counts = [DataBitcoin.count]
            case .Reserves:
                counts = [DataReserves.count]
            case .Inflation:
                counts = [DataCEDICE.count, DataEcoanalitica.count, DataNA.count, DataBPP.count]
            case .TaxRevenue:
                counts = [DataTaxRev.count]
            case .MoneySupply:
                counts = [DataM0.count, DataM2.count]
            case .MinimumWage:
                counts = [DataDollarMinWage.count]
            case .OilPrices:
                counts = [DataWTI.count, DataBrent.count, DataVen.count, DataOPEC.count]
            case .CrudeProduction:
                counts = [DataDirect.count, DataSecondary.count]
            case .USOil:
                counts = [DataUSexports.count, DataUSimports.count]
            case .TaxUnit:
                counts = [DataTaxUnit.count]
            
        }
        
        return counts[seriesIndex]
        
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData
    {
        if (Indicator == .FX)
        {
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
            else
            {
                return DataSupp[dataIndex]
            }
        }
        else if (Indicator == .Bitcoin)
        {
            if seriesIndex == 0
            {
                return DataBitcoin[dataIndex]
            }
            else
            {
                return DataBitcoin[dataIndex]
            }
        }
        else if (Indicator == .Reserves)
        {
            if seriesIndex == 0
            {
                return DataReserves[dataIndex]
            }
            else
            {
                return DataReserves[dataIndex]
            }
        }
        else if (Indicator == .Inflation)
        {
            if seriesIndex == 0
            {
                return DataCEDICE[dataIndex]
            }
            if seriesIndex == 1
            {
                return DataEcoanalitica[dataIndex]
            }
            if seriesIndex == 2
            {
                return DataNA[dataIndex]
            }
            if seriesIndex == 3
            {
                return DataBPP[dataIndex]
            }
            else
            {
                return DataEcoanalitica[dataIndex]
            }
        }
        else if (Indicator == .TaxRevenue)
        {
            return DataTaxRev[dataIndex]
        }
        else if (Indicator == .MoneySupply)
        {
            if seriesIndex == 0
            {
                return DataM0[dataIndex]
            }
            if seriesIndex == 1
            {
                return DataM2[dataIndex]
            }
            else
            {
                return DataM0[dataIndex]
            }
        }
        else if (Indicator == .OilPrices)
        {
            if seriesIndex == 0
            {
                return DataWTI[dataIndex]
            }
            if seriesIndex == 1
            {
                return DataBrent[dataIndex]
            }
            if seriesIndex == 2
            {
                return DataVen[dataIndex]
            }
            if seriesIndex == 3
            {
                return DataOPEC[dataIndex]
            }
            else
            {
                return DataVen[dataIndex]
            }
        }
        else if (Indicator == .CrudeProduction)
        {
            if seriesIndex == 0
            {
                return DataDirect[dataIndex]
            }
            if seriesIndex == 1
            {
                return DataSecondary[dataIndex]
            }
            else
            {
                return DataDirect[dataIndex]
            }
        }
        else if (Indicator == .USOil)
        {
            if seriesIndex == 0
            {
                return DataUSexports[dataIndex]
            }
            if seriesIndex == 1
            {
                return DataUSimports[dataIndex]
            }
            else
            {
                return DataUSexports[dataIndex]
            }
        }
        else if (Indicator == .TaxUnit)
        {
            if seriesIndex == 0
            {
                return DataTaxUnit[dataIndex]
            }
            else
            {
                return DataTaxUnit[dataIndex]
            }
        }
        else if (Indicator == .MinimumWage)
        {
            return DataDollarMinWage[dataIndex]
        }
        else
        {
            return DataBitcoin[dataIndex]
        }
    }


    
    func ShowMenuTapped()
    {
        toggleSideMenuView()
    }

}
