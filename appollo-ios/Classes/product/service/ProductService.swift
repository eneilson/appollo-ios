//
//  ProductService.swift
//  appollo-ios
//
//  Created by Student on 11/5/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import Foundation
import Alamofire
import AVFoundation

protocol ProductDelegate {
	
	func didFoundProduct(product: Product?)
	
}

class ProductService {
	
	let apiEndpoint = "http://api.cosmos.bluesoft.com.br"
	let apiToken = "No0pBL9BWBfKl7YBjJNYjQ"
	
	var delegate: ProductDelegate!
	
	func findByBarcode(machineCode: AVMetadataMachineReadableCodeObject) {
		
		let barcode = machineCode.stringValue
	
		if let product = Product.find("barcode = %@", args: barcode) as? Product {
			delegate?.didFoundProduct(product)
		} else {
		
			let headers = [
				"X-Cosmos-Token": apiToken
			]
		
			Alamofire.request(.GET, apiEndpoint + "/gtins/" + barcode, headers: headers)
				.responseJSON { response in
				
					if response.response?.statusCode != 200 {
						self.delegate?.didFoundProduct(nil)
					}
					
					if let JSON = response.result.value as? [String: AnyObject] {
						print("JSON: \(JSON)")
						
						/*
						{
							"description":"SHAMPOO CLEAR MEN ANTICASPA ICE COOL MENTHOL 200 ML",
							"gtin":7891150007406,
							"license":"ODbL",
							"thumbnail":"https://s3.amazonaws.com/bluesoft-cosmos/products/shampoo-clear-men-anticaspa-ice-cool-menthol-200-ml_600x600-PU863a4_1.jpg",
							"gpc":{
								"code":"10000368",
								"description":"Cabelo - Xampu"
							},
							"ncm":{
								"code":"33051000",
								"description":"Xampus",
								"full_description":"Óleos essenciais e resinóides; produtos de perfumaria ou de toucador preparados e preparações cosméticas - Preparações capilares - Xampus"
							}
						}
						*/
						
						var props: [String: AnyObject] = [
							"name": JSON["description"]!,
							"barcode": barcode,
//							"itemDescription": JSON.ncm!.full_description
						]
						
						
						if let thumbnail = JSON["thumbnail"] as? String {
							
							Alamofire.request(.GET, thumbnail)
								.responseData { response in
									print(response.request)
									print(response.response)
									print(response.result)
									
//									let imageData = NSData(contentsOfURL: NSURL(string: thumbnail)!)
//									if let image = imageData {
//										props["image"] = image
//									}
									props["image"] = response.result.value
									
									let product = Product.create(properties: props) as! Product
									product.save()
									
									self.delegate.didFoundProduct(product)
							}
							
							
						} else {
						
							let product = Product.create(properties: props) as! Product
							product.save()
							self.delegate.didFoundProduct(product)
						}

					}
				
			}
		}
			
	}
	
	
}