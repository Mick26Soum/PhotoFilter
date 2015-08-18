//
//  GalleryViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Mick Soumphonphakdy on 8/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Photos

protocol ImageSelectedDelegate : class {
	func controllerDidSelectImage(UIImage) -> (Void)
}

class GalleryViewController: UIViewController {

//	var fetchResult : PHFetchResult!
//	let cellSize = CGSize(width: 100, height: 100)
	var desiredFinalImageSize : CGSize!
	var startingScale : CGFloat = 0
	var scale : CGFloat = 0
	
	weak var delegate : ImageSelectedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
