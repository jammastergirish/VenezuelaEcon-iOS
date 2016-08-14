//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

class ReservesCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    let userCalendar = NSCalendar.currentCalendar()
    
    let currencies : [String: String] = ["GBP": "£", "USD": "$", "EUR": "€", "COP": "COL$", "VEF": "BsF"]
    
    //Variables to hold data
    var Reserves = [String: Double]()
    
    //Variables to hold chart data
    var DataReserves: [SChartDataPoint] = []
    
    //Labels for main values
    @IBOutlet var ReservesVal: UILabel!
    
    //Labels for variation text
    @IBOutlet var ReservesYesterday: UILabel!
    @IBOutlet var ReservesMonth: UILabel!
    @IBOutlet var ReservesYear: UILabel!
    @IBOutlet var ReservesTwoYear: UILabel!
    @IBOutlet var ReservesThreeYear: UILabel!
    @IBOutlet var ReservesFourYear: UILabel!
    
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
        
        //Added this bit with Pat on 20160804, to download the file
        let url = NSURL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_res&format=json&start=2011-01-01")!
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
                var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>$" + NumberFormatter.stringFromNumber(self.Reserves[Today]!/1000)! + " <font size=2>billion</font></font>"
                var encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.ReservesVal.attributedText = attributedString
                    
                } catch _ {}
                

                
                if (self.Reserves[Today]!==self.Reserves[Yesterday]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080>Same as yesterday</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesYesterday.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!>self.Reserves[Yesterday]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[Yesterday]!, new: self.Reserves[Today]!)))! + "% in a day</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesYesterday.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!<self.Reserves[Yesterday]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[Yesterday]!, new: self.Reserves[Today]!)))! + "% in a day</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesYesterday.attributedText = attributedString
                        
                    } catch _ {}
                }
                
                if (self.Reserves[Today]!==self.Reserves[OneMonthAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080>Same as a month ago</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesFourYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!>self.Reserves[OneMonthAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[OneMonthAgo]!, new: self.Reserves[Today]!)))! + "% in a month</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesMonth.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!<self.Reserves[OneMonthAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[OneMonthAgo]!, new: self.Reserves[Today]!)))! + "% in a month</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesMonth.attributedText = attributedString
                        
                    } catch _ {}
                }
                
                if (self.Reserves[Today]!==self.Reserves[OneYearAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080>Same as a year ago</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesTwoYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!>self.Reserves[OneYearAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[OneYearAgo]!, new: self.Reserves[Today]!)))! + "% in a year</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!<self.Reserves[OneYearAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[OneYearAgo]!, new: self.Reserves[Today]!)))! + "% in a year</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                
                if (self.Reserves[Today]!==self.Reserves[TwoYearsAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080>Same as 2 years ago</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesTwoYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!>self.Reserves[TwoYearsAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[TwoYearsAgo]!, new: self.Reserves[Today]!)))! + "% in 2 years</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesTwoYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!<self.Reserves[TwoYearsAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[TwoYearsAgo]!, new: self.Reserves[Today]!)))! + "% in 2 years</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesTwoYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                
                if (self.Reserves[Today]!==self.Reserves[ThreeYearsAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080>Same as 3 years ago</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesThreeYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!>self.Reserves[ThreeYearsAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[ThreeYearsAgo]!, new: self.Reserves[Today]!)))! + "% in 3 years</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesThreeYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!<self.Reserves[ThreeYearsAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[ThreeYearsAgo]!, new: self.Reserves[Today]!)))! + "% in 3 years</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesThreeYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                
                if (self.Reserves[Today]!==self.Reserves[FourYearsAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080>Same as 4 years ago</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesFourYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!>self.Reserves[FourYearsAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[FourYearsAgo]!, new: self.Reserves[Today]!)))! + "% in 4 years</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesFourYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                else if (self.Reserves[Today]!<self.Reserves[FourYearsAgo]!)
                {
                    let text = "<font face=\"Trebuchet MS\" color=#808080><font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(self.Reserves[FourYearsAgo]!, new: self.Reserves[Today]!)))! + "% in 4 years</font>"
                    
                    let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    do {
                        let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                        self.ReservesFourYear.attributedText = attributedString
                        
                    } catch _ {}
                }
                
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
                yAxis.title = "Foreign Reserves ($ bn)"
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
                ReservesVal = dataPoint["res"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected")
                    return
            }
            
            let date = dateFormatter.dateFromString(dateString)
            
            if (ReservesVal != "0")
            {
                Reserves[dateString] = Double(ReservesVal) // Adds to my dictionary
                let DataPointReserves = SChartDataPoint() // Adds to graph data
                DataPointReserves.xValue = date
                DataPointReserves.yValue = Double(ReservesVal)!/1000
                DataReserves.append(DataPointReserves)
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
        
        let titles : [String] = ["Black Market"]
        let colors : [UIColor] = [UIColor.redColor()]
        
        lineSeries.title = titles[index]
        lineSeries.style().lineColor = colors[index]
        
        /*
         if index == 0 {
         lineSeries.title = "Reserves"
         lineSeries.style().lineColor = UIColor.redColor()
         } etc
         */
        
        
        return lineSeries
        
    }
    
    
    
    func sChart(chart: ShinobiChart, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        
        let counts : [Int] = [DataReserves.count]
        
        return counts[seriesIndex]
        
        /* if seriesIndex == 0
         {
         return DataReserves.count
         } etc */
        
    }
    
    func sChart(chart: ShinobiChart, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData {
        
        if seriesIndex == 0
        {
            return DataReserves[dataIndex]
        }
        else { return DataReserves[dataIndex] }
    }
    
    
}