//
//  addMoodTableView.swift
//  Subliminal
//
//  Created by Unis Barakat on 2/14/16.
//  Copyright © 2016 Unis Barakat. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class addMoodTableView: UITableViewController {
    
    @IBOutlet var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //        tbView.rowHeight = UIScreen.mainScreen().bounds.size.height / 10
        
        
        
        
        
        //        let moodQuery = PFQuery(className: "mood")
        //        moodQuery.orderByAscending("createdAt")
        //        moodQuery.includeKey("user")
        //
        //
        //        //source of khara
        //
        //        moodQuery.findObjectsInBackgroundWithBlock { (results , error:NSError?) -> Void in
        //            if error == nil {
        //                let moods = results
        //
        //                for mood in moods!{
        //                    moodsArray.append(mood.objectForKey("mood") as! Int)
        //                    moodObjects.append(mood)
        //
        //                    }
        //
        //
        //                }
        //
        //
        //            }
        //
        //
        //        print(moodsArray)
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (UIScreen.mainScreen().bounds.size.height - self.navigationController!.navigationBar.frame.size.height - UIApplication.sharedApplication().statusBarFrame.size.height - 49)  / 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("numberCell", forIndexPath: indexPath) as! moodCell
        
        cell.numberLabel.text = String(indexPath.row + 1)
        
        if indexPath.row > 7 || indexPath.row < 2{
            cell.numberLabel.backgroundColor = UIColor.redColor()
        }
        
        if indexPath.row == 5 || indexPath.row == 4{
            cell.numberLabel.backgroundColor = UIColor.greenColor()
        }
        
        
        //setText
        
        switch indexPath.row{
        case 0: cell.descriptionLabel.text = "I have a plan for committing suicide"
        case 1: cell.descriptionLabel.text = "I'm feeling extremely depressed"
        case 2: cell.descriptionLabel.text = "I'm feeling very sad"
        case 3: cell.descriptionLabel.text = "I'm feeling sad"
        case 4: cell.descriptionLabel.text = "I'm doing okay"
        case 5: cell.descriptionLabel.text = "I'm doing well"
        case 6: cell.descriptionLabel.text = "I'm feeling happy"
        case 7: cell.descriptionLabel.text = "I'm feeling very happy"
        case 8: cell.descriptionLabel.text = "I'm feeling extremely happy and energetic"
        case 9: cell.descriptionLabel.text = "I have supernatural powers and abilities"
        default: cell.descriptionLabel.text = ""
            
        }
        
        
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let mood = PFObject(className: "Mood")
        mood["user"] = PFUser.currentUser()
        mood["content"] = Double(indexPath.row + 1)
        mood["hour"] = String(NSCalendar.currentCalendar().component(.Hour , fromDate: NSDate())) + ":" + String(NSCalendar.currentCalendar().component(.Minute , fromDate: NSDate()))
        
        
        mood.saveInBackgroundWithBlock { (success:Bool!, error:NSError?) -> Void in
            if error == nil {
                
                let pushQuery = PFInstallation.query()
                
                let push = PFPush()
                push.setQuery(pushQuery)
                
                
                //                let pushDict = ["alert":text,"badge":"increment","sound":"notification.caf"]
                //
                //                push.setData(indexPath.row)
                //
                //                push.sendPushInBackgroundWithBlock(nil)
                
                
            }else{
                print("error sending mood \(error!.localizedDescription)")
            }
                        

            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}