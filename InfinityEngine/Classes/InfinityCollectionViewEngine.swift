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
    
    fileprivate var infinitCollectionView: InfinityCollectionView!
    internal var engine:InfinityDataEngine!
    fileprivate var delegate: InfinityCollectionSourceable!
    fileprivate var reloadControl:UIRefreshControl?
    
    public init(infinityCollectionView:InfinityCollectionView) {
        super.init()
        self.infinitCollectionView = infinityCollectionView
        self.delegate = infinityCollectionView.source
        self.engine = InfinityDataEngine(withDelegate: self)
        self.setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        self.infinitCollectionView.collectionView.register(LoadingCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "LoadingView")

        self.infinitCollectionView.collectionView.delegate = self
        self.infinitCollectionView.collectionView.dataSource = self
        self.infinitCollectionView.collectionView.alwaysBounceVertical = true
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
        self.delegate.infinity(self.infinitCollectionView.collectionView, withDataForPage: page, forSession: self.engine.sessionID) { (responsePayload) in
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

extension CollectionViewEngine: UICollectionViewDataSource, UICollectionViewDelegate {
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
        
        let cell = self.delegate.infinity(self.infinitCollectionView.collectionView, withCellItemForIndexPath: indexPath)
        
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
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.infinity?(collectionView, didSelectItemAtIndexPath: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            return self.infinitCollectionView.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "LoadingView", for: indexPath)
        default:
            return UICollectionReusableView()
        }
    }
}

extension CollectionViewEngine: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if section != self.engine.dataCount.count - 1 && self.engine.dataCount != [] || self.engine.lastPageHit {
            return CGSize(width: 0.0, height: 0.0)
        }

        return self.delegate.infinity?(self.infinitCollectionView.collectionView, layout: collectionViewLayout, sizeForLoadingItemAtIndexPath: section) ??
                CGSize(width: UIScreen.main.bounds.size.width, height: 100.0)
    }
}

class LoadingCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addLoader()
    }
    
    func addLoader() {
        let cell = UICollectionViewCell()
        
        let loadingView = InfinityEngine.shared.params.loadingView
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(loadingView)
        
        let views: [String: UIView] = ["loadingView": loadingView]
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[loadingView]|", options: [], metrics: nil, views: views))
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[loadingView]|", options: [], metrics: nil, views: views))
        cell.layoutIfNeeded()
    }
    
}


