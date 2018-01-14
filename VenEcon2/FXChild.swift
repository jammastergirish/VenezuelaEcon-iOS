//
//  FXChild.swift
//  VenEcon2
//
//  Created by Girish Gupta on 14/12/2017.
//  Copyright © 2017 Girish Gupta. All rights reserved.
//

import UIKit

class FXChild: UIViewController
{

    //Labels for main values
    @IBOutlet var BlackMarketVal: UILabel!
    @IBOutlet var DicomVal: UILabel!
    @IBOutlet var DIPROVal: UILabel!
    @IBOutlet var M2_ResVal: UILabel!
    
    //Labels for variation text
    @IBOutlet var BlackMarketYesterday: UILabel!
    @IBOutlet var BlackMarketMonth: UILabel!
    @IBOutlet var BlackMarketYear: UILabel!
    @IBOutlet var BlackMarketTwoYear: UILabel!
    @IBOutlet var BlackMarketThreeYear: UILabel!
    @IBOutlet var BlackMarketFourYear: UILabel!
    @IBOutlet var BlackMarketFiveYear: UILabel!
    @IBOutlet var DicomMonth: UILabel!
    @IBOutlet var DicomYesterday: UILabel!
    @IBOutlet var DicomYear: UILabel!
    
    //Range Controller and Range Control functions
    //@IBOutlet var RangeController: UISegmentedControl!
//    @IBAction func RangeControl(_ sender: AnyObject) {
//        var Start : String = Utils.shared.YearsAgo(4)
//        switch RangeControl.selectedSegmentIndex
//        {
//        case 0:
//            Start = Utils.shared.YearsAgo(32)
//            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
//        case 1:
//            Start = Utils.shared.YearsAgo(16)
//            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
//        case 2:
//            Start = Utils.shared.YearsAgo(8)
//            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
//        case 3:
//            Start = Utils.shared.YearsAgo(4)
//            xAxis.labelFormatter!.dateFormatter().dateFormat = "YYYY"
//        case 4:
//            Start = Utils.shared.YearsAgo(2)
//            xAxis.labelFormatter!.dateFormatter().dateFormat = "MMM YYYY"
//        default:
//            break;
//        }
    
//        let startDate = Utils.shared.dateFormatter.date(from: Start)
//        let endDate = Date()

        
//        chart.xAxis!.defaultRange = SChartDateRange(dateMinimum: startDate, andDateMaximum: endDate)
//
//        chart.reloadData()
//        chart.redraw()
//   }

    

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    




}



