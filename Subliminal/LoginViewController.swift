//
//  LoginViewController.swift
//  Subliminal
//
//  Created by Unis Barakat on 2/13/16.
//  Copyright © 2016 Unis Barakat. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class LoginViewController:PFLogInViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.delegate = self
        
//        self.logInView!.logo = UIImageView(image: UIImage(named: "Subliminal"))
        
//        self.signUpController.signUpView!.logo = UIImageView(image: UIImage(named: "logo"))
        
        self.logInView!.logo!.contentMode = .ScaleAspectFit
        
        
        self.logInView!.signUpButton!.setBackgroundImage(UIImage(named: "Rectangle 8"), forState: .Normal)
        
        self.logInView!.signUpButton!.removeTarget(self, action: nil, forControlEvents: .AllEvents)
        
        self.logInView!.signUpButton!.addTarget(self, action: "displaySignUp", forControlEvents: .TouchUpInside)
        
        if PFUser.currentUser() != nil {
            showTab()
        }
        
        
    }
    
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation.saveInBackgroundWithBlock(nil)
        showTab()
    
    }
    
    

    
    
    func showTab() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let tabVC = sb.instantiateViewControllerWithIdentifier("tabView")
        
        tabVC.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationController?.pushViewController(tabVC, animated: true)
        
    }
    
    func displaySignUp() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let signUpVC = sb.instantiateViewControllerWithIdentifier("SignUpVC") as! SignupTableViewController
        
        
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        self.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.PasswordForgotten, PFLogInFields.SignUpButton]
    }
    
    
}
