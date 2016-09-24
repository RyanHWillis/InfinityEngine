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
        super.init(nibName: "TestCollectionViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cells = InfinityCells(cellNames: ["TestCollectionViewCell"], loadingCellName: "LoadingCollectionViewCell", bundle: nil)
        let infinityView = InfinityCollectionView(withCollectionView: self.testCollectionView, withCells: cells, withDataSource: self)
        self.customCollectionView = NewCollectionViewEngine(infinityCollectionView: infinityView)
        self.startInfinityCollectionView(infinityCollectionView: infinityView)
    }
    
    func createCollecionViewEngine(_ infinityCollectionView: InfinityCollectionView) -> CollectionViewEngine {
        return self.customCollectionView
    }
    
    @IBAction func reset() {
        self.resetInfinityCollection()
    }
}

extension TestCollectionViewController: InfinityCollectionProtocol {
    
    
    func collectionView(_ collectionView: UICollectionView, withDataForPage page: Int, forSession session: String, completion: (ResponsePayload) -> ()) {
        completion(ResponsePayload(count: [10, 5, 3 * page * page], lastPage: false, session: session))
    }

    
    func collectionView(_ collectionView: UICollectionView, withCellItemForIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        return self.testCollectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as! TestCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, withLoadingCellItemForIndexPath indexPath: IndexPath, forLastPageHit hit: Bool) -> UICollectionReusableView {
        let cell = self.testCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "LoadingCollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
    }
}

class NewCollectionViewEngine: CollectionViewEngine {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
