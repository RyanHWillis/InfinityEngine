//
//  TestCollectionViewController.swift
//  InfintyEngineV2
//
//  Created by Ryan Willis on 23/04/2016.
//  Copyright © 2016 RyanWillis. All rights reserved.
//

import UIKit
import InfinityEngine

class TestCollectionViewController: UIViewController {
    
    @IBOutlet weak var testCollectionView: UICollectionView!
    var count = 0
    
    init() {
        super.init(nibName: "TestCollectionViewController", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cells:InfinityCells = InfinityCells(cellNames: ["TestCollectionViewCell"], loadingCellName: "LoadingCollectionViewCell", customBundle: nil)
        let infinityView:InfinityCollectionView = InfinityCollectionView(withCollectionView: self.testCollectionView, withCells: cells, withDelegate: self)
        startInfinityCollectionView(infinityCollectionView: infinityView)
    }

    @IBAction func reset(sender: AnyObject) {
        resetInfinityCollection()        
    }
}

extension TestCollectionViewController: InfinityCollectionViewDelegate {
    func infinityCellItemForIndexPath(indexPath: NSIndexPath, placeholder: Bool) -> UICollectionViewCell {
        let cell = self.testCollectionView.dequeueReusableCellWithReuseIdentifier("TestCollectionViewCell", forIndexPath: indexPath) as! TestCollectionViewCell
        if placeholder == true {
            cell.title.text = String(indexPath.row) + " Placeholder"
        } else {
            cell.title.text = String(indexPath.row) + " Live"
        }
        
        return cell
    }
    
    func infinityLoadingReusableView(indexPath: NSIndexPath, lastPageHit: Bool) -> UICollectionReusableView {
        let cell = self.testCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter,
                                                                                  withReuseIdentifier: "LoadingCollectionViewCell", forIndexPath: indexPath)
        return cell
    }
    
    func infinityData(atPage page: Int, withModifiers modifiers: InfinityModifers, forSession session:String, completion: (responsePayload: ResponsePayload) -> ()) {
        
        if page == 1 {
            count = 0
        }
        count = count + 1
        
        var bool = false
        if count == 4 {
            bool = true
        }
        
        delay(1.0) { // < Simulates Delay we would expect from an API
            completion(responsePayload: ResponsePayload(count: 10, lastPage: bool, session: session))
        }
    }
}

