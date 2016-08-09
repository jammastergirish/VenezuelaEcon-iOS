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
    var Official = [NSDate: Double]()
    var Simadi = [NSDate: Double]()
    
    var DataBM: [SChartDataPoint] = []
    var DataOfficial: [SChartDataPoint] = []
    var DataSimadi: [SChartDataPoint] = []
    
    
    @IBOutlet var chart: ShinobiChart!
    let dateFormatter = NSDateFormatter()
    
    required init?(coder aDecoder: NSCoder) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        super.init(coder: aDecoder)
    }
    
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    @IBOutlet var RangeController: UISegmentedControl!
    @IBAction func RangeControl(sender: AnyObject) {
        var Start : String = "2015-08-07"
        switch RangeController.selectedSegmentIndex
        {
        case 0:
            Start = "2012-08-07"
        case 1:
            Start = "2013-08-07"
        case 2:
            Start = "2014-08-07"
        case 3:
            Start = "2015-08-07"
        default:
            break;
        }
        
        let startDate = dateFormatter.dateFromString(Start)
        let endDate = NSDate()
        
        chart.xAxis!.defaultRange = SChartDateRange(dateMinimum: startDate, andDateMaximum: endDate)
        
        chart.reloadData()
        chart.redrawChart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        
        self.navigationController?.navigationBarHidden = true
        
        
        
        self.chart.hidden = true
        
        var units : String = self.currencies["VEF"]! + "/" + self.currencies["USD"]!
        
        //Added this bit with Pat on 20160804
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
            
            
            //Moved this up as was drawing graph before it had the data
            
            let Today = self.dateFormatter.stringFromDate(NSDate())
            let OneWeekAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -7, toDate: NSDate(), options: [])!)
            let OneMonthAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -30, toDate: NSDate(), options: [])!)
            let OneYearAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -365, toDate: NSDate(), options: [])!)
            let TwoYearsAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -(365*2), toDate: NSDate(), options: [])!)
            let ThreeYearsAgo = self.dateFormatter.stringFromDate(self.userCalendar.dateByAddingUnit([.Day], value: -(365*3), toDate: NSDate(), options: [])!)
            
            //self.BM[OneWeekAgo]! is how you get a value back in time/today
            
            
            
            
            
            self.chart.licenseKey = "Cp1q4GaCHtIkNsOMjAxNjA3MTlqYW1tYXN0ZXJnaXJpc2hAZ21haWwuY29tgU9SbiaS3peigE+NS/PAhQFhRWveT1u93rgCmIVskquk63C/aueI194agXA1JcudrIJTczk7i1WdKkaPWcRKiq8Y9cf4HufRFdCeGOeUNgClCpL1Ip2DD0fnYIEq3riK8o95Z6ppqIk/Brq2CD1dalFWpE50=AXR/y+mxbZFM+Bz4HYAHkrZ/ekxdI/4Aa6DClSrE4o73czce7pcia/eHXffSfX9gssIRwBWEPX9e+kKts4mY6zZWsReM+aaVF0BL6G9Vj2249wYEThll6JQdqaKda41AwAbZXwcssavcgnaHc3rxWNBjJDOk6Cd78fr/LwdW8q7gmlj4risUXPJV0h7d21jO1gzaaFCPlp5G8l05UUe2qe7rKbarpjoddMoXrpErC9j8Lm5Oj7XKbmciqAKap+71+9DGNE2sBC+sY4V/arvEthfhk52vzLe3kmSOsvg5q+DQG/W9WbgZTmlMdWHY2B2nbgm3yZB7jFCiXH/KfzyE1A==PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+"
            self.chart.canvasAreaBackgroundColor = UIColor.blackColor()
            self.chart.backgroundColor = UIColor.blackColor()
            self.chart.canvas.backgroundColor = UIColor.blueColor()
            self.chart.plotAreaBackgroundColor = UIColor.blackColor()
            
            self.chart.legend.placement = .OutsidePlotArea
            self.chart.legend.position = .BottomMiddle
            self.chart.legend.style.areaColor = UIColor.blackColor()
            self.chart.legend.style.fontColor = UIColor.whiteColor()
            // chart.legend.style.font = UIFont(name: "System", size: 30)
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
            self.chart.yAxis = yAxis
            
            
            xAxis.style.majorGridLineStyle.lineWidth = 1
            xAxis.style.majorGridLineStyle.lineColor = UIColor.darkGrayColor()
            xAxis.style.majorGridLineStyle.showMajorGridLines = true
            yAxis.style.majorGridLineStyle.lineWidth = 1
            yAxis.style.majorGridLineStyle.lineColor = UIColor.darkGrayColor()
            yAxis.style.majorGridLineStyle.showMajorGridLines = true
            
            
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
    @IBAction func ButtonPress(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    
    
    // MARK: - ENSideMenu Delegate
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


func JSONDataFromFile(fileName: String) -> [[String : AnyObject]] {
    guard let
        filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json"),
        jsonData = NSData(contentsOfFile: filePath),
        json = try? NSJSONSerialization.JSONObjectWithData(
            jsonData,
            options: NSJSONReadingOptions.AllowFragments
            ) as! [[String : AnyObject]]
        else {
            print("Problem loading JSON file.")
            return []
    }
    
    return json
}




func Data(json : [[String : AnyObject]]) {
    
    // for dataPoint in JSONDataFromFile("ve_fx") {
    for dataPoint in json {
        
        
        guard let
            dateString = dataPoint["date"] as? String,
            OfficialVal = dataPoint["official"] as? String,
            BMVal = dataPoint["bm"] as? String,
            SimadiVal = dataPoint["simadi"] as? String
            else {
                print("Data is JSON but not the JSON variables expected")
                return
        }
        
        let date = dateFormatter.dateFromString(dateString)
        
        
        BM[dateString] = Double(BMVal) // Adds to my dictionary
        let DataPointBM = SChartDataPoint() // Adds to graph data
        DataPointBM.xValue = date
        DataPointBM.yValue = Double(BMVal)
        DataBM.append(DataPointBM)
        
        
        
        Official[date!] = Double(OfficialVal)
        let DataPointOfficial = SChartDataPoint()
        DataPointOfficial.xValue = date
        DataPointOfficial.yValue = Double(OfficialVal)
        DataOfficial.append(DataPointOfficial)
        
        
        Simadi[date!] = Double(SimadiVal)
        let DataPointSimadi = SChartDataPoint()
        DataPointSimadi.xValue = date
        DataPointSimadi.yValue = Double(SimadiVal)
        DataSimadi.append(DataPointSimadi)
        
        
    }
}



func numberOfSeriesInSChart(chart: ShinobiChart) -> Int {
    return 3
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
    else
    {
        return DataSimadi.count
    }
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
    else
    {
        return DataSimadi[dataIndex]
    }
}





}
