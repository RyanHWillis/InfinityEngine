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
}

extension TestCollectionViewController: InfinityCollectionProtocol {
    
    func collectionView(collectionView: UICollectionView, withDataForPage page: Int, forSession session: String, completion: (responsePayload: ResponsePayload) -> ()) {
        delay(1.0) { // < Simulates Delay we would expect from an API
            completion(responsePayload: ResponsePayload(count: [10, 5, 3], lastPage: false, session: session))
        }
        print(page)
    }
    
    func collectionView(collectionView: UICollectionView, withCellItemForIndexPath indexPath: NSIndexPath) -> InfinityCollectionViewCell {
        return self.testCollectionView.dequeueReusableCellWithReuseIdentifier("TestCollectionViewCell", forIndexPath: indexPath) as! TestCollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, withLoadingCellItemForIndexPath indexPath: NSIndexPath, forLastPageHit hit: Bool) -> UICollectionReusableView {
        let cell = self.testCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "LoadingCollectionViewCell", forIndexPath: indexPath)
        return cell
    }
}

//class NewTableViewEngine: TableViewEngine {
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("test")
//    }
//}