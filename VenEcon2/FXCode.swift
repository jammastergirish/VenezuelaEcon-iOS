//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

func DevalPerc(let old : Double, let new : Double) -> Double
{
    return 100*((1/old)-(1/new))/(1/old)
}

func PercDiff(let old : Double, let new : Double) -> Double
{
    return 100*(old-new)/old
}

// Wrote this function on 20160810.
func GetLatestNonZeroValue(let dict : [String: Double], let date : String) -> Double
{
    let userCalendar = NSCalendar.currentCalendar()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    var value : Double? = dict[date]
    if ((value != 0) && (value != nil))
    {
        return value!
    }
    else
    {
        let DayBeforeDate = userCalendar.dateByAddingUnit([.Day], value: -1, toDate: dateFormatter.dateFromString(date)!, options: [])
        value = dict[dateFormatter.stringFromDate(DayBeforeDate!)]
        if ((value != 0) && (value != nil))
        {
            return value!
        }
        else
        {
            return GetLatestNonZeroValue(dict, date: dateFormatter.stringFromDate(DayBeforeDate!))
        }
    }
}

//Written early 20160815
func Compare(let dict : [String: Double], let date : String, let label : UILabel, let type : String?)
{
    let userCalendar = NSCalendar.currentCalendar()

    let NumberFormatter = NSNumberFormatter()
    NumberFormatter.numberStyle = .DecimalStyle
    NumberFormatter.maximumFractionDigits = 1
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let Today = dateFormatter.stringFromDate(NSDate())
    let Yesterday = dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -1, toDate: NSDate(), options: [])!)
    let OneWeekAgo = dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -7, toDate: NSDate(), options: [])!)
    let FirstOfThisMonth = ""
    let OneMonthAgo = dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -30, toDate: NSDate(), options: [])!)
    let FirstOfThisYear = ""
    let OneYearAgo = dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -365, toDate: NSDate(), options: [])!)
    let TwoYearsAgo = dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -(365*2), toDate: NSDate(), options: [])!)
    let ThreeYearsAgo = dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -(365*3), toDate: NSDate(), options: [])!)
    let FourYearsAgo = dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -(365*4), toDate: NSDate(), options: [])!)
    let FiveYearsAgo = dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -(365*5), toDate: NSDate(), options: [])!)
    
    var ComparisonString : String = ""
    
    if (date==Yesterday)
    {
        ComparisonString = "yesterday"
    }
    if (date==OneWeekAgo)
    {
        ComparisonString = "a week"
    }
    if (date==OneMonthAgo)
    {
        ComparisonString = "a month"
    }
    if (date==OneYearAgo)
    {
        ComparisonString = "a year"
    }
    if (date==TwoYearsAgo)
    {
        ComparisonString = "2 years"
    }
    if (date==ThreeYearsAgo)
    {
        ComparisonString = "3 years"
    }
    if (date==FourYearsAgo)
    {
        ComparisonString = "4 years"
    }
    if (date==FiveYearsAgo)
    {
        ComparisonString = "5 years"
    }
    
    let comparison : Double = GetLatestNonZeroValue(dict, date: date)
    
    if (type=="FX")
    {
    if (dict[Today]!==comparison)
    {
        let text = "<font face=\"Trebuchet MS\" color=#808080>Same as "+ComparisonString+"</font>"
        
        let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            label.attributedText = attributedString
            
        } catch _ {}
    }
    else if (GetLatestNonZeroValue(dict, date: Today)>comparison)
    {
        let text = "<font face=\"Trebuchet MS\" color=#808080>BsF <font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(DevalPerc(comparison, new: GetLatestNonZeroValue(dict, date: Today))))! + "% in "+ComparisonString+"</font>"
        
        let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            label.attributedText = attributedString
            
        } catch _ {}
    }
    else if (GetLatestNonZeroValue(dict, date: Today)<comparison)
    {
        let text = "<font face=\"Trebuchet MS\" color=#808080>BsF <font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(DevalPerc(comparison, new: GetLatestNonZeroValue(dict, date: Today))))! + "% in "+ComparisonString+"</font>"
        
        let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            label.attributedText = attributedString
            
        } catch _ {}
    }
    }
    else
    {
        if (GetLatestNonZeroValue(dict, date: Today)==comparison)
        {
            let text = "<font face=\"Trebuchet MS\" color=#808080>Same as "+ComparisonString+"</font>"
            
            let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                label.attributedText = attributedString
                
            } catch _ {}
        }
        else if (GetLatestNonZeroValue(dict, date: Today)>comparison)
        {
            let text = "<font face=\"Trebuchet MS\" color=#808080><font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(comparison, new: GetLatestNonZeroValue(dict, date: Today))))! + "% in "+ComparisonString+"</font>"
            
            let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                label.attributedText = attributedString
                
            } catch _ {}
        }
        else if (GetLatestNonZeroValue(dict, date: Today)<comparison)
        {
            let text = "<font face=\"Trebuchet MS\" color=#808080><font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(comparison, new: GetLatestNonZeroValue(dict, date: Today))))! + "% in "+ComparisonString+"</font>"
            
            let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                label.attributedText = attributedString
                
            } catch _ {}
        }
    }
    
    
}



class FXCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    let userCalendar = NSCalendar.currentCalendar()
    
    let currencies : [String: String] = ["GBP": "£", "USD": "$", "EUR": "€", "COP": "COL$", "VEF": "BsF"]
    
    //Variables to hold data
    var BM = [String: Double]()
    var Official = [String: Double]()
    var Simadi = [String: Double]()
    var M2_Res = [String: Double]()
    
    //Variables to hold chart data
    var DataBM: [SChartDataPoint] = []
    var DataOfficial: [SChartDataPoint] = []
    var DataSimadi: [SChartDataPoint] = []
    var DataSupp: [SChartDataPoint] = []
    var DataSitme: [SChartDataPoint] = []
    var DataSicad1: [SChartDataPoint] = []
    var DataSicad2: [SChartDataPoint] = []
    var DataM2_Res: [SChartDataPoint] = []
    
    //Labels for headers
    @IBOutlet var Header: UILabel!
    @IBOutlet var SIMADILabel: UILabel!
    @IBOutlet var BlackMarketLabel: UILabel!
    @IBOutlet var M2_ResLabel: UILabel!
    @IBOutlet var DIPROLabel: UILabel!
    
    //Labels for main values
    @IBOutlet var BlackMarketVal: UILabel!
    @IBOutlet var SIMADIVal: UILabel!
    @IBOutlet var DIPROVal: UILabel!
    @IBOutlet var M2_ResVal: UILabel!
    
    //Labels for variation text
    @IBOutlet var BlackMarketYesterday: UILabel!
    @IBOutlet var BlackMarketMonth: UILabel!
    @IBOutlet var BlackMarketYear: UILabel!
    @IBOutlet var BlackMarketTwoYear: UILabel!
    @IBOutlet var BlackMarketThreeYear: UILabel!
    @IBOutlet var BlackMarketFourYear: UILabel!
    @IBOutlet var SIMADIMonth: UILabel!
    @IBOutlet var SIMADIYesterday: UILabel!
    @IBOutlet var SIMADIYear: UILabel!
    
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
        var Start : String = "2015-08-09"
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
        NumberFormatter.maximumFractionDigits = 1
        
        //Loading so everything hidden. I can't seem to add other stuff to this. Better way to hide/show everything?
        self.chart.hidden = true
        self.SIMADIVal.hidden = true
        self.SIMADIYesterday.hidden = true
        self.SIMADIMonth.hidden = true
        self.SIMADIYear.hidden = true
        self.DIPROVal.hidden = true
        self.BlackMarketVal.hidden = true
        self.BlackMarketYear.hidden = true
        self.BlackMarketMonth.hidden = true
        self.BlackMarketTwoYear.hidden = true
        self.BlackMarketFourYear.hidden = true
        self.BlackMarketThreeYear.hidden = true
        self.BlackMarketYesterday.hidden = true
        self.RangeController.hidden = true
        self.M2_ResVal.hidden = true
        self.Header.hidden = true
        self.SIMADILabel.hidden = true
        self.DIPROLabel.hidden = true
        self.BlackMarketLabel.hidden = true
        self.M2_ResLabel.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        //Added this bit with Pat on 20160804, to download the file
        let url = NSURL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_fx&format=json&start=2011-01-01")!
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
            var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + NumberFormatter.stringFromNumber(self.Simadi[Today]!)! + " <font size=2>BsF/$</font></font>"
            var encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
            var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.SIMADIVal.attributedText = attributedString
                
            } catch _ {}
            
            
            Compare(self.Simadi, date: Yesterday, label: self.SIMADIYesterday, type: "FX")
            Compare(self.Simadi, date: OneMonthAgo, label: self.SIMADIMonth, type: "FX")
            Compare(self.Simadi, date: OneYearAgo, label: self.SIMADIYear, type: "FX")
            

             text = "<CENTER><font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + NumberFormatter.stringFromNumber(GetLatestNonZeroValue(self.M2_Res, date: Today))! + " <font size=2>BsF/$</font></font></CENTER>"
             encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
             attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.M2_ResVal.attributedText = attributedString
                
            } catch _ {}
            

             text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + NumberFormatter.stringFromNumber(self.Official[Today]!)! + " <font size=2>BsF/$</font></font>"
             encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
             attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.DIPROVal.attributedText = attributedString
                
            } catch _ {}
            
            
            

            text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + NumberFormatter.stringFromNumber(self.BM[Today]!)! + " <font size=2>BsF/$</font></font>"
            encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
            attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.BlackMarketVal.attributedText = attributedString
                
            } catch _ {}
            
            
            Compare(self.BM, date: Yesterday, label: self.BlackMarketYesterday, type: "FX")
            Compare(self.BM, date: OneMonthAgo, label: self.BlackMarketMonth, type: "FX")
            Compare(self.BM, date: OneYearAgo, label: self.BlackMarketYear, type: "FX")
            Compare(self.BM, date: TwoYearsAgo, label: self.BlackMarketTwoYear, type: "FX")
            Compare(self.BM, date: ThreeYearsAgo, label: self.BlackMarketThreeYear, type: "FX")
            Compare(self.BM, date: FourYearsAgo, label: self.BlackMarketFourYear, type: "FX")


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
            yAxis.title = "Exchange Rate (" + units + ")"
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
            self.SIMADIVal.hidden = false
            self.SIMADIYesterday.hidden = false
            self.SIMADIMonth.hidden = false
            self.SIMADIYear.hidden = false
            self.DIPROVal.hidden = false
            self.BlackMarketVal.hidden = false
            self.BlackMarketYear.hidden = false
            self.BlackMarketMonth.hidden = false
            self.BlackMarketTwoYear.hidden = false
            self.BlackMarketFourYear.hidden = false
            self.BlackMarketThreeYear.hidden = false
            self.BlackMarketYesterday.hidden = false
            self.RangeController.hidden = false
            self.M2_ResVal.hidden = false
            self.Header.hidden = false
            self.SIMADILabel.hidden = false
            self.DIPROLabel.hidden = false
            self.BlackMarketLabel.hidden = false
            self.M2_ResLabel.hidden = false
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.RangeControl(4)
                                
                                
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
            OfficialVal = dataPoint["official"] as? String,
            BMVal = dataPoint["bm"] as? String,
            SimadiVal = dataPoint["simadi"] as? String,
            SitmeVal = dataPoint["sitme"] as? String,
            Sicad1Val = dataPoint["sicad1"] as? String,
            Sicad2Val = dataPoint["sicad2"] as? String,
            SuppVal = dataPoint["sicad2"] as? String,
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
        
        if (SitmeVal != "0")
        {
            let DataPointSitme = SChartDataPoint()
            DataPointSitme.xValue = date
            DataPointSitme.yValue = Double(SitmeVal)
            DataSitme.append(DataPointSitme)
        }
        
        if (Sicad1Val != "0")
        {
            let DataPointSicad1 = SChartDataPoint()
            DataPointSicad1.xValue = date
            DataPointSicad1.yValue = Double(Sicad1Val)
            DataSicad1.append(DataPointSicad1)
        }
        
        if (Sicad2Val != "0")
        {
            let DataPointSicad2 = SChartDataPoint()
            DataPointSicad2.xValue = date
            DataPointSicad2.yValue = Double(Sicad2Val)
            DataSicad2.append(DataPointSicad2)
        }
        
        if (SuppVal != "0")
        {
            let DataPointSupp = SChartDataPoint()
            DataPointSupp.xValue = date
            DataPointSupp.yValue = Double(SuppVal)
            DataSupp.append(DataPointSupp)
        }
        
    }
}


