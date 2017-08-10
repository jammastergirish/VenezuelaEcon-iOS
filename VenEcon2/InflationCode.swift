//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

class InflationCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    //Variables to hold data
    var CentralBank = [String: Double]()
    var Ecoanalitica = [String: Double]()
//    var Ven = [String: Double]()
//    var OPEC = [String: Double]()
    
    //Variables to hold chart data
    var DataCentralBank: [SChartDataPoint] = []
    var DataEcoanalitica: [SChartDataPoint] = []
//    var DataVen: [SChartDataPoint] = []
//    var DataOPEC: [SChartDataPoint] = []
    
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
            ChartSVToTop.isActive = false
        }
        else
        {
            ChartSVHeight.isActive = true
            ChartSVHeight.constant = view.frame.width
            AllText.isHidden = true
            Header.isHidden = true
            DistanceBetweenAllTextAndChartSV.isActive = false
            ShowMenuButton.isHidden = true
            ChartSVToTop.isActive = true
            ChartSVToTop.constant = 0
        }
    }
    
    //Labels for headers
    @IBOutlet var Header: UILabel!
    
    //Labels for main values
    @IBOutlet var CentralBankVal: UILabel!
    @IBOutlet var EcoanaliticaVal: UILabel!
    @IBOutlet var CENDASVal: UILabel!
//    @IBOutlet var OPECVal: UILabel!
    
    //Labels for variation text //Sort these later
    @IBOutlet var CentralBankDate: UILabel!
    @IBOutlet var EcoDate: UILabel!
    @IBOutlet var CENDASDate: UILabel!
//    @IBOutlet var EcoanaliticaWeek: UILabel!
//    @IBOutlet var EcoanaliticaYear: UILabel!
//    @IBOutlet var EcoanaliticaTwoYear: UILabel!
//    @IBOutlet var VenWeek: UILabel!
//    @IBOutlet var VenYear: UILabel!
//    @IBOutlet var VenTwoYear: UILabel!
//    @IBOutlet var OPECWeek: UILabel!
//    @IBOutlet var OPECYear: UILabel!
//    @IBOutlet var OPECTwoYear: UILabel!
    
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
        var Start : String = Utils.shared.YearsAgo(10)
        switch RangeController.selectedSegmentIndex
        {
        case 0:
            Start = Utils.shared.YearsAgo(10)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 1:
            Start = Utils.shared.YearsAgo(8)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 2:
            Start = Utils.shared.YearsAgo(6)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 3:
            Start = Utils.shared.YearsAgo(4)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
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
        
        //Layout
        ChartSVHeight.isActive = false
        ChartSVToTop.isActive = false
        
        
        //For menu
        self.sideMenuController()?.sideMenu?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        
        //Telling what units we're using. Hopefully will be able to shift all this later
        //var units : String = Utils.shared.currencies["VEF"]! + "/" + Utils.shared.currencies["USD"]!
        
        //Loading so everything hidden. I can't seem to add other stuff to this. Better way to hide/show everything?
        self.Header.isHidden = true
        self.AllText.isHidden = true
        self.RangeController.isHidden = true
        self.chart.isHidden = true
        self.ShowMenuButton.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //Very nice addition on 20160823!
        //loadLocalChartData()
        
        //Added this bit with Pat on 20160804, to download the file
        let url = URL(string: "https://api.venezuelaecon.com/output.php?table=ve_inf2&format=json")!
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
                
                //Set all the text.
                var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.CentralBank, date: Utils.shared.Today()))! + " <font size=2> %</font></font>"
                var encodedData = text.data(using: String.Encoding.utf8)!
                var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.CentralBankVal.attributedText = attributedString
                    
                } catch _ {}
                
                
                
                self.CentralBankDate.text = Utils.shared.dateFormatterText.string(from: Utils.shared.dateFormatter.date(from:Utils.shared.GetLatestNonZeroKey(self.CentralBank, date: Utils.shared.Today())[0])!)
                
                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Ecoanalitica, date: Utils.shared.Today()))! + " <font size=2> %</font></font>"
                encodedData = text.data(using: String.Encoding.utf8)!
                attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.EcoanaliticaVal.attributedText = attributedString
                    
                } catch _ {}
                
                
                self.EcoDate.text = Utils.shared.dateFormatterText.string(from: Utils.shared.dateFormatter.date(from:Utils.shared.GetLatestNonZeroKey(self.Ecoanalitica, date: Utils.shared.Today())[0])!)
                
