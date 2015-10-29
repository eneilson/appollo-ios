//
//  UIImage+Resize.swift
//  appollo-ios
//
//  Created by Student on 10/29/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation

extension UIImage {
	
	func resizedImageToSize(_dstSize: CGSize) -> UIImage? {
		
		var dstSize = _dstSize
		let imgRef: CGImageRef = self.CGImage!
		let srcSize: CGSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))
		if CGSizeEqualToSize(srcSize, dstSize) {
			return self
		}
		let scaleRatio: CGFloat = dstSize.width / srcSize.width
		let orient: UIImageOrientation = self.imageOrientation
		var transform: CGAffineTransform = CGAffineTransformIdentity
		switch orient {
		case .Up:
			transform = CGAffineTransformIdentity
		case .UpMirrored:
			transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0)
			transform = CGAffineTransformScale(transform, -1.0, 1.0)
		case .Down:
			transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height)
			transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
		case .DownMirrored:
			transform = CGAffineTransformMakeTranslation(0.0, srcSize.height)
			transform = CGAffineTransformScale(transform, 1.0, -1.0)
		case .LeftMirrored:
			dstSize = CGSizeMake(dstSize.height, dstSize.width)
			transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width)
			transform = CGAffineTransformScale(transform, -1.0, 1.0)
			transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI_2))
		case .Left:
			dstSize = CGSizeMake(dstSize.height, dstSize.width)
			transform = CGAffineTransformMakeTranslation(0.0, srcSize.width)
			transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI_2))
		case .RightMirrored:
			dstSize = CGSizeMake(dstSize.height, dstSize.width)
			transform = CGAffineTransformMakeScale(-1.0, 1.0)
			transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
		case .Right:
			dstSize = CGSizeMake(dstSize.height, dstSize.width)
			transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0)
			transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
		}
		UIGraphicsBeginImageContextWithOptions(dstSize, false, self.scale)
		let ctx: CGContextRef? = UIGraphicsGetCurrentContext()
		if ctx == nil {
			return nil
		}
		let context = ctx!
		if orient == UIImageOrientation.Right || orient == UIImageOrientation.Left {
			CGContextScaleCTM(context, -scaleRatio, scaleRatio)
			CGContextTranslateCTM(context, -srcSize.height, 0)
		}
		else {
			CGContextScaleCTM(context, scaleRatio, -scaleRatio)
			CGContextTranslateCTM(context, 0, -srcSize.height)
		}
		CGContextConcatCTM(context, transform)
		CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef)
		let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return resizedImage
	}
	
	func resizedImageToFitInSize(boundingSize: CGSize, scaleIfSmaller scale: Bool) -> UIImage {
		let imgRef: CGImageRef = self.CGImage!
		let srcSize: CGSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)))
		let orient: UIImageOrientation = self.imageOrientation
		
		var boundSize = boundingSize
		switch orient {
			case .Left, .Right, .LeftMirrored, .RightMirrored:
				boundSize = CGSizeMake(boundingSize.height, boundingSize.width)
		default:
			break
		}
		
		var dstSize: CGSize
		if !scale && (srcSize.width < boundSize.width) && (srcSize.height < boundSize.height) {
			dstSize = srcSize
		}
		else {
			let wRatio: CGFloat = boundSize.width / srcSize.width
			let hRatio: CGFloat = boundSize.height / srcSize.height
			if wRatio < hRatio {
				dstSize = CGSizeMake(boundSize.width, CGFloat(srcSize.height * wRatio))
			}
			else {
				dstSize = CGSizeMake(CGFloat(srcSize.width * hRatio), boundSize.height)
			}
		}
		return self.resizedImageToSize(dstSize)!
	}
	
}
