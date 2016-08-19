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
    
    let userCalendar = NSCalendar.currentCalendar()
    
    let dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    } ()
    
    
    let NumberFormatter : NSNumberFormatter = {
        let NumberFormatter = NSNumberFormatter()
        NumberFormatter.numberStyle = .DecimalStyle
        NumberFormatter.maximumFractionDigits = 1
        return NumberFormatter
    } ()
    
    let CurrencyFormatter : NSNumberFormatter = {
        let CurrencyFormatter = NSNumberFormatter()
        CurrencyFormatter.numberStyle = .CurrencyStyle
        CurrencyFormatter.currencySymbol = "$"
        return CurrencyFormatter
    } ()

    let currencies : [String: String] = ["GBP": "£", "USD": "$", "EUR": "€", "COP": "COL$", "VEF": "BsF"]
    
    
    //Could make these functions or computed variables, says Pat on 20160817
    /*
    func DateHistory(let To : String, let From : String?) -> String
    {
        if (To=="Today")
        {
            return dateFormatter.stringFromDate(NSDate())
        }
        
        if (From==nil)
        {
            From = DateHi
        }
    }*/
    
    func Today() -> String
    {
        return dateFormatter.stringFromDate(NSDate())
    }
    
    func Yesterday() -> String
    {
        return dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -1, toDate: NSDate(), options: [])!)
    }
    
    func OneWeekAgo() -> String
    {
        return dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -7, toDate: NSDate(), options: [])!)
    }
    
    func FirstOfThisMonth() -> String
    {
        return ""
    }
    
    func OneMonthAgo() -> String
    {
        return dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -30, toDate: NSDate(), options: [])!)
    }

    func YearsAgo(let number : Int) -> String
    {
        return dateFormatter.stringFromDate(userCalendar.dateByAddingUnit([.Day], value: -(365*number), toDate: NSDate(), options: [])!)
    }
    
    //I could put the other global functions into this class and call it Utilities or something.
    
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
        
        var ComparisonString : String = ""
        
        if (date==Yesterday())
        {
            ComparisonString = "yesterday"
        }
        if (date==OneWeekAgo())
        {
            ComparisonString = "a week"
        }
        if (date==OneMonthAgo())
        {
            ComparisonString = "a month"
        }
        if (date==YearsAgo(1))
        {
            ComparisonString = "a year"
        }
        if (date==YearsAgo(2))
        {
            ComparisonString = "2 years"
        }
        if (date==YearsAgo(3))
        {
            ComparisonString = "3 years"
        }
        if (date==YearsAgo(4))
        {
            ComparisonString = "4 years"
        }
        if (date==YearsAgo(5))
        {
            ComparisonString = "5 years"
        }
        
        let comparison : Double = GetLatestNonZeroValue(dict, date: date)
        
        if (type=="FX")
        {
            if (dict[Today()]!==comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080>Same as "+ComparisonString+"</font>"
                
                let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
            else if (GetLatestNonZeroValue(dict, date: Today())>comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080>BsF <font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(DevalPerc(comparison, new: GetLatestNonZeroValue(dict, date: Today()))))! + "% in "+ComparisonString+"</font>"
                
                let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
            else if (GetLatestNonZeroValue(dict, date: Today())<comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080>BsF <font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(DevalPerc(comparison, new: GetLatestNonZeroValue(dict, date: Today()))))! + "% in "+ComparisonString+"</font>"
                
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
            if (GetLatestNonZeroValue(dict, date: Today())==comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080>Same as "+ComparisonString+"</font>"
                
                let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
            else if (GetLatestNonZeroValue(dict, date: Today())>comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080><font color=green>&#x25B2;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(comparison, new: GetLatestNonZeroValue(dict, date: Today()))))! + "% in "+ComparisonString+"</font>"
                
                let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
            else if (GetLatestNonZeroValue(dict, date: Today())<comparison)
            {
                let text = "<font face=\"Trebuchet MS\" color=#808080><font color=red>&#x25BC;</font> " + NumberFormatter.stringFromNumber(abs(PercDiff(comparison, new: GetLatestNonZeroValue(dict, date: Today()))))! + "% in "+ComparisonString+"</font>"
                
                let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
                let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                do {
                    let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                    label.attributedText = attributedString
                    
                } catch _ {}
            }
        }
        
        
    }
    

    
}





