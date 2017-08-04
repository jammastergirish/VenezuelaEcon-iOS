//
//  DownloadMan.swift
//  VenEcon2
//
//  Created by Girish Gupta on 23/11/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import Foundation
import ClockKit

class DownloadMan
{
    static let shared = DownloadMan()
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    
    let NumberFormatter : Foundation.NumberFormatter = {
        let NumberFormatter = Foundation.NumberFormatter()
        NumberFormatter.numberStyle = .decimal
        NumberFormatter.maximumFractionDigits = 2
        return NumberFormatter
    } ()
    
    
    
    func download(completionblock: @escaping (Int?, Int?, Double?) -> Void)
    {
        
        let url = URL(string: "https://api.venezuelaecon.com/watch.php")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data , error == nil else {
                print("Didn't download properly")
                return
            }
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let response = String(data: data, encoding: String.Encoding.utf8)
                
                let arrayresponse = (response?.components(separatedBy: "X"))
                
                let BM : Int = Int((self.NumberFormatter.number(from: ((arrayresponse?[0]))!))!)
                let DICOM : Int = Int((self.NumberFormatter.number(from: ((arrayresponse?[1]))!))!)
                let Reserves : Double = Double((self.NumberFormatter.number(from: ((arrayresponse?[2]))!))!)
               
                completionblock(BM, DICOM, Reserves)
                
                let defaults = UserDefaults.standard
                defaults.set(BM, forKey: "BlackMarketSavedValue")
                
                self.reloadComplications()
                
            })
        }
        
        task.resume()
    }
    
    func reloadComplications() {
        
        let server=CLKComplicationServer.sharedInstance()
        
        if let activeComplications = server.activeComplications {
            for comp in activeComplications {
                server.reloadTimeline(for: comp)
            }
        }
    }
}
