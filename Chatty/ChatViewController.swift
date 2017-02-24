//
//  ChatViewController.swift
//  Chatty
//
//  Created by Cong Tam Quang Hoang on 23/02/17.
//  Copyright © 2017 Cong Tam Quang Hoang. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    var messageDict: [PFObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var query = PFQuery(className:"Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    self.messageDict = objects
                }
            } else {
                // Log details of the failure
                print("error")
            }
           
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: "onTimer", userInfo: nil, repeats: true)
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDict.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messageDict[indexPath.row]["text"] as! String
        if let user = messageDict[indexPath.row]["user"] as? PFUser{
            let username = user.username
            cell.usernameLabel.text = username
        }
        cell.messageLabel.text = message
        
        return cell
    }
    
    func onTimer() {
        var query = PFQuery(className:"Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
                if let objects = objects {
                    self.messageDict = objects
                }
            } else {
                // Log details of the failure
                print("error")
            }
            self.tableView.reloadData()
            
        }
    }
    
    @IBAction func newMessage(_ sender: UIButton) {
        var newmessage = PFObject(className:"Message")
        
        newmessage["text"] = messageField.text
        newmessage["user"] = PFUser.current()
        
        
        newmessage.saveInBackground { (success: Bool, error: Error?) in
            if (success) {
                print("messaged")
                self.messageDict.insert(newmessage, at: 0)
                self.tableView.reloadData()
            } else {
                // There was a problem, check error.description
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
