//
//  ParentViewController.swift
//  VenEcon2
//
//  Created by Girish Gupta on 14/12/2017.
//  Copyright © 2017 Girish Gupta. All rights reserved.
//

import UIKit

enum Indicator : String {
    case FX, Bitcoin, Reserves, Inflation, TaxRevenue, MoneySupply, MinWage, OilPrices, CrudeProduction, USOil, TaxUnit
    
    var ViewControllerName : String { //https://stackoverflow.com/questions/24113126/how-to-get-the-name-of-enumeration-value-in-swift
        return self.rawValue + "Child"
    }
    
    var HeaderText : String {
        switch self {
        case .FX : return NSLocalizedString("Exchange Rates", comment: "")
        case .Bitcoin : return NSLocalizedString("Bitcoin", comment: "")
        case .Reserves : return NSLocalizedString("Foreign Reserves", comment: "")
        case .Inflation : return NSLocalizedString("Inflation", comment: "")
        case .TaxRevenue : return NSLocalizedString("Tax Revenue", comment: "")
        case .MoneySupply : return NSLocalizedString("Money Supply", comment: "")
        case .MinWage : return NSLocalizedString("Minimum Wage", comment: "")
        case .OilPrices : return NSLocalizedString("Oil Prices", comment: "")
        case .CrudeProduction : return NSLocalizedString("Crude Production", comment: "")
        case .USOil : return NSLocalizedString("U.S. Oil", comment: "")
        case .TaxUnit : return NSLocalizedString("Tax Unit", comment: "")
        }
    }
}

class ParentViewController: UIViewController, HeaderViewDelegate {
    func ShowMenuTapped() {
        toggleSideMenuView()
    }
    

    var Indicator : Indicator = .FX
    
    @IBOutlet weak var Header: HeaderView!
    @IBOutlet weak var ContainerForChild: UIView!
    @IBOutlet weak var StackForChartAndSegmentedControl: UIStackView!
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    @IBOutlet weak var Chart: ShinobiChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let child : UIViewController = (storyboard?.instantiateViewController(withIdentifier: Indicator.ViewControllerName))! // Check which child is wanted
        
        child.willMove(toParentViewController: self)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        ContainerForChild.addSubviewAndFill(child.view)
        addChildViewController(child)
        child.didMove(toParentViewController: self)
        
        Header.HeaderLabel.text = Indicator.HeaderText
        Header.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
