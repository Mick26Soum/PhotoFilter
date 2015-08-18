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
	let kbottomImageBuffer : CGFloat = 140
	let kThumbnailSize = CGSize(width: 100, height: 100)
	
	let kStandardConstraintMargin : CGFloat = 8
	
	let kPostImageSize = CGSize(width: 600, height: 600)

//MARK: IBOutlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var alertButton: UIButton!
	
	@IBOutlet weak var leadingImageViewConstraint: NSLayoutConstraint!
	@IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
	@IBOutlet weak var trailingImageViewConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomImageViewConstraint: NSLayoutConstraint!
	
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
		didSet {
			imageView.image = displayImage
			thumbnailImage = ImageResizer.resizeImage(displayImage, size:kThumbnailSize)
			collectionView.reloadData()
		}
	}
	
  override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Home"
		collectionView.dataSource = self
		imageView.image = UIImage(named: "seattle_night.jpg")
		
		//alertAction setup: 1 - Check for Device type and set action accordingly
		
		if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
			
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
			post["text"] = "SeattleNight"
			
			let resizedImage = ImageResizer.resizeImage(self.imageView.image!, size:self.kPostImageSize)
			
			let data = UIImageJPEGRepresentation(resizedImage, 1.0)
			
			let file = PFFile(name: "post.jpeg", data: data)
			post["image"] = file
			post.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
				
				})
		}

			//catch all addAction items
			alertController.addAction(uploadAction)
			alertController.addAction(cancelAction)
			alertController.addAction(confirmAction)
		
			//set up imagePicker Delegate
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		
			displayImage = UIImage(named: "seattle_night.jpg")
		
    }//end of viewDidLoad
	
//MARK: Filter Function
	func filterModeTransition() {
		leadingImageViewConstraint.constant = kleadImageBuffer
		topImageViewConstraint.constant = ktopImageBuffer
		trailingImageViewConstraint.constant = ktrailingImageBuffer
		bottomImageViewConstraint.constant = kbottomImageBuffer
		
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
		
		let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "endFilterMode")
		navigationItem.rightBarButtonItem = doneButton
	}
	
	func endFilterMode() {
	
		leadingImageViewConstraint.constant = leadingImageViewConstraint.constant - kleadImageBuffer
		topImageViewConstraint.constant = topImageViewConstraint.constant - ktopImageBuffer
		trailingImageViewConstraint.constant = trailingImageViewConstraint.constant - ktrailingImageBuffer
		bottomImageViewConstraint.constant = bottomImageViewConstraint.constant - kbottomImageBuffer
		
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
		println("Picker Cancelled")
	}
}

//MARK: UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource {
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
}

//extension ViewController : ImageSelectedDelegate {
//	func controllerDidSelectImage(newImage: UIImage) {
//		displayImage = newImage
//	}
//}