//                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>$" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Ven, date: Utils.shared.Today()))! + " <font size=2> / "+NSLocalizedString("barrel", comment: "")+"</font></font>"
//                encodedData = text.data(using: String.Encoding.utf8)!
//                attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
//                do {
//                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
//                    self.VenVal.attributedText = attributedString
//                    
//                } catch _ {}
//                
//                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>$" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.OPEC, date: Utils.shared.Today()))! + " <font size=2> / "+NSLocalizedString("barrel", comment: "")+"</font></font>"
//                encodedData = text.data(using: String.Encoding.utf8)!
//                attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
//                do {
//                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
//                    self.OPECVal.attributedText = attributedString
//                    
//                } catch _ {}
                
//                Utils.shared.Compare(self.CentralBank, date: Utils.shared.OneMonthAgo(), label: self.CentralBankWeek, type: nil)
//                Utils.shared.Compare(self.CentralBank, date: Utils.shared.YearsAgo(1), label: self.CentralBankYear, type: nil)
//                Utils.shared.Compare(self.CentralBank, date: Utils.shared.YearsAgo(2), label: self.CentralBankTwoYear, type: nil)
//                
//                Utils.shared.Compare(self.Ecoanalitica, date: Utils.shared.OneMonthAgo(), label: self.EcoanaliticaWeek, type: nil)
//                Utils.shared.Compare(self.Ecoanalitica, date: Utils.shared.YearsAgo(1), label: self.EcoanaliticaYear, type: nil)
//                Utils.shared.Compare(self.Ecoanalitica, date: Utils.shared.YearsAgo(2), label: self.EcoanaliticaTwoYear, type: nil)
//                
//                Utils.shared.Compare(self.Ven, date: Utils.shared.OneMonthAgo(), label: self.VenWeek, type: nil)
//                Utils.shared.Compare(self.Ven, date: Utils.shared.YearsAgo(1), label: self.VenYear, type: nil)
//                Utils.shared.Compare(self.Ven, date: Utils.shared.YearsAgo(2), label: self.VenTwoYear, type: nil)
//                
//                Utils.shared.Compare(self.OPEC, date: Utils.shared.OneMonthAgo(), label: self.OPECWeek, type: nil)
//                Utils.shared.Compare(self.OPEC, date: Utils.shared.YearsAgo(1), label: self.OPECYear, type: nil)
//                Utils.shared.Compare(self.OPEC, date: Utils.shared.YearsAgo(2), label: self.OPECTwoYear, type: nil)
                
                //DRAW THE GRAPHS
                self.chart.canvasAreaBackgroundColor = UIColor.black
                self.chart.backgroundColor = UIColor.black
                self.chart.canvas.backgroundColor = UIColor.blue
                self.chart.plotAreaBackgroundColor = UIColor.black
                
                self.chart.legend.placement = .outsidePlotArea
                self.chart.legend.position = .bottomMiddle
                self.chart.legend.style.areaColor = UIColor.black
                self.chart.legend.style.fontColor = UIColor.white
                self.chart.legend.isHidden = true
                
                self.chart.crosshair?.style.lineColor = UIColor.white
                self.chart.crosshair?.style.lineWidth = 1
                
                // Axes
                self.xAxis.title = NSLocalizedString("Date", comment: "")
                self.yAxis.title = ""+NSLocalizedString("Annual Inflation", comment: "")+" (%)"
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
                self.xAxis.style.lineWidth = 2
                self.yAxis.style.lineWidth = 2
                self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: self.Ecoanalitica.values.max()! as NSNumber!)
                
                self.chart.xAxis = self.xAxis
                self.chart.yAxis = self.yAxis
                
                self.chart.clipsToBounds = false
                
                self.chart.datasource = self
                self.chart.positionLegend()
                
                //All set to make everything visible again!
                self.Header.isHidden = false
                self.AllText.isHidden = false
                self.RangeController.isHidden = false
                self.chart.isHidden = false
                self.ShowMenuButton.isHidden = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.RangeControl(0 as AnyObject)
                
            })
            
            
        })
        task.resume()
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
    
    func enablePanningAndZoomingOnAxis(_ axis: SChartAxis) {
        axis.enableGesturePanning = true
        axis.enableGestureZooming = true
    }
    
    
    //LOCAL LOADING
    func loadLocalChartData() {
        
        for dataPoint in Utils.shared.JSONDataFromFile("InflationData") {
            
            guard let
                dateString = dataPoint["date"] as? String,
                let CentralBankVal = dataPoint["annual"] as? String,
                let EcoanaliticaVal = dataPoint["eco"] as? String //,
//                let VenVal = dataPoint["ven"] as? String,
//                let OPECVal = dataPoint["opec"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected")
                    return
            }
            
            let date = dateFormatter.date(from: dateString)
            
            if (CentralBankVal != "0")
            {
                CentralBank[dateString] = Double(CentralBankVal) // Adds to my dictionary
                let DataPointCentralBank = SChartDataPoint() // Adds to graph data
                DataPointCentralBank.xValue = date
                DataPointCentralBank.yValue = Double(CentralBankVal)
                DataCentralBank.append(DataPointCentralBank)
            }
            
            if (EcoanaliticaVal != "0")
            {
                Ecoanalitica[dateString] = Double(EcoanaliticaVal)
                let DataPointEcoanalitica = SChartDataPoint()
                DataPointEcoanalitica.xValue = date
                DataPointEcoanalitica.yValue = Double(EcoanaliticaVal)
                DataEcoanalitica.append(DataPointEcoanalitica)
            }
            
//            if (VenVal != "0")
//            {
//                Ven[dateString] = Double(VenVal)
//                let DataPointVen = SChartDataPoint()
//                DataPointVen.xValue = date
//                DataPointVen.yValue = Double(VenVal)
//                DataVen.append(DataPointVen)
//            }
//            
//            if (OPECVal != "0")
//            {
//                OPEC[dateString] = Double(OPECVal)
//                let DataPointOPEC = SChartDataPoint()
//                DataPointOPEC.xValue = date
//                DataPointOPEC.yValue = Double(OPECVal)
//                DataOPEC.append(DataPointOPEC)
//            }
            
        }
        
        
    }
    
    
    
    
    func Data(_ json : [[String : AnyObject]]) {
        
        // for dataPoint in JSONDatac.f.File("ve_fx") {
        for dataPoint in json {
            
            guard let
                dateString = dataPoint["date"] as? String,
                let CentralBankVal = dataPoint["annual"] as? String,
                let EcoanaliticaVal = dataPoint["eco"] as? String //,
//                let VenVal = dataPoint["ven"] as? String,
//                let OPECVal = dataPoint["opec"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected")
                    return
            }
            
            let date = dateFormatter.date(from: dateString)
            
            if (CentralBankVal != "0")
            {
                CentralBank[dateString] = Double(CentralBankVal) // Adds to my dictionary
                let DataPointCentralBank = SChartDataPoint() // Adds to graph data
                DataPointCentralBank.xValue = date
                DataPointCentralBank.yValue = Double(CentralBankVal)
                DataCentralBank.append(DataPointCentralBank)
            }
            
            if (EcoanaliticaVal != "0")
            {
                Ecoanalitica[dateString] = Double(EcoanaliticaVal)
                let DataPointEcoanalitica = SChartDataPoint()
                DataPointEcoanalitica.xValue = date
                DataPointEcoanalitica.yValue = Double(EcoanaliticaVal)
                DataEcoanalitica.append(DataPointEcoanalitica)
            }
            
//            if (VenVal != "0")
//            {
//                Ven[dateString] = Double(VenVal)
//                let DataPointVen = SChartDataPoint()
//                DataPointVen.xValue = date
//                DataPointVen.yValue = Double(VenVal)
//                DataVen.append(DataPointVen)
//            }
//            
//            if (OPECVal != "0")
//            {
//                OPEC[dateString] = Double(OPECVal)
//                let DataPointOPEC = SChartDataPoint()
//                DataPointOPEC.xValue = date
//                DataPointOPEC.yValue = Double(OPECVal)
//                DataOPEC.append(DataPointOPEC)
//            }
            
        }
    }
    
    
    func numberOfSeries(inSChart chart: ShinobiChart) -> Int {
        return 2
    }
    
    
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        
        let lineSeries = SChartLineSeries()
        lineSeries.style().lineWidth = 2
        lineSeries.animationEnabled = false
        lineSeries.crosshairEnabled = true
        
        let titles : [String] = ["CentralBank", "Ecoanalitica", "Venezuela", "OPEC"]
        let colors : [UIColor] = [UIColor.orange, UIColor.green, UIColor.blue, UIColor.purple]
        
        lineSeries.title = titles[index]
        lineSeries.style().lineColor = colors[index]
        
        return lineSeries
        
    }
    
    
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        
        let counts : [Int] = [DataCentralBank.count,DataEcoanalitica.count/*,DataVen.count, DataOPEC.count*/]
        
        return counts[seriesIndex]
        
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        
        if seriesIndex == 0
        {
            return DataCentralBank[dataIndex]
        }
        if seriesIndex == 1
        {
            return DataEcoanalitica[dataIndex]
        }
//        if seriesIndex == 2
//        {
//            return DataVen[dataIndex]
//        }
//        if seriesIndex == 3
//        {
//            return DataOPEC[dataIndex]
//        }
        else { return DataEcoanalitica[dataIndex] }
    }
    
    
}
