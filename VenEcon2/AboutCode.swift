//
//  AboutCode.swift
//  VenEcon1
//

import UIKit
import MessageUI

//class AboutCode: UIViewController {
class AboutCode: UIViewController, MFMailComposeViewControllerDelegate, ENSideMenuDelegate {
    
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    @IBOutlet weak var TextBox: UITextView!
    
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
    
        
        VersionLabel.text = "Version: " + version() + " on " + UIDevice.current.model
        
        
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



