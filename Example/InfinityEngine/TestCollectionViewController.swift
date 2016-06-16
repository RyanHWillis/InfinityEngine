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
    
    var count = 0
    
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
    }

    @IBAction func reset(sender: AnyObject) {
        count = 0
        resetInfinityCollection()        
    }
    
    //MARK - Infinty Delegates
    
    func infinintyDataResponse(withData data: [AnyObject]?) {
        
//        init(infiniteScroll infinite: Bool! = true, forceReload force: Bool! = false,
//                            indexedBy type: IndexType = .Row, uriSuffix suffix: String? = nil,
//                                      requestParamters params: [String : AnyObject]? = nil) {
        
            let infinity:InfinityModifers = InfinityModifers(infiniteScroll: true, forceReload: true, indexedBy: .Row, uriSuffix: nil, requestParamters: nil)
    }
    
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
    
    func infinityData(atPage page: Int, withModifiers modifiers: InfinityModifers, forSession session:String, completion: (responsePayload: ResponsePayload) -> ()) {
        
        
        print(page)
        
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
        
        
        count = count + 1
        
        var bool = false
        if count == 4 {
            bool = true
        }
        
        print(bool)

        
        delay(1.0) {
            completion(responsePayload: ResponsePayload(data: datas, lastPage: bool, page: page, session: session))
        }
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