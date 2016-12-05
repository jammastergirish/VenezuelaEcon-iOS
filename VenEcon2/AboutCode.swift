//
//  AboutCode.swift
//  VenEcon1
//

import UIKit
import MessageUI

//class AboutCode: UIViewController {
class AboutCode: UIViewController, MFMailComposeViewControllerDelegate, ENSideMenuDelegate {
    
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var NotificationsButton: UIButton!
    @IBOutlet weak var TextBox: UITextView!
    @IBOutlet weak var ReceiveNotificationsLabel: UILabel!
    
    
    @IBOutlet weak var VersionLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad();
    }
    
    
    
    func version() -> String {
        //http://stackoverflow.com/questions/24501288/getting-version-and-build-info-with-swift
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) (\(build))"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NotificationsButton.isHidden = true
        
        VersionLabel.text = "Version: " + version() + " on " + UIDevice.current.model
        
        
        Switch.addTarget(self, action: #selector(AboutCode.switchIsChanged(_:)), for: UIControlEvents.valueChanged)
        
        
        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        // Does user have iPhone notifications enabled for this app
        if notificationType == UIUserNotificationType()
        { // NO
            Switch.isOn = false
            Switch.isEnabled = false
            print("You need to allow notifications in Settings.")
            ReceiveNotificationsLabel.textColor = UIColor.lightGray
            NotificationsButton.isHidden = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        else
        { // YES
            
            ReceiveNotificationsLabel.textColor = UIColor.white
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let defaults = UserDefaults.standard
            let Token = defaults.string(forKey: "DeviceToken")
            
            let url = URL(string: "https://www.venezuelaecon.com/app/notifications.php?todo=check&id=" + Token!)!
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                guard let data = data else {
                    print("No internet connection")
                    self.Switch.isEnabled = false
                    return
                }
                
                if let response = String(data: data, encoding: String.Encoding.utf8)
                {
                    print(response)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        if(Int(response)==1)
                        {
                            self.Switch.isOn = true
                            self.Switch.isEnabled = true
                            //Receiving notifications
                        }
                        else
                        {
                            self.Switch.isOn = false
                            self.Switch.isEnabled = true
                            //Not receiving notifications but can
                        }
                    })
                    
                    
                } else {
                    print("Couldn't do")
                }
                
            }) 
            
            task.resume()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        
        
        
    }
    
    
    @IBAction func AllowNotifications(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func switchIsChanged(_ mySwitch: UISwitch) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if mySwitch.isOn {
            
            
            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
            if notificationType == UIUserNotificationType()
            {
                //This case should never happen as it's checked for above and the button will be disabled.
                self.Switch.isOn = false
                print("You need to allow notifications in Settings (but should never see this).")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }
            else
            {
                
                let defaults = UserDefaults.standard
                let Token = defaults.string(forKey: "DeviceToken")
                
                print("User wants notifications, device token is " + Token!)
                
                
                
                
                let url = URL(string: "https://www.venezuelaecon.com/app/notifications.php?todo=add&id=" + Token!)!
                let request = URLRequest(url: url)
                let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    
                    guard let data = data else {
                        print("No internet connection")
                        self.Switch.isOn = false
                        return
                    }
                    
                    if let response = String(data: data, encoding: String.Encoding.utf8)
                    {
                        
                        // data.writeToFile("/Users/girish/testing.txt", atomically: true)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            print(response)
                            self.Switch.isOn = true
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        })
                        
                        
                    } else {
                        print("Couldn't do")
                        self.Switch.isOn = false
                    }
                    
                }) 
                
                task.resume()
                //print("Done")
            }
            
            
            
            
            
            
            
            
            
            
            
            
        } else {
            print("User doesn't want notification")
            
            
            
            
            
            let defaults = UserDefaults.standard
            let Token = defaults.string(forKey: "DeviceToken")
            
            
            
            
            let url = URL(string: "https://www.venezuelaecon.com/app/notifications.php?todo=remove&id=" + Token!)!
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                guard let data = data else {
                    print("didnt download data")
                    self.Switch.isOn = true
                    return
                }
                
                if let response = String(data: data, encoding: String.Encoding.utf8)
                {
                    
                    // data.writeToFile("/Users/girish/testing.txt", atomically: true)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        print(response)
                        self.Switch.isOn = false
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    })
                    
                    
                } else {
                    print("Couldn't do")
                    self.Switch.isOn = true
                }
                
            }) 
            
            task.resume()
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func GoToSettings(_ sender: AnyObject) {
           UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func EmailButton(_ sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            picker.setToRecipients(["girish@girish-gupta.com"])
            picker.setSubject("Venezuela Econ " + version() + " on " + UIDevice.current.model)
            //   picker.setMessageBody(body.text, isHTML: false)
            
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func TwitterButton(_ sender: Any) {
        let twUrl: NSURL = NSURL(string: "twitter://user?screen_name=VenezuelaEcon")!
        let twUrlWeb: NSURL = NSURL(string: "https://twitter.com/VenezuelaEcon")!
        
        if(UIApplication.shared.canOpenURL(twUrl as URL)) {
            // If user twitter installed
            UIApplication.shared.openURL(twUrl as URL)
        } else {
            // If user does not have twitter installed
            UIApplication.shared.openURL(twUrlWeb as URL)
        }
    }
    
    @IBAction func ShareButton(_ sender: UIButton) {
        let textToShare = "Venezuela Econ iPhone app"
        
        if let myWebsite = NSURL(string: "http://www.venezuelaecon.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
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

    
    
    
    
    
}



