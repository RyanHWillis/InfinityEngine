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
    
    var customCollectionView: NewCollectionViewEngine!
    
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
        self.customCollectionView = NewCollectionViewEngine(infinityCollectionView: infinityView)
        self.startInfinityCollectionView(infinityCollectionView: infinityView)
    }
    
    func createCollecionViewEngine(infinityCollectionView: InfinityCollectionView) -> CollectionViewEngine {
        return self.customCollectionView
    }
    
    @IBAction func reset() {
        self.resetInfinityCollection()
    }
}

extension TestCollectionViewController: InfinityCollectionProtocol {
    
    func collectionView(collectionView: UICollectionView, withDataForPage page: Int, forSession session: String, completion: (responsePayload: ResponsePayload) -> ()) {
        delay(1.0) { // < Simulates Delay we would expect from an API
            print(page)
            completion(responsePayload: ResponsePayload(count: [10, 5, 3 * page * page], lastPage: false, session: session))
        }
    }
    
    func collectionView(collectionView: UICollectionView, withCellItemForIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.testCollectionView.dequeueReusableCellWithReuseIdentifier("TestCollectionViewCell", forIndexPath: indexPath) as! TestCollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, withLoadingCellItemForIndexPath indexPath: NSIndexPath, forLastPageHit hit: Bool) -> UICollectionReusableView {
        let cell = self.testCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "LoadingCollectionViewCell", forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

class NewCollectionViewEngine: CollectionViewEngine {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("test")
    }
}