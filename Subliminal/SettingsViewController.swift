//
//  SettingsViewController.swift
//  Subliminal
//
//  Created by Unis Barakat on 2/13/16.
//  Copyright © 2016 Unis Barakat. All rights reserved.
//



 
import ParseUI
import Parse
import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOut()
        PFInstallation.currentInstallation().removeObjectForKey("user")
        PFInstallation.currentInstallation().saveInBackground()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let logout = sb.instantiateViewControllerWithIdentifier("LoginSignupVC") as! LoginViewController
        
        self.tabBarController?.tabBar.hidden = true 
        
        
        
        
        
        self.navigationController?.pushViewController(logout, animated: true)

        
        
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
