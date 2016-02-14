//
//  ChooseTableViewController.swift
//  Subliminal
//
//  Created by Unis Barakat on 2/13/16.
//  Copyright © 2016 Unis Barakat. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ChooseTableViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchString = ""
    var searchInProgress = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.parseClassName = "User"
        self.textKey = "username"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 25
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFUser.query()
        query!.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
        query!.whereKey("type", notEqualTo: PFUser.currentUser()!["type"]!)

        
        if searchInProgress {
            query!.whereKey("username", containsString: searchString)
        }
        
        if self.objects!.count == 0 {
            query?.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query!.orderByAscending("username")
        
        return query!
        

    }
    
 
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        searchInProgress = true
        self.loadObjects()
        searchInProgress = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if PFUser.currentUser() != nil {
            let user1 = PFUser.currentUser()
            let user2 = self.objects![indexPath.row] as! PFUser
            
            var room = PFObject(className: "Room")
            
            // Setup the MessageViewController
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let messagesVC = sb.instantiateViewControllerWithIdentifier("MessagesViewController") as! MessagesViewController
            
            
            let pred = NSPredicate(format: "user1 = %@ AND user2 = %@ OR user1 = %@ AND user2 = %@", user1!,user2,user2,user1!)
            
            let roomQuery = PFQuery(className: "Room", predicate: pred)
            
            roomQuery.findObjectsInBackgroundWithBlock({ (results , error:NSError?) -> Void in
                if error == nil {
                    if results!.count > 0 { // room already existing
                        room = results!.last!
                        // Setup MessageViewController and Push to the MessageVC
                        messagesVC.room = room
                        messagesVC.incomingUser = user2
                        self.navigationController?.pushViewController(messagesVC, animated: true)
                        
                    }else{ // create a new room
                        room["user1"] = user1
                        room["user2"] = user2
                        
                        room.saveInBackgroundWithBlock({ (success, error:NSError?) -> Void in
                            if error == nil {
                                // Setup MessageViewController and Push to the MessageVC
                                messagesVC.room = room
                                messagesVC.incomingUser = user2
                                self.navigationController?.pushViewController(messagesVC, animated: true)
                            }
                        })
                    }
                }
            })
            
            
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
