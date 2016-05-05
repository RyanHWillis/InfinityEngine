//
//  TestCollectionViewController.swift
//  InfintyEngineV2
//
//  Created by Ryan Willis on 23/04/2016.
//  Copyright © 2016 RyanWillis. All rights reserved.
//

import UIKit
import InfinityEngine

class TestCollectionViewController: UIViewController, InfinityCollectionViewDelegate {
    
    @IBOutlet weak var testCollectionView: UICollectionView!
    
    init() {
        super.init(nibName: "TestCollectionViewController", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionView:InfinityCollectionView = InfinityCollectionView(collectionView: self.testCollectionView, collectionViewCellNibNames: ["TestCollectionViewCell"], collectionViewLoadingCellINibName: "LoadingCollectionViewCell")
        
        startInfinityCollectionView(infinityCollectionView: collectionView,
                                    withDelegate: self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        cleanUp()
    }
    
    //MARK - Infinty Delegates
    
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
    
    func infinityDidSelectItemAtIndexPath(indexPath: NSIndexPath) {
        
    }
    
    func infinityData(atPage page: Int, withModifiers modifiers: InfinityModifers, forSession sessionID:String, completion: (responsePayload: ResponsePayload) -> ()) {
        
        let data:String = "test"
        var datas:[AnyObject] = [AnyObject]()
        
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)

        
        //delay(3.0) {
        completion(responsePayload: ResponsePayload(data: datas, count: 10, lastPage: false, perPage: 10, total: 10, page: page, session: sessionID))
        //}
    }
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}