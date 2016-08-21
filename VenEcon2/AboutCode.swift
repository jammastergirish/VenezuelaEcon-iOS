//
//  AboutCode.swift
//  VenEcon1
//

import UIKit
import MessageUI

//class AboutCode: UIViewController {
class AboutCode: UIViewController, MFMailComposeViewControllerDelegate, ENSideMenuDelegate {
    
    
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    @IBOutlet weak var Switch: UISwitch!
    @IBOutlet weak var NotificationsButton: UIButton!
    @IBOutlet weak var TextBox: UITextView!
    @IBOutlet weak var ReceiveNotificationsLabel: UILabel!
    
    
    @IBOutlet weak var VersionLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        viewDidLoad();
    }
    
    
    
    func version() -> String {
        //http://stackoverflow.com/questions/24501288/getting-version-and-build-info-with-swift
        let dictionary = NSBundle.mainBundle().infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) (\(build))"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NotificationsButton.hidden = true
        
        VersionLabel.text = "Version: " + version() + " on " + UIDevice.currentDevice().model
        
        
        Switch.addTarget(self, action: #selector(AboutCode.switchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        let notificationType = UIApplication.sharedApplication().currentUserNotificationSettings()!.types
        // Does user have iPhone notifications enabled for this app
        if notificationType == UIUserNotificationType.None
        { // NO
            Switch.on = false
            Switch.enabled = false
            print("You need to allow notifications in Settings.")
            ReceiveNotificationsLabel.textColor = UIColor.lightGrayColor()
            NotificationsButton.hidden = false
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        else
        { // YES
            
            ReceiveNotificationsLabel.textColor = UIColor.whiteColor()
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let Token = defaults.stringForKey("DeviceToken")
            
            let url = NSURL(string: "https://www.venezuelaecon.com/app/notifications.php?todo=check&id=" + Token!)!
            let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                guard let data = data else {
                    print("No internet connection")
                    self.Switch.enabled = false
                    return
                }
                
                if let response = String(data: data, encoding: NSUTF8StringEncoding)
                {
                    print(response)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if(Int(response)==1)
                        {
                            self.Switch.on = true
                            self.Switch.enabled = true
                            //Receiving notifications
                        }
                        else
                        {
                            self.Switch.on = false
                            self.Switch.enabled = true
                            //Not receiving notifications but can
                        }
                    })
                    
                    
                } else {
                    print("Couldn't do")
                }
                
            }
            
            task.resume()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        
        
        
    }
    
    
    @IBAction func AllowNotifications(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func switchIsChanged(mySwitch: UISwitch) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if mySwitch.on {
            
            
            let notificationType = UIApplication.sharedApplication().currentUserNotificationSettings()!.types
            if notificationType == UIUserNotificationType.None
            {
                //This case should never happen as it's checked for above and the button will be disabled.
                self.Switch.on = false
                print("You need to allow notifications in Settings (but should never see this).")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
            }
            else
            {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let Token = defaults.stringForKey("DeviceToken")
                
                print("User wants notifications, device token is " + Token!)
                
                
                
                
                let url = NSURL(string: "https://www.venezuelaecon.com/app/notifications.php?todo=add&id=" + Token!)!
                let request = NSURLRequest(URL: url)
                let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    
                    guard let data = data else {
                        print("No internet connection")
                        self.Switch.on = false
                        return
                    }
                    
                    if let response = String(data: data, encoding: NSUTF8StringEncoding)
                    {
                        
                        // data.writeToFile("/Users/girish/testing.txt", atomically: true)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            print(response)
                            self.Switch.on = true
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        })
                        
                        
                    } else {
                        print("Couldn't do")
                        self.Switch.on = false
                    }
                    
                }
                
                task.resume()
                //print("Done")
            }
            
            
            
            
            
            
            
            
            
            
            
            
        } else {
            print("User doesn't want notification")
            
            
            
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let Token = defaults.stringForKey("DeviceToken")
            
            
            
            
            let url = NSURL(string: "https://www.venezuelaecon.com/app/notifications.php?todo=remove&id=" + Token!)!
            let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                guard let data = data else {
                    print("didnt download data")
                    self.Switch.on = true
                    return
                }
                
                if let response = String(data: data, encoding: NSUTF8StringEncoding)
                {
                    
                    // data.writeToFile("/Users/girish/testing.txt", atomically: true)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        print(response)
                        self.Switch.on = false
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    })
                    
                    
                } else {
                    print("Couldn't do")
                    self.Switch.on = true
                }
                
            }
            
            task.resume()
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func HandleRightSwipe(sender: AnyObject) {
        tabBarController?.selectedIndex = 3
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func EmailButton(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            picker.setToRecipients(["girish@girish-gupta.com"])
            picker.setSubject("Venezuela Econ " + version() + " on " + UIDevice.currentDevice().model)
            //   picker.setMessageBody(body.text, isHTML: false)
            
            
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    
    
    @IBOutlet var ShowMenuButton: UIButton!
    
    @IBAction func ShowMenu(sender: AnyObject) {
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



