//
//  ScannerViewController.swift
//  appollo-ios
//
//  Created by Student on 10/20/15.
//  Copyright © 2015 Appollo. All rights reserved.
//
// http://stackoverflow.com/questions/31149028/tesseract-in-ios-swift-how-to-separate-text-and-numbers-in-uitextfield

import UIKit
import TesseractOCR

private let language = "eng"

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    
    @IBOutlet weak var productView: UILabel!
    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageToRecognize: UIImageView!
    
    var operationQueue: NSOperationQueue?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        operationQueue = NSOperationQueue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func beginScanPushed(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            
            imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imgPicker, animated: true, completion: nil)
        } else {
            self.recognizeImage(UIImage(named: "etiqueta2")!)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.recognizeImage(image)
    }
    
    func recognizeImage(image: UIImage) {
        // Preprocess the image so Tesseract's recognition will be more accurate
        let scaledImage = image // scaleImage(image, maxDimension: 640)
        let bwImage: UIImage = scaledImage.g8_blackAndWhite()
        
        // Animate a progress activity indicator
        self.activityIndicator.startAnimating()
        
        // Display the preprocessed image to be recognized in the view
        self.imageToRecognize.image = bwImage;
        
        // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
        // It is assumed that there is a .traineddata file for the language pack
        // you want Tesseract to use in the "tessdata" folder in the root of the
        // project AND that the "tessdata" folder is a referenced folder and NOT
        // a symbolic group in your project
        let operation = G8RecognitionOperation(language: language)
        
        // Use the original Tesseract engine mode in performing the recognition
        // (see G8Constants.h) for other engine mode options
        operation.tesseract.engineMode = G8OCREngineMode.TesseractCubeCombined;
        
        // Let Tesseract automatically segment the page into blocks of text
        // based on its analysis (see G8Constants.h) for other page segmentation
        // mode options
        operation.tesseract.pageSegmentationMode = G8PageSegmentationMode.AutoOnly;
        
        // Optionally limit the time Tesseract should spend performing the
        // recognition
        //operation.tesseract.maximumRecognitionTime = 1.0;
        
        // Set the delegate for the recognition to be this class
        // (see `progressImageRecognitionForTesseract` and
        // `shouldCancelImageRecognitionForTesseract` methods below)
        operation.delegate = self;
        
        // Optionally limit Tesseract's recognition to the following whitelist
        // and blacklist of characters
        //operation.tesseract.charWhitelist = @"01234";
        //operation.tesseract.charBlacklist = @"56789";
        
        // Set the image on which Tesseract should perform recognition
        operation.tesseract.image = bwImage;
        
        // Optionally limit the region in the image on which Tesseract should
        // perform recognition to a rectangle
        //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
        
        operation.recognitionCompleteBlock = { (tesseract: G8Tesseract!) -> Void in
            let recognizedText = tesseract.recognizedText
            
            print(recognizedText);
            
            self.activityIndicator.stopAnimating()
            
            self.productView.text = recognizedText
        }
        
        // Finally, add the recognition operation to the queue
        self.operationQueue?.addOperation(operation)
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false
    }
    
    func progressImageRecognitionForTesseract(tesseract: G8Tesseract!) {
        
        // do nothing
    }
    
    func preprocessedImageForTesseract(tesseract: G8Tesseract!, sourceImage: UIImage!) -> UIImage! {
        
        return sourceImage
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
