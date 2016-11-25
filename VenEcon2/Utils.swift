//
//  Headers.swift
//  VenEcon2
//
//  Created by Girish Gupta on 17/08/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import Foundation
import UIKit

//With Pat on 20160818 and the next morning
class Utils
{
    static let shared = Utils()
    
    let userCalendar = Calendar.current
    
    let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    } ()
    
    
    let NumberFormatter : Foundation.NumberFormatter = {
        let NumberFormatter = Foundation.NumberFormatter()
        NumberFormatter.numberStyle = .decimal
        NumberFormatter.maximumFractionDigits = 2
        return NumberFormatter
    } ()
    
    let CurrencyFormatter : Foundation.NumberFormatter = {
        let CurrencyFormatter = Foundation.NumberFormatter()
        CurrencyFormatter.numberStyle = .currency
        CurrencyFormatter.currencySymbol = "$"
        return CurrencyFormatter
    } ()

    let currencies : [String: String] = ["GBP": "£", "USD": "$", "EUR": "€", "COP": "COL$", "VEF": "BsF"]
    
    
    //Could make these functions or computed variables, says Pat on 20160817
    
    func Today() -> String
    {
        return dateFormatter.string(from: Date())
    }
    
    func Yesterday() -> String
    {
        return dateFormatter.string(from: (userCalendar as NSCalendar).date(byAdding: [.day], value: -1, to: Date(), options: [])!)
    }
    
    func OneWeekAgo() -> String
    {
        return dateFormatter.string(from: (userCalendar as NSCalendar).date(byAdding: [.day], value: -7, to: Date(), options: [])!)
    }
    
    func FirstOfThisMonth() -> String
    {
        return ""
    }
    
    func OneMonthAgo() -> String
    {
        return dateFormatter.string(from: (userCalendar as NSCalendar).date(byAdding: [.day], value: -30, to: Date(), options: [])!)
    }

    func YearsAgo(_ number : Int) -> String
    {
        return dateFormatter.string(from: (userCalendar as NSCalendar).date(byAdding: [.day], value: -(365*number), to: Date(), options: [])!)
    }
    
    //I could put the other global functions into this class and call it Utilities or something.
    
    func DevalPerc(_ old : Double, new : Double) -> Double
    {
        return 100*((1/old)-(1/new))/(1/old)
    }
    
    
    func PercDiff(_ old : Double, new : Double) -> Double
    {
        return 100*(old-new)/old
    }
    
    
    // Wrote this function on 20160810.
    func GetLatestNonZeroValue(_ dict : [String: Double], date : String) -> Double
    {
        var value : Double? = dict[date]
        if ((value != 0) && (value != nil))
        {
            return value!
        }
        else
        {
            let DayBeforeDate = (userCalendar as NSCalendar).date(byAdding: [.day], value: -1, to: dateFormatter.date(from: date)!, options: [])
            value = dict[dateFormatter.string(from: DayBeforeDate!)]
            if ((value != 0) && (value != nil))
            {
                return value!
            }
            else
            {
                return GetLatestNonZeroValue(dict, date: dateFormatter.string(from: DayBeforeDate!))
            }
        }
    }
    
    
    
  
    
    
    //Written early 20160815
    func Compare(_ dict : [String: Double], date : String, label : UILabel, type : String?)
    {
        
        var ComparisonString : String = ""
        
        if (date==Yesterday())
        {
            ComparisonString = NSLocalizedString("yesterday", comment: "")
        }
        if (date==OneWeekAgo())
        {
            ComparisonString = NSLocalizedString("a week", comment: "")
        }
        if (date==OneMonthAgo())
        {
            ComparisonString = NSLocalizedString("a month", comment: "")
        }
        if (date==YearsAgo(1))
        {
            ComparisonString = NSLocalizedString("a year", comment: "")
        }
        if (date==YearsAgo(2))
        {
            ComparisonString = NSLocalizedString("2 years", comment: "")
        }
        if (date==YearsAgo(3))
        {
            ComparisonString = NSLocalizedString("3 years", comment: "")
        }
        if (date==YearsAgo(4))
        {
            ComparisonString = NSLocalizedString("4 years", comment: "")
        }
        if (date==YearsAgo(5))
        {
            ComparisonString = NSLocalizedString("5 years", comment: "")
        }
        if (date==YearsAgo(6))
        {
            ComparisonString = NSLocalizedString("6 years", comment: "")
        }
        if (date==YearsAgo(7))
        {
            ComparisonString = NSLocalizedString("7 years", comment: "")
        }
        
        let comparison : Double = GetLatestNonZeroValue(dict, date: date)
        
        if (type=="FX")
        {
            if (dict[Today()]!==comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080>Same as "+ComparisonString+"</font>"
                
                let encodedData = text.data(using: String.Encoding.utf8)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
            else if (GetLatestNonZeroValue(dict, date: Today())>comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080>BsF <font color=red>&#x25BC;</font> " + NumberFormatter.string(for: abs(DevalPerc(comparison, new: GetLatestNonZeroValue(dict, date: Today()))))! + "% " + NSLocalizedString("in", comment: "") + " "+ComparisonString+"</font>"
                
                let encodedData = text.data(using: String.Encoding.utf8)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
            else if (GetLatestNonZeroValue(dict, date: Today())<comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080>BsF <font color=green>&#x25B2;</font> " + NumberFormatter.string(for: abs(DevalPerc(comparison, new: GetLatestNonZeroValue(dict, date: Today()))))! + "% " + NSLocalizedString("in", comment: "") + " "+ComparisonString+"</font>"
                
                let encodedData = text.data(using: String.Encoding.utf8)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
        }
        else
        {
            if (GetLatestNonZeroValue(dict, date: Today())==comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080>Same as "+ComparisonString+"</font>"
                
                let encodedData = text.data(using: String.Encoding.utf8)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
            else if (GetLatestNonZeroValue(dict, date: Today())>comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080><font color=green>&#x25B2;</font> " + NumberFormatter.string(for: abs(PercDiff(comparison, new: GetLatestNonZeroValue(dict, date: Today()))))! + "% " + NSLocalizedString("in", comment: "") + " "+ComparisonString+"</font>"
                
                let encodedData = text.data(using: String.Encoding.utf8)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
            else if (GetLatestNonZeroValue(dict, date: Today())<comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080><font color=red>&#x25BC;</font> " + NumberFormatter.string(for: abs(PercDiff(comparison, new: GetLatestNonZeroValue(dict, date: Today()))))! + "% " + NSLocalizedString("in", comment: "") + " "+ComparisonString+"</font>"
                
                let encodedData = text.data(using: String.Encoding.utf8)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
        }
        
        
    }
    
    
    
    func JSONDataFromFile(_ fileName: String) -> [[String : AnyObject]] {
        guard let
            filePath = Bundle.main.path(forResource: fileName, ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
            let json = try? JSONSerialization.jsonObject(
                with: jsonData,
                options: JSONSerialization.ReadingOptions.allowFragments
                ) as! [[String : AnyObject]]
            else {
                print("Problem loading JSON file.")
                return []
        }
        
        return json
    }
    

    
}





