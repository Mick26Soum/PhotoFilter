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
	
	//set view controller as delegate and datasource

	@IBOutlet weak var timeTable: UITableView!

	var Posts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
			
			timeTable.dataSource = self
			timeTable.delegate = self
			
			let query = PFQuery(className: "Post")
			
			query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
				if let error = error {
					println(error.localizedDescription)
				} else if let posts = results as? [PFObject] {
				self.Posts = posts
				self.timeTable.reloadData()
				}
			}
			
    }

}

//MARK: UITableViewDatasource,UITableViewDelegat
extension TimeLineViewController: UITableViewDataSource, UITableViewDelegate{
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return Posts.count
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		var cell = tableView.dequeueReusableCellWithIdentifier("timeLineCell", forIndexPath: indexPath) as! TimeViewCell
	
		
		//get index of cell
		var Post = Posts[indexPath.row]
	
		if let imageFile = Post["image"] as? PFFile{
			imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
				if let error = error{
					println(error.localizedDescription)
				}
					if let data = data,
						image = UIImage(data: data){
							cell.timeLineUIImage.image = image
					}
			})
		}
		
		return cell
		
	}
	
}
