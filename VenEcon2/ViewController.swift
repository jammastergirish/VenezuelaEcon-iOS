//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

class FXCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    
    let userCalendar = NSCalendar.currentCalendar()
    
    let currencies : [String: String] = ["GBP": "£", "USD": "$", "EUR": "€", "COP": "COL$", "VEF": "BsF"]
    
    var BM = [String: Double]()
    var Official = [String: Double]()
    var Simadi = [String: Double]()
    var M2_Res = [String: Double]()
    
    var DataBM: [SChartDataPoint] = []
    var DataOfficial: [SChartDataPoint] = []
    var DataSimadi: [SChartDataPoint] = []
    var DataM2_Res: [SChartDataPoint] = []
    
    @IBOutlet var SIMADIVal: UILabel!
    @IBOutlet var DIPROVal: UILabel!
    @IBOutlet var M2_ResVal: UILabel!
    @IBOutlet var BlackMarketVal: UILabel!
    
    
    @IBOutlet var chart: ShinobiChart!
    
    
    let dateFormatter = NSDateFormatter()
    required init?(coder aDecoder: NSCoder) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var RangeController: UISegmentedControl!
    @IBAction func RangeControl(sender: AnyObject) {
        var Start : String = "2015-08-07"
        switch RangeController.selectedSegmentIndex
        {
        case 0:
            Start = "2012-08-09"
        case 1:
            Start = "2013-08-09"
        case 2:
            Start = "2014-08-09"
        case 3:
            Start = "2015-08-09"
        default:
            break;
        }
        
        let startDate = dateFormatter.dateFromString(Start)
        let endDate = NSDate()
        
        chart.xAxis!.defaultRange = SChartDateRange(dateMinimum: startDate, andDateMaximum: endDate)
        
        chart.reloadData()
        chart.redrawChart()
    }
    
    
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuController()?.sideMenu?.delegate = self
        
        self.navigationController?.navigationBarHidden = true
        
        //Why does this have to be here?
            var units : String = self.currencies["VEF"]! + "/" + self.currencies["USD"]!
        
        
        
        self.chart.hidden = true
        
        //Added this bit with Pat on 20160804, to download the file from server
        let url = NSURL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_fx&format=json&start=2012-01-01")!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            guard let data = data where error == nil else {
                print("Didn't download properly") // stick in an alert or whatever here for failed download
                return
            }
            
            guard let optionalJSON = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]],
                json = optionalJSON else
            {
                print("Did download but the data doesn't look like JSON")
                return // stick in an alert or whatever here for corrupt data
            }
            print("Got here")
            self.Data(json)
            print("Got here too")
            
            

            
            //Some definitions which ideally I'd want to get higher up. Why do they need to be here?
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
            //self.BM[OneWeekAgo]! is how you get a value back in time/today
            

            //Again, be nice to put this higher.
            let NumberFormatter = NSNumberFormatter()
            NumberFormatter.numberStyle = .DecimalStyle
            NumberFormatter.maximumFractionDigits = 2
            
            print(NumberFormatter.stringFromNumber(self.BM[Today]!)!)
            //For some reason, this next block of code takes forever to run, whereas the test line above works as expected.
            var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + NumberFormatter.stringFromNumber(self.BM[Today]!)! + " <font size=2>BsF/$</font></font>"
            var encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
            var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.BlackMarketVal.attributedText = attributedString
                
            } catch _ {}
            
            

            
            
            //Moved this up as was drawing graph before it had the data
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
            yAxis.title = "Exchange rate (" + units + ")"
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
            
            self.chart.hidden = false
            self.RangeControl(3)
            
   
            
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
    
    // for dataPoint in JSONDataFromFile("ve_fx") {
    for dataPoint in json {
        
        
        guard let
            dateString = dataPoint["date"] as? String,
            OfficialVal = dataPoint["official"] as? String,
            BMVal = dataPoint["bm"] as? String,
            SimadiVal = dataPoint["simadi"] as? String,
            M2_ResVal = dataPoint["m2_res"] as? String
            else {
                print("Data is JSON but not the JSON variables expected")
                return
        }
        
        let date = dateFormatter.dateFromString(dateString)
        
        
        if (BMVal != "0")
        {
        BM[dateString] = Double(BMVal) // Adds to my dictionary
        let DataPointBM = SChartDataPoint() // Adds to graph data
        DataPointBM.xValue = date
        DataPointBM.yValue = Double(BMVal)
        DataBM.append(DataPointBM)
        }
        
        if (OfficialVal != "0")
        {
        Official[dateString] = Double(OfficialVal)
        let DataPointOfficial = SChartDataPoint()
        DataPointOfficial.xValue = date
        DataPointOfficial.yValue = Double(OfficialVal)
        DataOfficial.append(DataPointOfficial)
        }
        
        if (SimadiVal != "0")
        {
        Simadi[dateString] = Double(SimadiVal)
        let DataPointSimadi = SChartDataPoint()
        DataPointSimadi.xValue = date
        DataPointSimadi.yValue = Double(SimadiVal)
        DataSimadi.append(DataPointSimadi)
        }
        
        if (M2_ResVal != "0")
        {
        M2_Res[dateString] = Double(M2_ResVal)
        let DataPointM2_Res = SChartDataPoint()
        DataPointM2_Res.xValue = date
        DataPointM2_Res.yValue = Double(M2_ResVal)
        DataM2_Res.append(DataPointM2_Res)
        }
        
    }
}



func numberOfSeriesInSChart(chart: ShinobiChart) -> Int {
    return 4
}

func sChart(chart: ShinobiChart, seriesAtIndex index: Int) -> SChartSeries {
    
    
    let lineSeries = SChartLineSeries()
    lineSeries.style().lineWidth = 2
    lineSeries.animationEnabled = false
    lineSeries.crosshairEnabled = true
    
    if index == 0 {
        lineSeries.title = "BM"
        lineSeries.style().lineColor = UIColor.redColor()
        
    }
    if index == 1 {
        lineSeries.title = "Official"
        lineSeries.style().lineColor = UIColor.greenColor()
    }
    if index == 2 {
        lineSeries.title = "Simadi"
        lineSeries.style().lineColor = UIColor.orangeColor()
    }
    if index == 3 {
        lineSeries.title = "M2/Reserves"
        lineSeries.style().lineColor = UIColor.whiteColor()
    }
    
    
    return lineSeries
    
}

func sChart(chart: ShinobiChart, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
    
    if seriesIndex == 0
    {
        return DataBM.count
    }
    if seriesIndex == 1
    {
        return DataOfficial.count
    }
    if seriesIndex == 2
    {
        return DataSimadi.count
    }
    if seriesIndex == 3
    {
        return DataM2_Res.count
    }
    else { return 0 }
}

func sChart(chart: ShinobiChart, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData {
    
    
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
        return DataM2_Res[dataIndex]
    }
    else { return DataM2_Res[dataIndex] }
}





}
