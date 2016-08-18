//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

class InflationCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    let userCalendar = NSCalendar.currentCalendar()
    
    let currencies : [String: String] = ["GBP": "£", "USD": "$", "EUR": "€", "COP": "COL$", "VEF": "BsF"]
    
    //Variables to hold data
    var Inflation = [String: Double]()
    
    //Variables to hold chart data
    var DataInflation: [SChartDataPoint] = []
    
    
    //Layouts
    @IBOutlet var AllText: UIStackView!
    @IBOutlet var DistanceBetweenAllTextAndChartSV: NSLayoutConstraint!
    @IBOutlet var ChartSVHeight: NSLayoutConstraint!
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if (toInterfaceOrientation == .Portrait)
        {
            ChartSVHeight.active = false
            AllText.hidden = false
            Header.hidden = false
            DistanceBetweenAllTextAndChartSV.active = true
        }
        else
        {
            ChartSVHeight.active = true
            ChartSVHeight.constant = view.frame.width
            AllText.hidden = true
            Header.hidden = true
            DistanceBetweenAllTextAndChartSV.active = false
        }
    }
    
    //Layout stuff
    @IBOutlet var Header: UILabel!
    
    
    //Labels for main values
    @IBOutlet var AnnualInflationVal: UILabel!
    @IBOutlet var MonthlyInflationVal: UILabel!
    
    //Labels for variation text
    @IBOutlet var YearLabels: UILabel!
    

    
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
        var Start : String = "2007-01-01"
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
        
        ChartSVHeight.active = false

        
        //For menu
        self.sideMenuController()?.sideMenu?.delegate = self
        self.navigationController?.navigationBarHidden = true
        
        //Telling what units we're using. Hopefully will be able to shift all this later
        var units : String = self.currencies["VEF"]! + "/" + self.currencies["USD"]!
        
        //A number formatter
        let NumberFormatter = NSNumberFormatter()
        NumberFormatter.numberStyle = .DecimalStyle
        NumberFormatter.maximumFractionDigits = 2
        
        //Loading so everything hidden. I can't seem to add other stuff to this. Better way to hide/show everything?
        self.chart.hidden = true
        self.AnnualInflationVal.hidden = true
        self.MonthlyInflationVal.hidden =  true
        self.YearLabels.hidden = true
        self.RangeController.hidden = true
        self.Header.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //Added this bit with Pat on 20160804, to download the file
        let url = NSURL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_inf&format=json")!
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
                /*
                //Set all the text. There must be a way of doing this without using so many repetetive lines of code? I mean the attributed text rather than my if statements.
                var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + NumberFormatter.stringFromNumber(GetLatestNonZeroValue(self.Inflation, date: Today))! + " <font size=2>BsF/month</font></font>"
                var encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.AnnualInflationVal.attributedText = attributedString
                    
                } catch _ {}
                
                
                var comparison : Double = GetLatestNonZeroValue(self.Inflation, date: Yesterday)
                // Compare(self.Inflation, date: FiveYearsAgo, label: self.InflationFiveYear, type: nil)
                Compare(self.Inflation, date: OneMonthAgo, label: self.InflationMonth, type: nil)
                Compare(self.Inflation, date: OneYearAgo, label: self.InflationYear, type: nil)
                Compare(self.Inflation, date: TwoYearsAgo, label: self.InflationTwoYear, type: nil)
                Compare(self.Inflation, date: ThreeYearsAgo, label: self.InflationThreeYear, type: nil)
                Compare(self.Inflation, date: FourYearsAgo, label: self.InflationFourYear, type: nil)
                */
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
                yAxis.title = "Inflation (Jan 2007 = 1)"
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
                self.AnnualInflationVal.hidden = false
                self.MonthlyInflationVal.hidden =  false
                self.YearLabels.hidden = false
                self.RangeController.hidden = false
                self.Header.hidden = false
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
                InflationVal = dataPoint["inf"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected")
                    return
            }
            
            let date = dateFormatter.dateFromString(dateString)
            
            if (InflationVal != "0")
            {
                Inflation[dateString] = Double(InflationVal)! // Adds to my dictionary
                let DataPointInflation = SChartDataPoint() // Adds to graph data
                DataPointInflation.xValue = date
                DataPointInflation.yValue = Double(InflationVal)!/100
                DataInflation.append(DataPointInflation)
            }
            
            
        }
    }
    
    
    func numberOfSeriesInSChart(chart: ShinobiChart) -> Int {
        return 1
    }
    
    
    func sChart(chart: ShinobiChart, seriesAtIndex index: Int) -> SChartSeries {
        
        let lineSeries = SChartLineSeries()
        lineSeries.style().lineWidth = 2
        lineSeries.animationEnabled = false
        lineSeries.crosshairEnabled = true
        
        let titles : [String] = ["Inflation"]
        let colors : [UIColor] = [UIColor.redColor()]
        
        lineSeries.title = titles[index]
        lineSeries.style().lineColor = colors[index]
        
        
        return lineSeries
        
    }
    
    
    
    func sChart(chart: ShinobiChart, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        
        let counts : [Int] = [DataInflation.count]
        
        return counts[seriesIndex]
        
        /* if seriesIndex == 0
         {
         return DataInflation.count
         } etc */
        
    }
    
    func sChart(chart: ShinobiChart, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData {
        
        if seriesIndex == 0
        {
            return DataInflation[dataIndex]
        }
        else { return DataInflation[dataIndex] }
    }
    
    
}