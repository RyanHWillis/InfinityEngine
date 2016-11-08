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
        self.testCollectionView.register(UINib(nibName: "TestCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TestCollectionViewCell")
        self.startInfinity()
    }
    
    private func startInfinity() {
        let infinityView = InfinityCollectionView(collectionView: self.testCollectionView, loadingHeight: 50.0, dataSource: self)
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

extension TestCollectionViewController: InfinityCollectable {
    func infinity(_ collectionView: UICollectionView, withDataForPage page: Int, forSession session: String, completion: @escaping (ResponsePayload) -> ()) {
        delay(1.0) { 
            completion(ResponsePayload(count: [10, 5, 3 * page * page], lastPage: false, session: session))
        }
    }
    func infinity(_ collectionView: UICollectionView, withCellItemForIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        return self.testCollectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as! TestCollectionViewCell
    }
    func infinity(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
    }
}

class NewCollectionViewEngine: CollectionViewEngine {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
    }
}
