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

	@IBOutlet weak var galleryCollectionView: UICollectionView!

	var fetchResult : PHFetchResult!
	let cellSize = CGSize(width: 100, height: 100)
	var desiredFinalImageSize : CGSize!
	var startingScale : CGFloat = 0
	var scale : CGFloat = 0
	
	weak var delegate : ImageSelectedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // gallerCollectionview delegat&datasource
				galleryCollectionView.dataSource = self
				galleryCollectionView.delegate = self
			
				fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
			
				let pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchRecognized:")
			
				galleryCollectionView.addGestureRecognizer(pinchGesture)
			
    }//end of viewDidLoad()
	
		//pinch gesture setup
		func pinchRecognized(pinch : UIPinchGestureRecognizer) {
		
		
		if pinch.state == UIGestureRecognizerState.Began {
			
			startingScale = pinch.scale
		}
		
		if pinch.state == UIGestureRecognizerState.Changed {
			
		}
		
		if pinch.state == UIGestureRecognizerState.Ended {

			scale = startingScale * pinch.scale
			let layout = galleryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
			let newSize = CGSize(width: layout.itemSize.width * scale, height: layout.itemSize.height * scale)
			
			galleryCollectionView.performBatchUpdates({ () -> Void in
				layout.itemSize = newSize
				layout.invalidateLayout()
				}, completion: nil )
		}
	}

	
}//end of GallerViewController

//MARK: UICollectionViewDataSource
extension GalleryViewController : UICollectionViewDataSource {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fetchResult.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = galleryCollectionView.dequeueReusableCellWithReuseIdentifier("galleryCell", forIndexPath: indexPath) as! ThumbnailCell
		
		if let asset = fetchResult[indexPath.row] as? PHAsset {
			PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: cellSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
				if let image = image {
					cell.thumbnailImage.image = image
				}
			}
		}
		
		return cell
	}
}

extension GalleryViewController : UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		
		let options = PHImageRequestOptions()
		options.synchronous = true
		
		if let asset = fetchResult[indexPath.row] as? PHAsset {
			PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: desiredFinalImageSize, contentMode: PHImageContentMode.AspectFill, options: options) { (image, info) -> Void in
				
				if let image = image {
					self.delegate?.controllerDidSelectImage(image)
					self.navigationController?.popViewControllerAnimated(true)
				}
			}
		}
	}
}

