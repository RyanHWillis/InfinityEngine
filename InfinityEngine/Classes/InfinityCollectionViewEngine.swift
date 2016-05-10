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
 Constructural modifers that change behavior.
 
 - Road: For streets or trails.
 - Touring: For long journeys.
 - Cruiser: For casual trips around town.
 - Hybrid: For general-purpose transportation.
 */

public final class CollectionViewEngine: NSObject {
    
    let reloadControl = UIRefreshControl()
    
    var infinitCollectionView: InfinityCollectionView!
    var engine:InfinityEngine!
    var delegate: InfinityCollectionViewDelegate!
    
    // MARK: - Lifecycle
    
    init(infinityCollectionView:InfinityCollectionView, delegate:InfinityCollectionViewDelegate) {
        super.init()
        self.infinitCollectionView = infinityCollectionView
        self.delegate = delegate
        self.engine = InfinityEngine(infinityModifiers: infinitCollectionView.modifiers, withDelegate: self)
        self.setupCollectionView()
        self.initiateEngine()
    }
    
    func setupCollectionView() {
        // Set Table View Instance With Appropriate Object
        self.infinitCollectionView.collectionView.delegate = self
        self.infinitCollectionView.collectionView.dataSource = self
        self.infinitCollectionView.collectionView.alwaysBounceVertical = true
        
        // Register All Posible Nibs
        for nibName in self.infinitCollectionView.collectionViewCellNibNames {
            self.infinitCollectionView.collectionView.registerNib(UINib(nibName: nibName, bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: nibName)
        }
        
        // Register Loading Cell
        
        let loadingCellID = self.infinitCollectionView.collectionViewLoadingCellINibName
        self.infinitCollectionView.collectionView.registerNib(UINib(nibName: loadingCellID,
            bundle: NSBundle.mainBundle()), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                            withReuseIdentifier: loadingCellID)
        
        // Refresh Control
        self.reloadControl.addTarget(self, action: #selector(CollectionViewEngine.reloadFromRefreshControl), forControlEvents: UIControlEvents.ValueChanged)
        self.infinitCollectionView.collectionView.addSubview(self.reloadControl)
    }
    
    func initiateEngine() {
        delay(0.3) {
            self.engine.performDataFetch()
        }
    }
    
    func reloadFromRefreshControl() {
        self.engine.resetData()
        self.engine.performDataFetch()
    }
    
    func reloadCollectionView(indexes:[NSIndexPath]?) {
        self.infinitCollectionView.collectionView.reloadData()
    }
}

extension CollectionViewEngine: InfinityDataEngineDelegate {
    
    func getData(atPage page: Int, withModifiers modifiers: InfinityModifers, completion: (responsePayload: ResponsePayload) -> ()) {
        self.delegate.infinityData(atPage: page, withModifiers: modifiers, forSession: self.engine.sessionID) { (responsePayload) in
            
            if self.engine.responseIsValid(atPage: page, withReloadControl: self.reloadControl, withResponsePayload: responsePayload) == true {
                completion(responsePayload: responsePayload)
            }
        }
    }
    
    func dataDidRespond(withData data: [AnyObject]) {
        self.delegate.infinintyDataResponse?(withData: data)
    }
    
    func buildIndexsForInsert(dataCount count: Int) -> [NSIndexPath] {
        var indexs = [NSIndexPath]()
        
        let numbObj:Int = count - 1
        
        for index in (self.engine.dataCount())...(self.engine.dataCount() + numbObj) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            indexs.append(indexPath)
        }
        
        return indexs
    }
    
    func dataEngine(responsePayload payload: ResponsePayload, withIndexPaths indexPaths: [NSIndexPath]?) {
        
        // If there are no indexes, prepare for force refresh
        guard let indexs = indexPaths else {
            self.engine.data = self.engine.dataFactory(payload)
            return
        }
        
        let indexPathTuple = self.engine.splitIndexPaths(indexs)

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.infinitCollectionView.collectionView.performBatchUpdates({ () -> Void in
                self.engine.data = self.engine.dataFactory(payload)
                self.infinitCollectionView.collectionView.reloadItemsAtIndexPaths(indexPathTuple.reloadIndexPaths)
                self.infinitCollectionView.collectionView.insertItemsAtIndexPaths(indexPathTuple.insertIndexPaths)
                }, completion: nil)
        })
    }
    
    func updateControllerView(atIndexes indexes: [NSIndexPath]?) {
        guard let _ = indexes else {
            self.infinitCollectionView.collectionView.reloadData()
            return
        }
        
        if self.engine.modifiers.forceReload == true {
            self.infinitCollectionView.collectionView.reloadData()
        }
    }
}

extension CollectionViewEngine: UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.engine.dataCount() == 0 {
            return kPlaceHolderCellCount
        } else {
            return self.engine.dataCount()
        }
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Calculate if we are used force reload
        if self.engine.modifiers.infiniteScroll == true {
            self.engine.infinteScrollMonitor(indexPath)
        }
        
        if self.engine.page == 1 {
            return self.delegate.infinityCellItemForIndexPath(indexPath, placeholder: true)
        } else {
            return self.delegate.infinityCellItemForIndexPath(indexPath, placeholder: false)
        }
    }
}

extension CollectionViewEngine: UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate.infinityDidSelectItemAtIndexPath(indexPath)
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            return self.delegate.infinityLoadingReusableView(indexPath, lastPageHit: self.engine.lastPageHit)
        } else {
            return UICollectionReusableView()
        }
    }    
}

extension CollectionViewEngine: UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if let layout = self.delegate.infinity?(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: section) {
            return layout
        } else {
            return UIEdgeInsetsMake(4, 4, 4, 4)
        }
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if let layout = self.delegate.infinity?(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAtIndex: section) {
            return layout
        } else {
            return 4
        }
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if let layout = self.delegate.infinity?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAtIndex: section) {
            return layout
        } else {
            return 4
        }
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.size.width, height: kLoadingCellHeight)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if let layout = self.delegate.infinity?(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath) {
            return layout
        } else {
            return CGSize(width: UIScreen.mainScreen().bounds.size.width - CGFloat(10.0), height: 30.0)
        }
    }
}

