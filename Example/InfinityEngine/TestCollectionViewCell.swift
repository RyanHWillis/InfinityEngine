//
//  TestCollectionViewCell.swift
//  InfintyEngineV2
//
//  Created by Ryan Willis on 24/04/2016.
//  Copyright © 2016 RyanWillis. All rights reserved.
//

import UIKit
import InfinityEngine

class TestCollectionViewCell: UICollectionViewCell, InfinityCellManualPlaceholdable {
    
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func showPlaceholder() {
        self.backgroundColor = UIColor.purpleColor()
    }
    
    func hidePlaceholder() {
        self.backgroundColor = UIColor.yellowColor()
    }
}
