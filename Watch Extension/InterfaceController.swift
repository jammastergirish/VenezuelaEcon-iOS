//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Girish Gupta on 23/11/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    
    let NumberFormatter : Foundation.NumberFormatter = {
        let NumberFormatter = Foundation.NumberFormatter()
        NumberFormatter.numberStyle = .decimal
        NumberFormatter.maximumFractionDigits = 2
        return NumberFormatter
    } ()
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    

        
        
        
    }
    
    
    
    
    
    @IBOutlet var BlackMarketValue: WKInterfaceLabel!
    @IBOutlet var SIMADIValue: WKInterfaceLabel!
    @IBOutlet var ForeignReservesValue: WKInterfaceLabel!
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        

        
        
        
        
        DownloadMan.shared.download { (BlackMarketVal, SIMADIVal, ReservesVal) in
            
            var text = "<font face=\"Trebuchet MS\" size=5 color=#FFFFFF>" + self.NumberFormatter.string(for: ((BlackMarketVal)))! + " <font size=1>BsF/$</font></font>"
            var encodedData = text.data(using: String.Encoding.utf8)!
            var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.BlackMarketValue.setAttributedText(attributedString)
                
            } catch _ {}
            
            text = "<font face=\"Trebuchet MS\" size=5 color=#FFFFFF>" + self.NumberFormatter.string(for: ((SIMADIVal)))! + " <font size=1>BsF/$</font></font>"
            encodedData = text.data(using: String.Encoding.utf8)!
            attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.SIMADIValue.setAttributedText(attributedString)
                
            } catch _ {}
            
            text = "<font face=\"Trebuchet MS\" size=5 color=#FFFFFF>$" + self.NumberFormatter.string(for: ((ReservesVal)))! + " <font size=1> "+NSLocalizedString("billion", comment: "")+"</font></font>"
            encodedData = text.data(using: String.Encoding.utf8)!
            attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.ForeignReservesValue.setAttributedText(attributedString)
                
            } catch _ {}
            
            
            
            
        }

        
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
