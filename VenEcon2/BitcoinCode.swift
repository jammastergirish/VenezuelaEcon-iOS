//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

class BitcoinCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    //Variables to hold data
    var Bitcoin = [String: Double]()
    
    //Variables to hold chart data
    var DataBitcoin: [SChartDataPoint] = []
    
    @IBOutlet var Header: UILabel!
    
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
    
    //Labels for main values
    @IBOutlet var BitcoinVal: UILabel!
    
    //Labels for variation text
    @IBOutlet var BitcoinYesterday: UILabel!
    @IBOutlet var BitcoinMonth: UILabel!
    @IBOutlet var BitcoinYear: UILabel!
    @IBOutlet var BitcoinTwoYear: UILabel!
    @IBOutlet var BitcoinThreeYear: UILabel!
    @IBOutlet var BitcoinFourYear: UILabel!
    
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
        var Start : String = Utils.shared.YearsAgo(3)
        switch RangeController.selectedSegmentIndex
        {
        case 0:
            Start = Utils.shared.YearsAgo(4)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 1:
            Start = Utils.shared.YearsAgo(3)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
        case 2:
            Start = Utils.shared.YearsAgo(2)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
        case 3:
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
        var units : String = Utils.shared.currencies["VEF"]! + "/" + Utils.shared.currencies["USD"]!
        
        //Hide everything while loading
        self.Header.isHidden = true
        self.AllText.isHidden = true
        self.RangeController.isHidden = true
        self.chart.isHidden = true
        self.ShowMenuButton.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //Very nice addition on 20160823!
        loadLocalChartData()
        
        //Added this bit with Pat on 20160804, to download the file
        let url = URL(string: "https://api.venezuelaecon.com/output.php?table=ve_fx&format=json&start=2017-07-31")!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data , error == nil else {
                print("Didn't download properly 1")
                return
            }
            
            guard let optionalJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: AnyObject]],
                let json = optionalJSON else
            {
                print("Did download but the data doesn't look like JSON 2")
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in // Does this bit need to be in main thread? Much quicker if so
                
                self.Data(json)
                //Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.M2, date: Utils.shared.Today())/1
                //Set all the text.
                var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Bitcoin, date: Utils.shared.Today()))! + " <font size=2>"+NSLocalizedString("million", comment: "")+" BsF / BTC</font></font>"
                var encodedData = text.data(using: String.Encoding.utf8)!
                var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    self.BitcoinVal.attributedText = attributedString
                    
                } catch _ {}
                
                //var comparison : Double = Utils.shared.YearsAgo(GetLatestNonZeroValue(self.Bitcoin, date: Yesterday)
                Utils.shared.Compare(self.Bitcoin, date: Utils.shared.Yesterday(), label: self.BitcoinYesterday, type: nil)
                Utils.shared.Compare(self.Bitcoin, date: Utils.shared.OneMonthAgo(), label: self.BitcoinMonth, type: nil)
                Utils.shared.Compare(self.Bitcoin, date: Utils.shared.YearsAgo(1), label: self.BitcoinYear, type: nil)
                Utils.shared.Compare(self.Bitcoin, date: Utils.shared.YearsAgo(2), label: self.BitcoinTwoYear, type: nil)
                Utils.shared.Compare(self.Bitcoin, date: Utils.shared.YearsAgo(3), label: self.BitcoinThreeYear, type: nil)
                Utils.shared.Compare(self.Bitcoin, date: Utils.shared.YearsAgo(4), label: self.BitcoinFourYear, type: nil)
                
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
                self.yAxis.title = "Bitcoin ("+NSLocalizedString("million", comment: "") + " BsF / BTC)"
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
                self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: NSNumber(floatLiteral: self.Bitcoin.values.max()!))
                
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
        
        for dataPoint in Utils.shared.JSONDataFromFile("FXdata") {
            
            guard let
                dateString = dataPoint["date"] as? String,
                let BitcoinVal = dataPoint["bitcoin"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected 3")
                    return
            }
            
            let date = dateFormatter.date(from: dateString)
            
            if (BitcoinVal != "0")
            {
                Bitcoin[dateString] = Double(BitcoinVal)!/1000000 // Adds to my dictionary
                let DataPointBitcoin = SChartDataPoint() // Adds to graph data
                DataPointBitcoin.xValue = date
                DataPointBitcoin.yValue = Double(BitcoinVal)!/1000000
                DataBitcoin.append(DataPointBitcoin)
            }
            
            
        }
        
    }
    
    
    
    
    func Data(_ json : [[String : AnyObject]]) {
        
        for dataPoint in json {
            
            guard let
                dateString = dataPoint["date"] as? String,
                let BitcoinVal = dataPoint["bitcoin"] as? String
                else {
                    print("Data is JSON but not the JSON variables expected 4")
                    return
            }
            
            let date = dateFormatter.date(from: dateString)
            
            if (BitcoinVal != "0")
            {
                Bitcoin[dateString] = Double(BitcoinVal)!/1000000 // Adds to my dictionary
                let DataPointBitcoin = SChartDataPoint() // Adds to graph data
                DataPointBitcoin.xValue = date
                DataPointBitcoin.yValue = Double(BitcoinVal)!/1000000
                DataBitcoin.append(DataPointBitcoin)
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
        
        let titles : [String] = ["Bitcoin"]
        let colors : [UIColor] = [UIColor.red]
        
        lineSeries.title = titles[index]
        lineSeries.style().lineColor = colors[index]
        
        return lineSeries
        
    }
    
    
    
    func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
        
        let counts : [Int] = [DataBitcoin.count]
        
        return counts[seriesIndex]
        
    }
    
    func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
        
        if seriesIndex == 0
        {
            return DataBitcoin[dataIndex]
        }
        else { return DataBitcoin[dataIndex] }
    }
    
    
}