//
//  DownloadMan.swift
//  VenEcon2
//
//  Created by Girish Gupta on 23/11/2016.
//  Copyright © 2016 Girish Gupta. All rights reserved.
//

import Foundation

class DownloadMan
{
    static let shared = DownloadMan()
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func download(completionblock: @escaping (String?, String?, String?) -> Void)
    {
        
        // Configure interface objects here.
        let url = URL(string: "https://www.venezuelaecon.com/app/watch.php")!
        
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data , error == nil else {
                print("Didn't download properly")
                return
            }
            
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let response = String(data: data, encoding: String.Encoding.utf8)
                
                let arrayresponse = (response?.components(separatedBy: "X"))
               
                completionblock(arrayresponse?[0], arrayresponse?[1], arrayresponse?[2])
                
                let defaults = UserDefaults.standard
                defaults.set(arrayresponse?[0], forKey: "BlackMarketSavedValue")
                
            })
        }
        
        task.resume()
    }
}
