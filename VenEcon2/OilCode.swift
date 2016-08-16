//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

class OilCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    let userCalendar = NSCalendar.currentCalendar()
    
    let currencies : [String: String] = ["GBP": "£", "USD": "$", "EUR": "€", "COP": "COL$", "VEF": "BsF"]
    
    //Variables to hold data
    var WTI = [String: Double]()
    var Brent = [String: Double]()
    var Ven = [String: Double]()
    var OPEC = [String: Double]()
    
    //Variables to hold chart data
    var DataWTI: [SChartDataPoint] = []
    var DataBrent: [SChartDataPoint] = []
    var DataVen: [SChartDataPoint] = []
    var DataOPEC: [SChartDataPoint] = []
    
    //Labels for headers
    @IBOutlet var Header: UILabel!
    @IBOutlet var WTILabel: UILabel!
    @IBOutlet var BrentLabel: UILabel!
    @IBOutlet var VenLabel: UILabel!
    @IBOutlet var OPECLabel: UILabel!
    
    //Labels for main values
    @IBOutlet var WTIVal: UILabel!
    @IBOutlet var BrentVal: UILabel!
    @IBOutlet var VenVal: UILabel!
    @IBOutlet var OPECVal: UILabel!
    
    //Labels for variation text //Sort these later
    @IBOutlet var WTIWeek: UILabel!
    @IBOutlet var WTIYear: UILabel!
    @IBOutlet var WTITwoYear: UILabel!
    @IBOutlet var BrentWeek: UILabel!
    @IBOutlet var BrentYear: UILabel!
    @IBOutlet var BrentTwoYear: UILabel!
    @IBOutlet var VenWeek: UILabel!
    @IBOutlet var VenYear: UILabel!
    @IBOutlet var VenTwoYear: UILabel!
    @IBOutlet var OPECWeek: UILabel!
    @IBOutlet var OPECYear: UILabel!
    @IBOutlet var OPECTwoYear: UILabel!

    
    //Chart
    @IBOutlet var chart: ShinobiChart!
    
    //DateFormatter for data for chart. Not sure why in this format with "required init..."
    let dateFormatter = NSDateFormatter()
    required init?(coder aDecoder: NSCoder) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        super.init(coder: aDecoder)
    }
    
    //Range Controller and Range Control functions
    @IBOutlet var RangeController: UISegmentedControl!
    @IBAction func RangeControl(sender: AnyObject) {
        var Start : String = "2011-08-15"
        switch RangeController.selectedSegmentIndex
        {
        case 0:
            Start = "2011-08-15" // If those date definitions below were higher, I could use them here instead of typing manually or copying and pasting from below which obviously isn't okay.
        case 1:
            Start = "2012-08-15"
        case 2:
            Start = "2013-08-15"
        case 3:
            Start = "2014-08-15"
        case 4:
            Start = "2015-08-15"
        default:
            break;
        }
        
        let startDate = dateFormatter.dateFromString(Start)
        let endDate = NSDate()
        
        chart.xAxis!.defaultRange = SChartDateRange(dateMinimum: startDate, andDateMaximum: endDate)
        
        chart.reloadData()
        chart.redrawChart()
    }
    
    //Internet download session
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //For menu
        self.sideMenuController()?.sideMenu?.delegate = self
        self.navigationController?.navigationBarHidden = true
        
        //Telling what units we're using. Hopefully will be able to shift all this later
        var units : String = self.currencies["VEF"]! + "/" + self.currencies["USD"]!
        
        //Definitions for time. These should ideally be far out of this function. Why can't I put these higher?
        let Today = self.dateFormatter.stringFromDate(NSDate())
        let Yesterday = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -1, toDate: NSDate(), options: [])!)
        let OneWeekAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -7, toDate: NSDate(), options: [])!)
        let FirstOfThisMonth = ""
        let OneMonthAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -30, toDate: NSDate(), options: [])!)
        let FirstOfThisYear = ""
        let OneYearAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -365, toDate: NSDate(), options: [])!)
        let TwoYearsAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -(365*2), toDate: NSDate(), options: [])!)
        let ThreeYearsAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -(365*3), toDate: NSDate(), options: [])!)
        let FourYearsAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -(365*4), toDate: NSDate(), options: [])!)
        let FiveYearsAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -(365*5), toDate: NSDate(), options: [])!)
        
        //A number formatter
        let NumberFormatter = NSNumberFormatter()
        NumberFormatter.numberStyle = .DecimalStyle
        NumberFormatter.maximumFractionDigits = 2
        
        //Loading so everything hidden. I can't seem to add other stuff to this. Better way to hide/show everything?
        self.chart.hidden = true
        self.Header.hidden = true
        self.WTIVal.hidden = true
        self.VenVal.hidden = true
        self.BrentVal.hidden = true
        self.OPECVal.hidden = true
        self.RangeController.hidden = true
        self.WTIWeek.hidden = true
        self.WTIYear.hidden = true
        self.WTITwoYear.hidden = true
        self.BrentWeek.hidden = true
        self.BrentYear.hidden = true
        self.BrentTwoYear.hidden = true
        self.VenWeek.hidden = true
        self.VenYear.hidden = true
        self.VenTwoYear.hidden = true
        self.OPECWeek.hidden = true
        self.OPECYear.hidden = true
        self.OPECTwoYear.hidden = true
        self.WTILabel.hidden = true
        self.VenLabel.hidden = true
        self.OPECLabel.hidden = true
        self.BrentLabel.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        //Added this bit with Pat on 20160804, to download the file
        let url = NSURL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_oil&format=json&start=2011-01-01")!
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
                
                //Set all the text. There must be a way of doing this without using so many repetetive lines of code? I mean the attributed text rather than my if statements.
                var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>$" + NumberFormatter.stringFromNumber(GetLatestNonZeroValue(self.WTI, date: Today))! + " <font size=2> per barrel</font></font>"
                var encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.WTIVal.attributedText = attributedString
                    
                } catch _ {}
                
                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>$" + NumberFormatter.stringFromNumber(GetLatestNonZeroValue(self.Brent, date: Today))! + " <font size=2> per barrel</font></font>"
                 encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                 attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.BrentVal.attributedText = attributedString
                    
                } catch _ {}
                
                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>$" + NumberFormatter.stringFromNumber(GetLatestNonZeroValue(self.Ven, date: Today))! + " <font size=2> per barrel</font></font>"
                encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.VenVal.attributedText = attributedString
                    
                } catch _ {}
                
                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>$" + NumberFormatter.stringFromNumber(GetLatestNonZeroValue(self.OPEC, date: Today))! + " <font size=2> per barrel</font></font>"
                encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.OPECVal.attributedText = attributedString
                    
                } catch _ {}
                
                Compare(self.WTI, date: OneWeekAgo, label: self.WTIWeek, type: nil)
                Compare(self.WTI, date: OneYearAgo, label: self.WTIYear, type: nil)
                Compare(self.WTI, date: TwoYearsAgo, label: self.WTITwoYear, type: nil)
                
                Compare(self.Brent, date: OneWeekAgo, label: self.BrentWeek, type: nil)
                Compare(self.Brent, date: OneYearAgo, label: self.BrentYear, type: nil)
                Compare(self.Brent, date: TwoYearsAgo, label: self.BrentTwoYear, type: nil)
                
                Compare(self.Ven, date: OneWeekAgo, label: self.VenWeek, type: nil)
                Compare(self.Ven, date: OneYearAgo, label: self.VenYear, type: nil)
                Compare(self.Ven, date: TwoYearsAgo, label: self.VenTwoYear, type: nil)
                
                Compare(self.OPEC, date: OneWeekAgo, label: self.OPECWeek, type: nil)
                Compare(self.OPEC, date: OneYearAgo, label: self.OPECYear, type: nil)
                Compare(self.OPEC, date: TwoYearsAgo, label: self.OPECTwoYear, type: nil)
                
                //DRAW THE GRAPHS
                self.chart.canvasAreaBackgroundColor = UIColor.blackColor()
                self.chart.backgroundColor = UIColor.blackColor()
                self.chart.canvas.backgroundColor = UIColor.blueColor()
                self.chart.plotAreaBackgroundColor = UIColor.blackColor()
                
                self.chart.legend.placement = .OutsidePlotArea
                self.chart.legend.position = .BottomMiddle
                self.chart.legend.style.areaColor = UIColor.blackColor()
                self.chart.legend.style.fontColor = UIColor.whiteColor()
                self.chart.legend.hidden = true
                
                self.chart.crosshair?.style.lineColor = UIColor.whiteColor()
                self.chart.crosshair?.style.lineWidth = 1
                
                // X Axis
                let xAxis = SChartDiscontinuousDateTimeAxis()
                xAxis.title = "Date"
                self.enablePanningAndZoomingOnAxis(xAxis)
                xAxis.style.lineColor = UIColor.whiteColor()
                xAxis.style.titleStyle.textColor = UIColor.whiteColor()
                //xAxis.labelFormatter!.dateFormatter().dateStyle = .MediumStyle
                xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM, YYYY"
                self.chart.xAxis = xAxis
                
                // Y Axis
                let yAxis = SChartNumberAxis()
                yAxis.title = "Oil Price ($ per barrel)"
                self.enablePanningAndZoomingOnAxis(yAxis)
                yAxis.rangePaddingLow = 1
                yAxis.rangePaddingHigh = 1
                yAxis.style.lineColor = UIColor.whiteColor()
                yAxis.style.titleStyle.textColor = UIColor.whiteColor()
                xAxis.style.majorGridLineStyle.lineWidth = 1
                xAxis.style.majorGridLineStyle.lineColor = UIColor.darkGrayColor()
                xAxis.style.majorGridLineStyle.showMajorGridLines = true
                yAxis.style.majorGridLineStyle.lineWidth = 1
                yAxis.style.majorGridLineStyle.lineColor = UIColor.darkGrayColor()
                yAxis.style.majorGridLineStyle.showMajorGridLines = true
                self.chart.yAxis = yAxis
                
                self.chart.datasource = self
                self.chart.positionLegend()
                
                
                //All set to make everything visible again!
                self.chart.hidden = false
                self.Header.hidden = false
                self.WTIVal.hidden = false
                self.VenVal.hidden = false
                self.BrentVal.hidden = false
                self.OPECVal.hidden = false
                self.RangeController.hidden = false
                self.WTIWeek.hidden = false
                self.WTIYear.hidden = false
                self.WTITwoYear.hidden = false
                self.BrentWeek.hidden = false
                self.BrentYear.hidden = false
                self.BrentTwoYear.hidden = false
                self.VenWeek.hidden = false
                self.VenYear.hidden = false
                self.VenTwoYear.hidden = false
                self.OPECWeek.hidden = false
                self.OPECYear.hidden = false
                self.OPECTwoYear.hidden = false
                self.WTILabel.hidden = false
                self.VenLabel.hidden = false
                self.OPECLabel.hidden = false
                self.BrentLabel.hidden = false
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //self.RangeControl(4)
                
                
            })
            
            
        }
        task.resume()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*@IBAction func ButtonPress(sender: AnyObject) {
     toggleSideMenuView()
     }*/
    
    
    
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
    
    
    
    
    func enablePanningAndZoomingOnAxis(axis: SChartAxis) {
        axis.enableGesturePanning = true
        axis.enableGestureZooming = true
    }
    
    
    
    func Data(json : [[String : AnyObject]]) {
        
        // for dataPoint in JSONDatac.f.File("ve_fx") {
        for dataPoint in json {
            
            guard let
                dateString = dataPoint["date"] as? String,
                WTIVal = dataPoint["wti"] as? String,
                BrentVal = dataPoint["brent"] as? String,
                VenVal = dataPoint["ven"] as? String,
                OPECVal = dataPoint["opec"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected")
                    return
            }
            
            let date = dateFormatter.dateFromString(dateString)
            
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
    }
    
    
    func numberOfSeriesInSChart(chart: ShinobiChart) -> Int {
        return 4
    }
    
    
    func sChart(chart: ShinobiChart, seriesAtIndex index: Int) -> SChartSeries {
        
        let lineSeries = SChartLineSeries()
        lineSeries.style().lineWidth = 1
        lineSeries.animationEnabled = false
        lineSeries.crosshairEnabled = true
        
        let titles : [String] = ["WTI", "Brent", "Venezuela", "OPEC"]
        let colors : [UIColor] = [UIColor.blueColor(), UIColor.purpleColor(), UIColor.redColor(), UIColor.greenColor()]
        
        lineSeries.title = titles[index]
        lineSeries.style().lineColor = colors[index]
        
        
        return lineSeries
        
    }
    
    
    
    func sChart(chart: ShinobiChart, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        
        let counts : [Int] = [DataWTI.count,DataBrent.count,DataVen.count, DataOPEC.count]
        
        return counts[seriesIndex]
        
    }
    
    func sChart(chart: ShinobiChart, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData {
        
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
        else { return DataVen[dataIndex] }
    }
    
    
}