//
//  HistoryTableViewCell.swift
//  appollo-ios
//
//  Created by Student on 10/28/15.
//  Copyright © 2015 Appollo. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    var item: ShoppingCart!
    
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(item: ShoppingCart) {
        self.item = item
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        
        date.text = formatter.stringFromDate(item.dateCreated)
        place.text = item.local
    }

}
