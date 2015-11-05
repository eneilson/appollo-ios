//
//  PriceTagViewController.swift
//  appollo-ios
//
//  Created by Student on 10/29/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation
import UIKit
import TesseractOCR
import GPUImage

public class ScannerPriceTagViewController: UIViewController {
	
	// printa no console o que esta acontecendo
	public var debug = false
	
	// o quanto de precisao na leitura
	public var accuracy: Float = 1
	
	// view que ira conter a imagem com os filtros aplicados
	@IBOutlet var filterView: GPUImageView!
	
	@IBOutlet weak var finalImageView: UIImageView!
	// timer para tentativa de leitura da tag de preco
	var timer: NSTimer?
	
	// camera que vai aplicar os filtros de imagem
	private let videoCamera: GPUImageVideoCamera
	
	// filtros para melhorar a imagem da tag de preco
	var exposure = GPUImageExposureFilter()
	var highlightShadow = GPUImageHighlightShadowFilter()
	var saturation = GPUImageSaturationFilter()
	var contrast = GPUImageContrastFilter()
	var adaptiveTreshold = GPUImageAdaptiveThresholdFilter()
	var crop = GPUImageCropFilter()
	var averageColor = GPUImageAverageColor()
	
	// Tesseract OCR
	var tesseract: G8Tesseract = G8Tesseract(language: "eng+osd")
    
    var lastReadPrice: NSNumber?
    
	public required init?(coder aDecoder: NSCoder) {
		videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset1920x1080, cameraPosition: .Back)
		videoCamera.outputImageOrientation = .Portrait;
		
		tesseract.engineMode = .TesseractOnly
		super.init(coder: aDecoder)
	}
	
	public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.Portrait
	}
	
	public override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		// Filter settings
		exposure.exposure = 0.8 // -10 - 10
		highlightShadow.highlights  = 0.7 // 0 - 1
		saturation.saturation  = 0.8 // 0 - 2
		contrast.contrast = 4.0  // 0 - 4
		adaptiveTreshold.blurRadiusInPixels = 8.0
		
		// Only use this area for the OCR
		//crop.cropRegion = CGRectMake(350.0/1080.0, 110.0/1920.0, 350.0/1080, 1700.0/1920.0)
		
		// Try to dinamically optimize the exposure based on the average color
		averageColor.colorAverageProcessingFinishedBlock = {(redComponent, greenComponent, blueComponent, alphaComponent, frameTime) in
			let lighting = redComponent + greenComponent + blueComponent
			let currentExposure = self.exposure.exposure
			// The stablil color is between 2.85 and 2.91. Otherwise change the exposure
			if lighting < 2.85 {
				self.exposure.exposure = currentExposure + (2.88 - lighting) * 2
			}
			if lighting > 2.91 {
				self.exposure.exposure = currentExposure - (lighting - 2.88) * 2
			}
		}
		
		// Chaining the filters
        videoCamera.addTarget(contrast)
        contrast.addTarget(self.filterView)
		
		self.view.backgroundColor = UIColor.whiteColor()
        
        startScan()
	}
	
	public func startScan() {
		self.view.backgroundColor = UIColor.blackColor()
		
		self.videoCamera.startCameraCapture()
		self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("scan"), userInfo: nil, repeats: false)
	}
	
	/**
	call this from your code to stop a scan or hook it to a button
	
	:param: sender the sender of this event
	*/
	@IBAction public func StopScan(sender: AnyObject) {
		self.view.backgroundColor = UIColor.whiteColor()
		self.videoCamera.stopCameraCapture()
		timer?.invalidate()
		timer = nil
        self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	/**
	Perform a scan
	*/
	public func scan() {
		self.timer?.invalidate()
		self.timer = nil
		
		print("Start OCR")
		
		// Get a snapshot from this filter, should be from the next runloop
		let currentFilterConfiguration = contrast
		currentFilterConfiguration.useNextFrameForImageCapture()
		NSOperationQueue.mainQueue().addOperationWithBlock {
			let snapshot = currentFilterConfiguration.imageFromCurrentFramebuffer()
			if snapshot == nil {
				print("- Could not get snapshot from camera")
				self.startScan()
				return
			}
			
			print("- Could get snapshot from camera")
			
			var result:String?
			
			autoreleasepool {
				let cropRect:CGRect! = CGRect(x: 340,y: 250, width: 360, height: 1200)
				let imageRef:CGImageRef! = CGImageCreateWithImageInRect(snapshot.CGImage, cropRect);
				let croppedImage:UIImage = UIImage(CGImage: imageRef)
				
				// Rotate cropped image
				// TODO be smart at this point
				let selectedFilter = GPUImageTransformFilter()
				selectedFilter.setInputRotation(kGPUImageRotateRight, atIndex: 0)
				let image:UIImage = selectedFilter.imageByFilteringImage(croppedImage)

				let blackWhiteImage = self.scaleImage(image.g8_blackAndWhite(), maxDimension: 480)
				
				self.tesseract.setVariableValue("0123456789.$,", forKey: "tessedit_char_whitelist");
				self.tesseract.setVariableValue("FALSE", forKey: "x_ht_quality_check")
                
				// UIImageWriteToSavedPhotosAlbum(blackWhiteImage, nil, nil, nil)
                
				self.tesseract.image = blackWhiteImage
                self.tesseract.pageSegmentationMode = .Auto
				
				self.tesseract.maximumRecognitionTime = 1
				
				print("- Start recognize")
				self.tesseract.recognize()
				result = self.tesseract.recognizedText
                
                // UIImageWriteToSavedPhotosAlbum(self.tesseract.thresholdedImage, nil, nil, nil)
				
				G8Tesseract.clearCache()
			}
			
			// Perform OCR
			if let r = result {
				
                let str = r.stringByRemovingAllWhitespaces()
                
                print("Scanresult : \(str)")
                
                let formatter = NSNumberFormatter()
                
                if str.contains(".") {
                    formatter.decimalSeparator = "."
                } else {
                    formatter.decimalSeparator = ","
                }
                
				if let price = formatter.numberFromString(str) {
                    
                    if let lastPrice = self.lastReadPrice {
                        if price == lastPrice {
                            // 2x o mesmo preco portanto assume esse como o correto
                            self.videoCamera.stopCameraCapture()
                            
                            // dismiss
                            // notifca o controller pai que leu o preco e qual o preco lido
                            NSNotificationCenter.defaultCenter().postNotificationName(kDidReadPriceLabelNotification, object: self, userInfo: ["price": price])
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                            return
                        }
                    }
					self.lastReadPrice = price
				}
			}
			self.startScan()
			
		}
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
	
}
