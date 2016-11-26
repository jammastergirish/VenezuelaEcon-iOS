//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

//Written 20160819 morning
func AnnualInflation(_ Year : Int, source : [String: Double]) ->  Double
{
    if (Year != 1)
    {
     let old : Double = source[String(Year-1)+"-12-31"]!
     let new : Double = source[String(Year)+"-12-31"]!
     return abs(Utils.shared.PercDiff(old, new: new))
    }
    else
    { // Here I need to write code to output the last twelve months, so need GetLatestNonZeroValue() to output the date too, so I know how far back to go for old (20160819)
        let old : Double = source[String(Year-1)+"-12-31"]!
        let new : Double = source[Utils.shared.Today()]!
        return abs(Utils.shared.PercDiff(old, new: new))
    }
}

class InflationCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    //Variables to hold data
    var Inflation = [String: Double]()
    var Monthly = [String: Double]()
    var Annual = [String: Double]()
    
    //Variables to hold chart data
    var DataInflation: [SChartDataPoint] = []
    
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
    
    //Layout stuff
    @IBOutlet var Header: UILabel!
    
    
    //Labels for main values
    @IBOutlet var AnnualInflationVal: UILabel!
    @IBOutlet var MonthlyInflationVal: UILabel!
    
    //Labels for variation text
    @IBOutlet var Label2015: UILabel!
    @IBOutlet var Label2014: UILabel!
    @IBOutlet var Label2013: UILabel!
    @IBOutlet var Label2012: UILabel!
    @IBOutlet var Label2011: UILabel!
    @IBOutlet var Label2010: UILabel!
    @IBOutlet var Label2009: UILabel!

    
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
        var Start : String = Utils.shared.YearsAgo(5)
        switch RangeController.selectedSegmentIndex
        {
        case 0:
            Start = Utils.shared.YearsAgo(5)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 1:
            Start = Utils.shared.YearsAgo(4)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 2:
            Start = Utils.shared.YearsAgo(3)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
        case 3:
            Start = Utils.shared.YearsAgo(2)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
        case 4:
            Start = Utils.shared.YearsAgo(1)
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
        
        
        //Hide everything on loading
        self.Header.isHidden = true
        self.AllText.isHidden = true
        self.RangeController.isHidden = true
        self.chart.isHidden = true
        self.ShowMenuButton.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //Very nice addition on 20160823!
        loadLocalChartData()
        
        //Added this bit with Pat on 20160804, to download the file
        let url = URL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_inf2&format=json&start=2015-12-31")!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data , error == nil else {
                print("Didn't download properly")
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
                
                var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Annual, date: Utils.shared.Today()))! + "<font size=2>%</font></font>"
                var encodedData = text.data(using: String.Encoding.utf8)!
                var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.AnnualInflationVal.attributedText = attributedString
                    
                } catch _ {}
                
                text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(from: NSNumber(floatLiteral: Utils.shared.GetLatestNonZeroValue(self.Monthly, date: Utils.shared.Today())))! + "<font size=2>%</font></font>"
                 encodedData = text.data(using: String.Encoding.utf8)!
                 attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.MonthlyInflationVal.attributedText = attributedString
                    
                } catch _ {}
                
                
                Utils.shared.GetLatestNonZeroValue(self.Inflation, date: Utils.shared.Today())
                
                self.Label2015.text = Utils.shared.NumberFormatter.string(for: (NSNumber(floatLiteral: AnnualInflation(2015, source: self.Inflation))))!+"%"
                self.Label2014.text = Utils.shared.NumberFormatter.string(for: (NSNumber(floatLiteral: AnnualInflation(2014, source: self.Inflation))))!+"%"
                self.Label2013.text = Utils.shared.NumberFormatter.string(for: (NSNumber(floatLiteral: AnnualInflation(2013, source: self.Inflation))))!+"%"
                self.Label2012.text = Utils.shared.NumberFormatter.string(for: (NSNumber(floatLiteral: AnnualInflation(2012, source: self.Inflation))))!+"%"
                self.Label2011.text = Utils.shared.NumberFormatter.string(for: (NSNumber(floatLiteral: AnnualInflation(2011, source: self.Inflation))))!+"%"
                self.Label2010.text = Utils.shared.NumberFormatter.string(for: (NSNumber(floatLiteral: AnnualInflation(2010, source: self.Inflation))))!+"%"
                self.Label2009.text = Utils.shared.NumberFormatter.string(for: (NSNumber(floatLiteral: AnnualInflation(2009, source: self.Inflation))))!+"%"

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
                self.yAxis.title = ""+NSLocalizedString("Inflation", comment: "")+" (2007 = 1)"
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
                self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: NSNumber(floatLiteral: self.Inflation.values.max()!/100))
                
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
        
        for dataPoint in Utils.shared.JSONDataFromFile("InfData") {
            
            guard let
                dateString = dataPoint["date"] as? String,
                let InflationVal = dataPoint["inf"] as? String,
                let MonthlyVal = dataPoint["monthly"] as? String,
                let AnnualVal = dataPoint["annual"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected")
                    return
            }
            
            let date = dateFormatter.date(from: dateString)
            
            if (InflationVal != "0")
            {
                Inflation[dateString] = Double(InflationVal)! // Adds to my dictionary
                let DataPointInflation = SChartDataPoint() // Adds to graph data
                DataPointInflation.xValue = date
                DataPointInflation.yValue = Double(InflationVal)!/100
                DataInflation.append(DataPointInflation)
            }
            
            if (MonthlyVal != "0")
            {
                Monthly[dateString] = Double(MonthlyVal)! // Adds to my dictionary
            }
            
            if (AnnualVal != "0")
            {
                Annual[dateString] = Double(AnnualVal)! // Adds to my dictionary
            }
            
            
            
            
            
        }
        
        
    }
    
    
    func Data(_ json : [[String : AnyObject]]) {
        
        // for dataPoint in JSONDatac.f.File("ve_fx") {
        for dataPoint in json {
            
            guard let
                dateString = dataPoint["date"] as? String,
                let InflationVal = dataPoint["inf"] as? String,
                let MonthlyVal = dataPoint["monthly"] as? String,
                let AnnualVal = dataPoint["annual"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected")
                    return
            }
            
            let date = dateFormatter.date(from: dateString)
            
            if (InflationVal != "0")
            {
                Inflation[dateString] = Double(InflationVal)! // Adds to my dictionary
                let DataPointInflation = SChartDataPoint() // Adds to graph data
                DataPointInflation.xValue = date
                DataPointInflation.yValue = Double(InflationVal)!/100
                DataInflation.append(DataPointInflation)
            }
            
            if (MonthlyVal != "0")
            {
                Monthly[dateString] = Double(MonthlyVal)! // Adds to my dictionary
            }
            
            if (AnnualVal != "0")
            {
                Annual[dateString] = Double(AnnualVal)! // Adds to my dictionary
            }
            
            

            
            
        }
    }
    
    
    func numberOfSeries(inSChart chart: ShinobiChart) -> Int {
        return 1
    }
    
    
    func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
        
        let lineSeries = SChartLineSeries()
        lineSeries.style().lineWidth = 2
        lineSeries.animationEnabled = false
        lineSeries.crosshairEnabled = true
        
        let titles : [String] = ["Inflation"]
        let colors : [UIColor] = [UIColor.red]
        
        lineSeries.title = titles[index]
        lineSeries.style().lineColor = colors[index]
        
        
        return lineSeries
        
    }
    
    
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        
        let counts : [Int] = [DataInflation.count]
        
        return counts[seriesIndex]
        
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        
        if seriesIndex == 0
        {
            return DataInflation[dataIndex]
        }
        else { return DataInflation[dataIndex] }
    }
    
    
}
