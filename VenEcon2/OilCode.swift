//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

class OilCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
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
    
    //Layouts
    @IBOutlet var AllText: UIStackView!
    @IBOutlet var DistanceBetweenAllTextAndChartSV: NSLayoutConstraint!
    @IBOutlet var ChartSVHeight: NSLayoutConstraint!
    @IBOutlet var ChartSVToTop: NSLayoutConstraint!
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if (toInterfaceOrientation == .Portrait)
        {
            ChartSVHeight.active = false
            AllText.hidden = false
            Header.hidden = false
            DistanceBetweenAllTextAndChartSV.active = true
            ShowMenuButton.hidden = false
            ChartSVToTop.active = false
        }
        else
        {
            ChartSVHeight.active = true
            ChartSVHeight.constant = view.frame.width
            AllText.hidden = true
            Header.hidden = true
            DistanceBetweenAllTextAndChartSV.active = false
            ShowMenuButton.hidden = true
            ChartSVToTop.active = true
            ChartSVToTop.constant = 0
        }
    }
    
    //Labels for headers
    @IBOutlet var Header: UILabel!
    
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
        var Start : String = Utils.shared.YearsAgo(5)
        switch RangeController.selectedSegmentIndex
        {
        case 0:
            Start = Utils.shared.YearsAgo(16)
        case 1:
            Start = Utils.shared.YearsAgo(8)
        case 2:
            Start = Utils.shared.YearsAgo(4)
        case 3:
            Start = Utils.shared.YearsAgo(2)
        case 4:
            Start = Utils.shared.YearsAgo(1)
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
        
        //Layout
        ChartSVHeight.active = false
        ChartSVToTop.active = false

        
        //For menu
        self.sideMenuController()?.sideMenu?.delegate = self
        self.navigationController?.navigationBarHidden = true
        
        //Telling what units we're using. Hopefully will be able to shift all this later
        var units : String = Utils.shared.currencies["VEF"]! + "/" + Utils.shared.currencies["USD"]!
        
        //Loading so everything hidden. I can't seem to add other stuff to this. Better way to hide/show everything?
        self.Header.hidden = true
        self.AllText.hidden = true
        self.RangeController.hidden = true
        self.chart.hidden = true
        self.ShowMenuButton.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        //Added this bit with Pat on 20160804, to download the file
        let url = NSURL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_oil&format=json&start=2000-01-01")!
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
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.Data(json)
                
                //Set all the text.
                var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.CurrencyFormatter.stringFromNumber(Utils.shared.GetLatestNonZeroValue(self.WTI, date: Utils.shared.Today()))! + " <font size=2> / barrel</font></font>"
                var encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.WTIVal.attributedText = attributedString
                    
                } catch _ {}
                
                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.CurrencyFormatter.stringFromNumber(Utils.shared.GetLatestNonZeroValue(self.Brent, date: Utils.shared.Today()))! + " <font size=2> / barrel</font></font>"
                 encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                 attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.BrentVal.attributedText = attributedString
                    
                } catch _ {}
                
                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.CurrencyFormatter.stringFromNumber(Utils.shared.GetLatestNonZeroValue(self.Ven, date: Utils.shared.Today()))! + " <font size=2> / barrel</font></font>"
                encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.VenVal.attributedText = attributedString
                    
                } catch _ {}
                
                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.CurrencyFormatter.stringFromNumber(Utils.shared.GetLatestNonZeroValue(self.OPEC, date: Utils.shared.Today()))! + " <font size=2> / barrel</font></font>"
                encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.OPECVal.attributedText = attributedString
                    
                } catch _ {}
                
                Utils.shared.Compare(self.WTI, date: Utils.shared.OneWeekAgo(), label: self.WTIWeek, type: nil)
                Utils.shared.Compare(self.WTI, date: Utils.shared.YearsAgo(1), label: self.WTIYear, type: nil)
                Utils.shared.Compare(self.WTI, date: Utils.shared.YearsAgo(2), label: self.WTITwoYear, type: nil)
                
                Utils.shared.Compare(self.Brent, date: Utils.shared.OneWeekAgo(), label: self.BrentWeek, type: nil)
                Utils.shared.Compare(self.Brent, date: Utils.shared.YearsAgo(1), label: self.BrentYear, type: nil)
                Utils.shared.Compare(self.Brent, date: Utils.shared.YearsAgo(2), label: self.BrentTwoYear, type: nil)
                
                Utils.shared.Compare(self.Ven, date: Utils.shared.OneWeekAgo(), label: self.VenWeek, type: nil)
                Utils.shared.Compare(self.Ven, date: Utils.shared.YearsAgo(1), label: self.VenYear, type: nil)
                Utils.shared.Compare(self.Ven, date: Utils.shared.YearsAgo(2), label: self.VenTwoYear, type: nil)
                
                Utils.shared.Compare(self.OPEC, date: Utils.shared.OneWeekAgo(), label: self.OPECWeek, type: nil)
                Utils.shared.Compare(self.OPEC, date: Utils.shared.YearsAgo(1), label: self.OPECYear, type: nil)
                Utils.shared.Compare(self.OPEC, date: Utils.shared.YearsAgo(2), label: self.OPECTwoYear, type: nil)
                
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
                xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
                self.chart.xAxis = xAxis
                
                // Y Axis
                let yAxis = SChartNumberAxis()
                yAxis.title = "Oil Price ($/barrel)"
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
                self.Header.hidden = false
                self.AllText.hidden = false
                self.RangeController.hidden = false
                self.chart.hidden = false
                self.ShowMenuButton.hidden = false
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
            })
            
            
        }
        task.resume()
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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