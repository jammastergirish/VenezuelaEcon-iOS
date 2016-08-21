//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

class ReservesCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    //Variables to hold data
    var Reserves = [String: Double]()
    
    //Variables to hold chart data
    var DataReserves: [SChartDataPoint] = []
    
    @IBOutlet var Header: UILabel!
    
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
        
        //Hide everything while loading
        self.Header.hidden = true
        self.AllText.hidden = true
        self.RangeController.hidden = true
        self.chart.hidden = true
        self.ShowMenuButton.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //Added this bit with Pat on 20160804, to download the file
        let url = NSURL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_res&format=json&start=2000-01-01")!
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
                
                //Set all the text.
                var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.CurrencyFormatter.stringFromNumber(self.Reserves[Utils.shared.Today()]!/1000)! + " <font size=2>billion</font></font>"
                var encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.ReservesVal.attributedText = attributedString
                    
                } catch _ {}
                
                //var comparison : Double = Utils.shared.YearsAgo(GetLatestNonZeroValue(self.Reserves, date: Yesterday)
                Utils.shared.Compare(self.Reserves, date: Utils.shared.Yesterday(), label: self.ReservesYesterday, type: nil)
                Utils.shared.Compare(self.Reserves, date: Utils.shared.OneMonthAgo(), label: self.ReservesMonth, type: nil)
                Utils.shared.Compare(self.Reserves, date: Utils.shared.YearsAgo(1), label: self.ReservesYear, type: nil)
                Utils.shared.Compare(self.Reserves, date: Utils.shared.YearsAgo(2), label: self.ReservesTwoYear, type: nil)
                Utils.shared.Compare(self.Reserves, date: Utils.shared.YearsAgo(3), label: self.ReservesThreeYear, type: nil)
                Utils.shared.Compare(self.Reserves, date: Utils.shared.YearsAgo(4), label: self.ReservesFourYear, type: nil)
                                
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
                
                // Axes
                let xAxis = SChartDiscontinuousDateTimeAxis()
                let yAxis = SChartNumberAxis()
                xAxis.title = "Date"
                yAxis.title = "Foreign Reserves ($ billion)"
                self.enablePanningAndZoomingOnAxis(xAxis)
                self.enablePanningAndZoomingOnAxis(yAxis)
                xAxis.style.lineColor = UIColor.whiteColor()
                yAxis.style.lineColor = UIColor.whiteColor()
                xAxis.style.titleStyle.textColor = UIColor.whiteColor()
                yAxis.style.titleStyle.textColor = UIColor.whiteColor()
                xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
                yAxis.rangePaddingLow = 1
                yAxis.rangePaddingHigh = 1
                xAxis.style.majorGridLineStyle.showMajorGridLines = false
                xAxis.style.lineWidth = 1
                yAxis.style.lineWidth = 1
                yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: self.Reserves.values.maxElement()!/1000)
                
                self.chart.xAxis = xAxis
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
        
        let titles : [String] = ["Foreign Reserves"]
        let colors : [UIColor] = [UIColor.redColor()]
        
        lineSeries.title = titles[index]
        lineSeries.style().lineColor = colors[index]
        
        return lineSeries
        
    }
    
    
    
    func sChart(chart: ShinobiChart, numberOfDataPointsForSeriesAtIndex seriesIndex: Int) -> Int {
        
        let counts : [Int] = [DataReserves.count]
        
        return counts[seriesIndex]
        
    }
    
    func sChart(chart: ShinobiChart, dataPointAtIndex dataIndex: Int, forSeriesAtIndex seriesIndex: Int) -> SChartData {
        
        if seriesIndex == 0
        {
            return DataReserves[dataIndex]
        }
        else { return DataReserves[dataIndex] }
    }
    
    
}