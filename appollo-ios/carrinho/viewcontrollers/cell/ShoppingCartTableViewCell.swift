//
//  ShoppingCartTableViewCell.swift
//  appollo-ios
//
//  Created by Student on 10/23/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {

    var item: ShoppingCartItem!
    
    @IBOutlet weak var totalView: UILabel!
    @IBOutlet weak var unitPriceView: UILabel!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2
        photoImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(item: ShoppingCartItem) {
        self.item = item
        
        nameView.text = self.item.name

        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        
        let unitPriceFormatted = formatter.stringFromNumber(item.price)
        
        unitPriceView.text = "\(Int(item.quantity)) x \(unitPriceFormatted!)"
        
        totalView.text = formatter.stringFromNumber(item.total())
        
        if let photo = item.photo {
            photoImageView.image = UIImage(CGImage: photo)
        } else {
            // default image
            photoImageView.image = UIImage(named: "no-image")
        }

    }
    
}
