//
//  SignupViewController.swift
//  Subliminal
//
//  Created by Unis Barakat on 2/13/16.
//  Copyright © 2016 Unis Barakat. All rights reserved.
//

import UIKit
import Parse
import ParseUI

//var moodsArray: [Int] = [Int]()
//var moodObjects = [PFObject]()


class SignupTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBAction func userType(sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            type = 1
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            type = 2
            
        }
    }
    
    var change = false
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
        
        if change {
            doneBarButtonItem.action = "changeProfile"
            
            usernameTextField.text = PFUser.currentUser()!.username
            emailTextField.text = PFUser.currentUser()!.email
            firstNameTextField.text = PFUser.currentUser()!["firstName"] as? String
            lastNameTextField.text = PFUser.currentUser()!["lastName"] as? String
            
            passwordTextField.enabled = false
            repeatPasswordTextField.enabled = false
            
            let profileImageFile = PFUser.currentUser()!["profileImage"] as! PFFile
            
            profileImageFile.getDataInBackgroundWithBlock({ (data , error:NSError?) -> Void in
                if error == nil {
                    self.profileImageView.image = UIImage(data: data!)
                }
            })
            
        }
        
    }
    
    
    
    
    @IBAction func addProfileImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Choose your image source", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera Roll", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageSize = image.size
        let width = imageSize.width
        let height = imageSize.height
        
        
        if width != height {
            let newDimensions = min(width,height)
            let widthOffset = (width - newDimensions) / 2
            let heightOffset = (height - newDimensions) / 2
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimensions, newDimensions), false, 0.0)
            image.drawAtPoint(CGPointMake(-widthOffset, -heightOffset), blendMode: CGBlendMode.Copy , alpha: 1.0)
            
            image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
            UIGraphicsEndImageContext()
            
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(150, 150))
        
        _ = UIGraphicsGetCurrentContext()
        
        image.drawInRect(CGRectMake(0, 0, 150, 150))
        
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        
        profileImageView.image = smallImage
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func completeSignUp(sender: AnyObject) {
        let profileImageData = UIImageJPEGRepresentation(profileImageView.image!, 0.6)
        let profileImageFile = PFFile(data: profileImageData!)
        
        
        if usernameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "" && firstNameTextField.text != "" && lastNameTextField.text != "" {
            
            let user = PFUser()
            
            user.username = usernameTextField.text
            user.email = emailTextField.text
            
            if passwordTextField.text == repeatPasswordTextField.text {
                user.password = passwordTextField.text
            }else{
                let alert = UIAlertController(title: "Check your password", message: "Your entered passwords are not the same", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            
            user["firstName"] = firstNameTextField.text
            user["lastName"] = lastNameTextField.text
            user["profileImage"] = profileImageFile
            user["type"] = type
//            user["mood"] = moodsArray
            
            user.signUpInBackgroundWithBlock({ (success, error:NSError?) -> Void in
                if error == nil {
                    let installation = PFInstallation.currentInstallation()
                    installation["user"] = user
                    installation.saveInBackgroundWithBlock(nil)
                    self.showTab()
                    
                }
            })
            
            
            
        }else{
            let alert = UIAlertController(title: "Missing information", message: "Please fill out all items", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    func changeProfile () {
        let profileImageData = UIImageJPEGRepresentation(profileImageView.image!, 0.6)
        let profileImageFile = PFFile(data: profileImageData!)
        
        
        if usernameTextField.text != "" && emailTextField.text != ""  && firstNameTextField.text != "" && lastNameTextField.text != "" && type != 0 {
            
            PFUser.currentUser()!.username = usernameTextField.text
            PFUser.currentUser()!.email = emailTextField.text
            
            
            PFUser.currentUser()!["firstName"] = firstNameTextField.text
            PFUser.currentUser()!["lastName"] = lastNameTextField.text
            PFUser.currentUser()!["profileImage"] = profileImageFile
            
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (success , error:NSError?) -> Void in
                if error == nil {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
            
            
        }else{
            let alert = UIAlertController(title: "Missing information", message: "Please fill out all items", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    func showTab() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let tabVC = sb.instantiateViewControllerWithIdentifier("tabView")
        
        tabVC.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationController?.pushViewController(tabVC, animated: true)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
