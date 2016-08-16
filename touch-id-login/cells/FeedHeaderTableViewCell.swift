//
//  FeedHeaderTableViewCell.swift
//  
//
//  Created by Henrique Cocito on 8/13/16.
//
//

import UIKit

class FeedHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
