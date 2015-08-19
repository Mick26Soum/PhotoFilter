/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

//MARK: Constraint Buffer Constants
	let kleadImageBuffer : CGFloat = 70
	let ktopImageBuffer : CGFloat = 70
	let ktrailingImageBuffer : CGFloat = -70
	let kbottomImageBuffer : CGFloat = -120
	let kcollectionViewBuffer :CGFloat = 100
	let kThumbnailSize = CGSize(width: 100, height: 100)
	
	let kStandardConstraintMargin : CGFloat = 8
	
	let kPostImageSize = CGSize(width: 600, height: 600)

//MARK: IBOutlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var alertButton: UIButton!
	
	@IBOutlet weak var leadingImageConstraint: NSLayoutConstraint!

	@IBOutlet weak var topImageConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var trailingImageViewConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var bottomImageViewConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
	
	
//MARK: IBAction
	@IBAction func buttonPressed(sender: AnyObject) {
		
		alertController.modalPresentationStyle = UIModalPresentationStyle.Popover
		
		if let popover = alertController.popoverPresentationController {
			popover.sourceView = view
			popover.sourceRect = alertButton.frame
		}
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
//MARK: alertController init/setup
	let alertController = UIAlertController(title: "Options", message: "Please Make A Selection", preferredStyle: .ActionSheet)
	
//MARK: imagePicker init/setup
	let imagePicker : UIImagePickerController = UIImagePickerController()
	
	var filters : [(UIImage, CIContext) -> (UIImage!)] = [FilterService.sepiaImageFromOriginalImage, FilterService.instantImageFromOriginalImage,FilterService.sepiaImageFromOriginalImage, FilterService.instantImageFromOriginalImage,FilterService.sepiaImageFromOriginalImage, FilterService.instantImageFromOriginalImage, ]
	
	let context = CIContext(options: nil)
	
	var thumbnailImage:UIImage!
	
	var displayImage : UIImage! {
		didSet { //properyt observers
			imageView.image = displayImage
			thumbnailImage = ImageResizer.resizeImage(displayImage, size:kThumbnailSize)
			collectionView.reloadData()
		}
	}
	
  override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Home"
		
		//Datasource and Delegate Setup for ImagePicker and Collection View
		
		collectionView.dataSource = self
		collectionView.delegate = self
	
		imagePicker.delegate = self
		imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		
		displayImage = UIImage(named: "seattle_night.jpg")
		
		if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
			//should we put a poper over view here?
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
		
		}
		
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
			let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (alert) -> Void in
				self.imagePicker.allowsEditing = true
				self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
				self.imagePicker.cameraCaptureMode = .Photo
				self.presentViewController(self.imagePicker, animated: true, completion: nil)
			}
			alertController.addAction(cameraAction)
		}
		
		let confirmAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert) -> Void in
			self.imagePicker.allowsEditing = true
			self.presentViewController(self.imagePicker, animated: true, completion: nil)
			
		}
		
		if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
			
			let filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (alert) -> Void in
			 self.filterModeTransition()
			}
			
			alertController.addAction(filterAction)
		}
		
		let uploadAction = UIAlertAction(title: "Upload", style: UIAlertActionStyle.Default) { (alert) -> Void in
			
			let post = PFObject(className: "Post")
			post["text"] = "Static Text" //Currently statict text, normalling would as user to label the image
			
			let resizedImage = ImageResizer.resizeImage(self.imageView.image!, size:self.kPostImageSize)
			
			let data = UIImageJPEGRepresentation(resizedImage, 1.0)
			
			let file = PFFile(name: "post.jpg", data: data)
			post["image"] = file
			post.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
				
			})
		}
		
		let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (alert) -> Void in
			self.performSegueWithIdentifier("showGallery", sender: self)
		}

			//catch all addAction items
			alertController.addAction(uploadAction)
			alertController.addAction(cancelAction)
			alertController.addAction(confirmAction)
			alertController.addAction(galleryAction)
		
    }//end of viewDidLoad
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showGallery" {
			if let galleryViewController = segue.destinationViewController as? GalleryViewController {
				galleryViewController.delegate = self
				galleryViewController.desiredFinalImageSize = imageView.frame.size
			}
		}

	}
	
//MARK: Filter Function
	func filterModeTransition() {
		leadingImageConstraint.constant = kleadImageBuffer
		topImageConstraint.constant = ktopImageBuffer
		trailingImageViewConstraint.constant = ktrailingImageBuffer
		bottomImageViewConstraint.constant = kbottomImageBuffer
		collectionViewConstraint.constant = kcollectionViewBuffer
		
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
		
		let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "endFilterMode")
		navigationItem.rightBarButtonItem = doneButton
	}
	
	func endFilterMode() {
	
		leadingImageConstraint.constant = leadingImageConstraint.constant - kleadImageBuffer
		topImageConstraint.constant = topImageConstraint.constant - ktopImageBuffer
		trailingImageViewConstraint.constant = trailingImageViewConstraint.constant - ktrailingImageBuffer
		bottomImageViewConstraint.constant = bottomImageViewConstraint.constant - kbottomImageBuffer
		collectionViewConstraint.constant = collectionViewConstraint.constant - (kcollectionViewBuffer * 2)
		
		
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
		
		navigationItem.rightBarButtonItem = nil
	
	}

}

//MARK: UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		let image: UIImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
		displayImage = image
		imagePicker.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		imagePicker.dismissViewControllerAnimated(true, completion: nil)
		
	}
}

//MARK: UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filters.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! ThumbnailCell
		
		let filter = filters[indexPath.row]
		let filteredImage = filter(thumbnailImage,context)
		cell.thumbnailImage.image = filteredImage
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
		var cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
		let filter = filters[indexPath.row]
		let mainImageFiltered = filter(imageView.image!, context)
		self.displayImage = mainImageFiltered
//	self.imageView.image = mainImageFiltered
	}
}

//MARK: GalleryView Controller Delegate Set Up
extension ViewController : ImageSelectedDelegate {
	func controllerDidSelectImage(newImage: UIImage) {
		displayImage = newImage
	}
}







