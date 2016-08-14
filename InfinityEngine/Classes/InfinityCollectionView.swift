// InfinityEngine
//
// Copyright Ryan Willis (c) 2016
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/**
 Defines a struct used when incoporating an InfinteCollectionView.
 
 - parameter collectionView:                Reference to a UICollectionView, whether it be an Object or IBOutlet reference.
 - parameter cells:                     Will need to define the name of your cells, loading cel and bundle id.
 - parameter modifiers:                     See InfinityModiers - modifiers the behavior of InfinityEngine,
                                            in reference to a UICollectionView.
 */

public struct InfinityCollectionView {
    let collectionView: UICollectionView
    let cells: InfinityCells
    let delegate: InfinityCollectionSourceable
    let modifiers: InfinityModifers!
    
    public init(withCollectionView collectionView: UICollectionView, withCells cells:InfinityCells,
        withDelegate delegate: InfinityCollectionSourceable,
        withModifiers modifiers: InfinityModifers? = InfinityModifers()) {
        
        self.collectionView = collectionView
        self.cells = cells
        self.delegate = delegate
        self.modifiers = modifiers
    }
}

/**
 Defines a Protocol to be Implemented on a UIViewControl
 
 - func infinityCellItemForIndexPath:       Used to return the the corect cell in either placeholder, or live data state.
 - func infinityLoadingReusableView:        Used to return the desired loading cell you would like to appear at the bottom of the pages InfinityTableView.
 */

public protocol InfinityCollectionSourceable: InfinityDataSource, InfinityCollectionViewProtocolOptional {
    func collectionView(collectionView:UICollectionView, withDataForPage page:Int, forSession session:String, completion: (responsePayload: ResponsePayload) -> ())
    func collectionView(collectionView:UICollectionView, withCellItemForIndexPath indexPath:NSIndexPath) -> InfinityCollectionViewCell
    func collectionView(collectionView:UICollectionView, withLoadingCellItemForIndexPath indexPath:NSIndexPath,
        forLastPageHit hit:Bool) -> UICollectionReusableView
}

@objc public protocol InfinityCollectionViewProtocolOptional: class {
    optional func collectionView(collectionView:UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    optional func collectionView(collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForLoadingItemAtIndexPath section:Int) -> CGSize
}

/**
 Defines an extension to be Implemented on a UIViewController

 - func startInfinityCollectionView:        Used to start the InfinityTableView session.
 - func resetInfinityCollection:            Used to reset/restart the InfinityTableView session.
 */


public protocol InfinityCollectionProtocol: InfinityCollectionSourceable {
    func startInfinityCollectionView(infinityCollectionView infinityCollectionView:InfinityCollectionView)
    func createCollecionViewEngine(infinityCollectionView: InfinityCollectionView) -> CollectionViewEngine
    func resetInfinityCollection(withCustomCollectionEngine engine:CollectionViewEngine?)
}


extension InfinityCollectionProtocol where Self: UIViewController {
    public func startInfinityCollectionView(infinityCollectionView infinityCollection:InfinityCollectionView) {
        InfinityEngineRoom.sharedCollectionInstances.append(CollectionViewEngine(infinityCollectionView: infinityCollection))
    }
    
    public func createCollecionViewEngine(infinityCollectionView: InfinityCollectionView) -> CollectionViewEngine {
        return CollectionViewEngine(infinityCollectionView: infinityCollectionView)
    }
    
    public func resetInfinityCollection(withCustomCollectionEngine engine:CollectionViewEngine?) {
        for collectionInstance in InfinityEngineRoom.sharedCollectionInstances {
            collectionInstance.engine.resetData()
            collectionInstance.initiateEngine()
        }
    }
}

/**
 Defines an extension to be Implemented on a UIView
 
 - func startInfinityCollectionView:        Used to start the InfinityTableView session.
 - func resetInfinityCollection:            Used to reset/restart the InfinityTableView session.
 */


extension InfinityCollectionProtocol where Self: UIView {
    public func startInfinityCollectionView(infinityCollectionView infinityCollection:InfinityCollectionView) {
        InfinityEngineRoom.sharedCollectionInstances.append(CollectionViewEngine(infinityCollectionView: infinityCollection))
    }
    
    public func createCollecionViewEngine(infinityCollectionView: InfinityCollectionView) -> CollectionViewEngine {
        return CollectionViewEngine(infinityCollectionView: infinityCollectionView)
    }
    
    public func resetInfinityCollection(withCustomCollectionEngine engine:CollectionViewEngine?) {
        for collectionInstance in InfinityEngineRoom.sharedCollectionInstances {
            collectionInstance.engine.resetData()
            collectionInstance.initiateEngine()
        }
    }
}