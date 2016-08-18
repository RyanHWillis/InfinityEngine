//
//  InfinityTableViewCell.swift
//  Pods
//
//  Created by Ryan Willis on 08/08/2016.
//
//

import UIKit

public protocol InfinityCellManualPlaceholdable {

    //MARK: - Implementation
    
    func showPlaceholder()
    
    func hidePlaceholder()
}

public protocol InfinityCellViewAutoPlaceholdable {
    
    var placeholderView: UIView { get }
}
