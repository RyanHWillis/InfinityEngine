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
 - parameter collectionViewCells:           Will need to define the name of your cells and id.
 - parameter modifiers:                     See InfinityModiers - modifiers the behavior of InfinityEngine,
                                            in reference to a UICollectionView.
 */

public struct InfinityCollectionView {
    let collectionView: UICollectionView!
    let collectionViewCellNibNames: [String]!
    let collectionViewLoadingCellINibName: String!
    let modifiers: InfinityModifers!
    
    public init(collectionView: UICollectionView, collectionViewCellNibNames: [String], collectionViewLoadingCellINibName: String,
                modifiers: InfinityModifers? = InfinityModifers()) {
        
        self.collectionView = collectionView
        self.collectionViewCellNibNames = collectionViewCellNibNames
        self.collectionViewLoadingCellINibName = collectionViewLoadingCellINibName
        self.modifiers = modifiers
    }
}

/**
 Defines a Protocol to be Implemented on a UIViewControl
 
 - func infinityCellItemForIndexPath:       Used to return the the corect cell in either placeholder, or live data state.
 - func infinityLoadingReusableView:        Used to return the desired loading cell you would like to appear at the bottom of the pages InfinityTableView.
 */

public protocol InfinityCollectionViewDelegate: InfinityDataSource, InfinityCollectionViewProtocolOptional {
    func infinityCellItemForIndexPath(indexPath: NSIndexPath, placeholder:Bool) -> UICollectionViewCell
    func infinityLoadingReusableView(indexPath: NSIndexPath, lastPageHit:Bool) -> UICollectionReusableView
}

/**
 Defines an Optional Protocol Used to set the layout of your InfnityCollectionView cells.
 */

@objc public protocol InfinityCollectionViewProtocolOptional: class {
    optional func infinityDidSelectItemAtIndexPath(indexPath: NSIndexPath)
    optional func infinity(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    optional func infinity(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    optional func infinity(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    optional func infinity(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    optional func infinity(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForLoadingItemAtIndexPath section: Int) -> CGSize
}

/**
 Defines an extension to be Implemented on a UIViewController

 - func startInfinityCollectionView:        Used to start the InfinityTableView session.
 - func resetInfinityCollection:            Used to reset/restart the InfinityTableView session.
 */


extension InfinityCollectionViewDelegate where Self: UIViewController {
    public func startInfinityCollectionView(infinityCollectionView infinityCollection:InfinityCollectionView, withDelegate: InfinityCollectionViewDelegate) {
        InfinityEngineRoom.sharedCollectionInstances.append(CollectionViewEngine(infinityCollectionView: infinityCollection, delegate: withDelegate))
    }
    
    public func resetInfinityCollection() {
        
        for collectionInstance in InfinityEngineRoom.sharedCollectionInstances {
            collectionInstance.engine.resetData()
            collectionInstance.initiateEngine()
        }
    }
}