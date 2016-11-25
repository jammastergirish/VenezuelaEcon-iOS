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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    

        DownloadMan.shared.download { (BlackMarketVal, SIMADIVal, ReservesVal) in

            
            var text = "<font face=\"Trebuchet MS\" size=5 color=#FFFFFF>" + BlackMarketVal! + " <font size=1>BsF/$</font></font>"
            var encodedData = text.data(using: String.Encoding.utf8)!
            var attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.BlackMarketValue.setAttributedText(attributedString)
                
            } catch _ {}
            
            
            text = "<font face=\"Trebuchet MS\" size=5 color=#FFFFFF>" + SIMADIVal! + " <font size=1>BsF/$</font></font>"
            encodedData = text.data(using: String.Encoding.utf8)!
            attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.SIMADIValue.setAttributedText(attributedString)
                
            } catch _ {}
            
            text = "<font face=\"Trebuchet MS\" size=5 color=#FFFFFF>" + ReservesVal! + " <font size=1> billion</font></font>"
            encodedData = text.data(using: String.Encoding.utf8)!
            attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
            do {
                let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
                self.ForeignReservesValue.setAttributedText(attributedString)
                
            } catch _ {}
            
            
            
            
        }
        
        
        
    }
    
    
    
    
    
    @IBOutlet var BlackMarketValue: WKInterfaceLabel!
    @IBOutlet var SIMADIValue: WKInterfaceLabel!
    @IBOutlet var ForeignReservesValue: WKInterfaceLabel!
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
