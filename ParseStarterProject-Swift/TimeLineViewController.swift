//
//  TimeLineViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Mick Soumphonphakdy on 8/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TimeLineViewController: UIViewController {
	
	@IBOutlet weak var ImageView: UIImageView!
	
	
	var Posts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
			
			let query = PFQuery(className: "Post")
			
			query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
				if let error = error {
					println(error.localizedDescription)
				} else if let posts = results as? [PFObject] {
				self.Posts = posts
				}
			}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//MARK: UITableViewDatasource,UITableViewDelegat
extension TimeLineViewController: UITableViewDataSource, UITableViewDelegate{
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return Posts.count
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		var cell = tableView.dequeueReusableCellWithIdentifier("thumbNail", forIndexPath: indexPath) as!UITableViewCell
		
		
		//get index of cell
		var Post = Posts[indexPath.row]
		
		if let imageFile = Post["image"] as? PFFile {
				imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
					if let error = error {
						println(error.localizedDescription)
					} else if let data = data,
						image = UIImage(data: data){
							cell.imageView?.image image 
							})
					}
				})
		
		return cell
		
	}
	
}
