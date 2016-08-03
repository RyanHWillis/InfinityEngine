//
//  TestTableViewCell.swift
//  InfintyEngineV2
//
//  Created by Ryan Willis on 26/04/2016.
//  Copyright © 2016 RyanWillis. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var placeholderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
        // Configure the view for the selected state
    }
    
    func showPlaceholder() {
        self.placeholderView.hidden = false
        UIView.animateWithDuration(0.3) {
            self.placeholderView.alpha = 1.0
        }
    }
    
    func hidePlaceholder() {
        UIView.animateWithDuration(0.3, animations: {
            self.placeholderView.alpha = 0.0
        }) { (complete) in
            self.placeholderView.hidden = true
        }
    }
    
}
