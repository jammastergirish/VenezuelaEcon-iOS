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

    @IBOutlet weak var MainStack: UIStackView!
    
    //Labels for main values
    @IBOutlet var BlackMarketVal: UILabel!
    @IBOutlet var DicomVal: UILabel!
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

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    




}



