//
//  ViewController.swift
//  CropAnImage
//
//  Created by Mavericks on 23/11/15.
//  Copyright © 2015 Mavericks. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageView : UIImageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.delegate = self
        
        imageView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)
        imageView.image = UIImage(named: "image")
        imageView.userInteractionEnabled = true
        
        scrollView.addSubview(imageView)
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imageTapped:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(recognizer: UITapGestureRecognizer){
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.contentMode = UIViewContentMode.Center
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        
        scrollView.contentSize = image.size
        
        let scrollFrame = scrollView.frame
        let scaleWidth = scrollFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollFrame.size.height / scrollView.contentSize.height
        
        let minScale = min(scaleHeight,scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cropnsave(sender: AnyObject) {
        
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.mainScreen().scale)
        let offSet = scrollView.contentOffset
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offSet.x, -offSet.y)
        
        scrollView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        
        let alert = UIAlertController(title: "Image saved", message: "Your image has been saved to your camera roll", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}

