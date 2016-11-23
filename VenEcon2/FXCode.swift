//
//  ViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 08/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import UIKit

class FXCode: UIViewController, ENSideMenuDelegate, SChartDatasource{
    
    // 20160818 Decided not to use the following and just use Utils.shared.XXX
    // let utils = Utils.shared
    
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
            Start = Utils.shared.YearsAgo(16)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 1:
            Start = Utils.shared.YearsAgo(8)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
        case 2:
            Start = Utils.shared.YearsAgo(4)
            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
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
        let url = URL(string: "https://www.venezuelaecon.com/app/output.php?table=ve_fx&format=json&start=2016-07-31")!
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
            
         DispatchQueue.main.async(execute: { () -> Void in // Does this bit need to be in main thread? Much quicker if so

            self.Data(json)
            
            //Set all the text.
            var text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Simadi, date: Utils.shared.Today()))! + " <font size=2>BsF/$</font></font>"
            var encodedData = text.data(using: String.Encoding.utf8)!
            var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.SIMADIVal.attributedText = attributedString
                
            } catch _ {}
            
            
            Utils.shared.Compare(self.Simadi, date: Utils.shared.Yesterday(), label: self.SIMADIYesterday, type: "FX")
            Utils.shared.Compare(self.Simadi, date: Utils.shared.OneMonthAgo(), label: self.SIMADIMonth, type: "FX")
            Utils.shared.Compare(self.Simadi, date: Utils.shared.YearsAgo(1), label: self.SIMADIYear, type: "FX")
            

             text = "<CENTER><font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.M2_Res, date: Utils.shared.Today()))! + " <font size=2>BsF/$</font></font></CENTER>"
             encodedData = text.data(using: String.Encoding.utf8)!
             attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.M2_ResVal.attributedText = attributedString
                
            } catch _ {}

             text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.Official, date: Utils.shared.Today()))! + " <font size=2>BsF/$</font></font>"
             encodedData = text.data(using: String.Encoding.utf8)!
             attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.DIPROVal.attributedText = attributedString
                
            } catch _ {}

            text = "<font face=\"Trebuchet MS\" size=6 color=#FFFFFF>" + Utils.shared.NumberFormatter.string(for: Utils.shared.GetLatestNonZeroValue(self.BM, date: Utils.shared.Today()))! + " <font size=2>BsF/$</font></font>"
            encodedData = text.data(using: String.Encoding.utf8)!
            attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.BlackMarketVal.attributedText = attributedString
                
            } catch _ {}
            
            
            Utils.shared.Compare(self.BM, date: Utils.shared.Yesterday(), label: self.BlackMarketYesterday, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.OneMonthAgo(), label: self.BlackMarketMonth, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(1), label: self.BlackMarketYear, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(2), label: self.BlackMarketTwoYear, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(3), label: self.BlackMarketThreeYear, type: "FX")
            Utils.shared.Compare(self.BM, date: Utils.shared.YearsAgo(4), label: self.BlackMarketFourYear, type: "FX")

            //DRAW THE GRAPHS
            self.chart.canvasAreaBackgroundColor = UIColor.black
            self.chart.backgroundColor = UIColor.black
            self.chart.canvas.backgroundColor = UIColor.blue
            self.chart.plotAreaBackgroundColor = UIColor.black
            
            self.chart.legend.placement = .insidePlotArea
            self.chart.legend.position = .bottomMiddle
            self.chart.legend.style.areaColor = UIColor.black
            self.chart.legend.style.fontColor = UIColor.white
            self.chart.legend.isHidden = true
            
            self.chart.crosshair?.style.lineColor = UIColor.white
            self.chart.crosshair?.style.lineWidth = 1
            
            // Axes
            self.xAxis.title = "Date"
            self.yAxis.title = "Exchange Rate (" + units + ")"
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
            self.yAxis.defaultRange = SChartRange(minimum: 0, andMaximum: self.BM.values.max()! as NSNumber!)
            
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
            
            self.RangeControl(2 as AnyObject)

                                
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
    
    
/*This is how you switch to another View Controller
    @IBAction func Calculator(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FXCalcViewController")
        sideMenuController()?.setContentViewController(destViewController)
        
    }*/
    
func enablePanningAndZoomingOnAxis(_ axis: SChartAxis) {
    axis.enableGesturePanning = true
    axis.enableGestureZooming = true
}
    
    
//LOCAL LOADING
func loadLocalChartData() {
    
for dataPoint in Utils.shared.JSONDataFromFile("FXdata") {
            
    guard let
        dateString = dataPoint["date"] as? String,
        let OfficialVal = dataPoint["official"] as? String,
        let BMVal = dataPoint["bm"] as? String,
        let SimadiVal = dataPoint["simadi"] as? String,
        let SitmeVal = dataPoint["sitme"] as? String,
        let Sicad1Val = dataPoint["sicad1"] as? String,
        let Sicad2Val = dataPoint["sicad2"] as? String,
        let SuppVal = dataPoint["sicad2"] as? String,
        let M2_ResVal = dataPoint["m2_res"] as? String
        else {
            print("Data is JSON but not the JSON variables expected")
            return
    }
    
    let date = dateFormatter.date(from: dateString)
    
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

    
    
func Data(_ json : [[String : AnyObject]]) {
    
    for dataPoint in json {
        
        guard let
            dateString = dataPoint["date"] as? String,
            let OfficialVal = dataPoint["official"] as? String,
            let BMVal = dataPoint["bm"] as? String,
            let SimadiVal = dataPoint["simadi"] as? String,
            let SitmeVal = dataPoint["sitme"] as? String,
            let Sicad1Val = dataPoint["sicad1"] as? String,
            let Sicad2Val = dataPoint["sicad2"] as? String,
            let SuppVal = dataPoint["sicad2"] as? String,
            let M2_ResVal = dataPoint["m2_res"] as? String
            else {
                print("Data is JSON but not the JSON variables expected")
                return
        }
        
        let date = dateFormatter.date(from: dateString)
        
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


func numberOfSeries(inSChart chart: ShinobiChart) -> Int {
    return 8
}

    
func sChart(_ chart: ShinobiChart, seriesAt index: Int) -> SChartSeries {
    
    let lineSeries = SChartLineSeries()
    lineSeries.style().lineWidth = 2
    lineSeries.animationEnabled = false
    lineSeries.crosshairEnabled = true
    
    let titles : [String] = ["Black Market", "DIPRO", "Simadi", "M2/Reserves", "Site", "Sicad I", "Sicad II", "Supplementary"]
    let colors : [UIColor] = [UIColor.red, UIColor.green, UIColor.orange, UIColor.white, UIColor.blue, UIColor.purple, UIColor.gray, UIColor.lightGray]
    
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
    
    
    
func sChart(_ chart: ShinobiChart, numberOfDataPointsForSeriesAt seriesIndex: Int) -> Int {
    
    let counts : [Int] = [DataBM.count,DataOfficial.count,DataSimadi.count, DataM2_Res.count, DataSitme.count, DataSicad1.count, DataSicad2.count, DataSupp.count]
    
    return counts[seriesIndex]
    
    /* if seriesIndex == 0
     {
     return DataBM.count
     } etc */
    
}

func sChart(_ chart: ShinobiChart, dataPointAt dataIndex: Int, forSeriesAt seriesIndex: Int) -> SChartData {
    
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
