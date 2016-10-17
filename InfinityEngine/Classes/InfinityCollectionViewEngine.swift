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
 Constructs an internal NSObject, used to represent a UICollectionView into InfinityCollectionView.
 */

open class CollectionViewEngine: NSObject {
    
    var infinitCollectionView: InfinityCollectionView!
    var engine:InfinityDataEngine!
    var delegate: InfinityCollectionSourceable!
    var reloadControl:UIRefreshControl?

    // MARK: - Lifecycle
    
    public init(infinityCollectionView:InfinityCollectionView) {
        super.init()
        self.infinitCollectionView = infinityCollectionView
        self.delegate = infinityCollectionView.source
        self.engine = InfinityDataEngine(withDelegate: self)
        self.setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        // Set Table View Instance With Appropriate Object
        self.infinitCollectionView.collectionView.delegate = self
        self.infinitCollectionView.collectionView.dataSource = self
        self.infinitCollectionView.collectionView.alwaysBounceVertical = true
        
        let bundle = self.infinitCollectionView.cells.bundle ?? Bundle.main
        
        for nibName in self.infinitCollectionView.cells.cellNames {
            self.infinitCollectionView.collectionView.register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier: nibName)
        }
        
        // Register Loading Cell
        let loadingCellID = self.infinitCollectionView.cells.loadingCellName
        
        self.infinitCollectionView.collectionView.register(UINib(nibName: loadingCellID!,
            bundle: bundle), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                             withReuseIdentifier: loadingCellID!)
        
        
        // Refresh Control
        self.reloadControl = UIRefreshControl()
        self.reloadControl?.addTarget(self, action: #selector(CollectionViewEngine.reloadFromRefreshControl), for: UIControlEvents.valueChanged)
        self.infinitCollectionView.collectionView.addSubview(self.reloadControl!)
    }
    
    internal func initiateEngine() {
        self.engine.performDataFetch()
    }
    
    internal func reloadFromRefreshControl() {
        self.engine.resetData()
        self.engine.performDataFetch()
    }
    
    internal func reloadCollectionView(_ indexes:[IndexPath]?) {
        self.infinitCollectionView.collectionView.reloadData()
    }
}

extension CollectionViewEngine: InfinityDataEngineDelegate {
    internal func getData(atPage page: Int, completion: @escaping (ResponsePayload) -> ()) {
        self.delegate.collectionView(self.infinitCollectionView.collectionView, withDataForPage: page, forSession: self.engine.sessionID) { (responsePayload) in
            if self.engine.responseIsValid(atPage: page, withReloadControl: self.reloadControl, withResponsePayload: responsePayload) == true {
                completion(responsePayload)
            }
        }
    }
    
    func dataDidRespond(withData data: [AnyObject]?) {
        self.delegate.infinintyDataResponse?(withData: data)
    }
    
    func updateControllerView() {
        self.infinitCollectionView.collectionView.reloadData()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.engine.infinteScrollMonitor(scrollView)
    }
}

extension CollectionViewEngine: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.engine.dataCount.count == 0 {
            return 1
        }
        return self.engine.dataCount.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.engine.dataCount == [] {
            return InfinityEngine.shared.params.placeholderCount
        } else {
            if self.engine.lastPageHit == false {
                if section == self.engine.dataCount.count - 1 {
                    return self.engine.dataCount[section] + 1
                }
            }
        }
        
        return self.engine.dataCount[section]
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.scrollViewDidScroll(self.infinitCollectionView.collectionView)
        
        let cell = self.delegate.collectionView(self.infinitCollectionView.collectionView, withCellItemForIndexPath: indexPath)
        
        if self.engine.page == 1 {
            
            if let placeholderableCell = cell as? InfinityCellManualPlaceholdable {
                placeholderableCell.showPlaceholder()
            } else if let placeholderableCell = cell as? InfinityCellViewAutoPlaceholdable {
                placeholderableCell.placeholderView.isHidden = false
                UIView.animate(withDuration: 0.3, animations: {
                    placeholderableCell.placeholderView.alpha = 1.0
                }) 
            }

        } else {
            
            if let placeholderableCell = cell as? InfinityCellManualPlaceholdable {
                placeholderableCell.hidePlaceholder()
            } else if let placeholderableCell = cell as? InfinityCellViewAutoPlaceholdable {
                placeholderableCell.placeholderView.isHidden = true
                UIView.animate(withDuration: 0.3, animations: {
                    placeholderableCell.placeholderView.alpha = 0.0
                }) 
            }
        }
        
        return cell
    }
}

extension CollectionViewEngine: UICollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.collectionView?(collectionView, didSelectItemAtIndexPath: indexPath)
    }
    
    open func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            return self.delegate.collectionView(self.infinitCollectionView.collectionView, withLoadingCellItemForIndexPath: indexPath, forLastPageHit: self.engine.lastPageHit)
        default:
            return UICollectionReusableView()
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
    }
}

extension CollectionViewEngine: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section != self.engine.dataCount.count - 1 && self.engine.dataCount != [] || self.engine.lastPageHit {
            return CGSize(width: 0.0, height: 0.0)
        }

        return self.delegate.collectionView?(self.infinitCollectionView.collectionView, layout: collectionViewLayout, sizeForLoadingItemAtIndexPath: section) ??
                CGSize(width: UIScreen.main.bounds.size.width, height: kCellHeight)
    }
}