func numberOfSeriesInSChart(chart: ShinobiChart) -> Int {
    return 8
}

    
func sChart(chart: ShinobiChart, seriesAtIndex index: Int) -> SChartSeries {
    
    let lineSeries = SChartLineSeries()
    lineSeries.style().lineWidth = 2
    lineSeries.animationEnabled = false
    lineSeries.crosshairEnabled = true
    
    let titles : [String] = ["Black Market", "DIPRO", "Simadi", "M2/Reserves", "Site", "Sicad I", "Sicad II", "Supplementary"]
    let colors : [UIColor] = [UIColor.redColor(), UIColor.greenColor(), UIColor.orangeColor(), UIColor.whiteColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.grayColor(), UIColor.lightGrayColor()]
    
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
    
    
    
func sChart(chart: ShinobiChart, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
    
    let counts : [Int] = [DataBM.count,DataOfficial.count,DataSimadi.count, DataM2_Res.count, DataSitme.count, DataSicad1.count, DataSicad2.count, DataSupp.count]
    
    return counts[seriesIndex]
    
    /* if seriesIndex == 0
     {
     return DataBM.count
     } etc */
    
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
    if seriesIndex == 4
    {
        return DataSitme[dataIndex]
    }
    if seriesIndex == 5
    {
        return DataSicad1[dataIndex]
    }
    if seriesIndex == 6
    {
        return DataSicad2[dataIndex]
    }
    if seriesIndex == 7
    {
        return DataSupp[dataIndex]
    }
    else { return DataM2_Res[dataIndex] }
    }


}