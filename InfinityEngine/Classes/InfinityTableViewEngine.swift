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

/**
 Constructs an internal NSObject, used to represent a UITableView into InfinityTableView.
 */

import UIKit

open class TableViewEngine: NSObject {
    
    fileprivate var infinityTableView: InfinityTable!
    fileprivate var engine:InfinityDataEngine!
    fileprivate var dataSource: InfinityTableSourceable!
    fileprivate var reloadControl:UIRefreshControl?
    
    public init(infinityTableView:InfinityTable) {
        super.init()
        self.infinityTableView = infinityTableView
        self.dataSource = infinityTableView.dataSource
        self.engine = InfinityDataEngine(withDelegate: self)
        self.setupTableView()
    }
    
    fileprivate func setupTableView() {
        self.infinityTableView.tableView.delegate = self
        self.infinityTableView.tableView.dataSource = self
        self.infinityTableView.tableView.separatorStyle = .none
    }
    
    internal func initiateEngine() {
        self.engine.performDataFetch()
    }
    
    internal func reload() {
        self.engine.resetData()
        self.initiateEngine()
    }
    
    // MARK: - Loading
    
    func loadingCell() -> UITableViewCell {
        let cell = UITableViewCell()
        
        let loadingView = InfinityEngine.shared.params.loadingView
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(loadingView)
        
        let views: [String: UIView] = ["loadingView": loadingView]
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[loadingView]|", options: [], metrics: nil, views: views))
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[loadingView]|", options: [], metrics: nil, views: views))
        cell.layoutIfNeeded()

        return cell
    }
}

extension TableViewEngine: InfinityDataEngineDelegate {
    internal func getData(atPage page: Int, completion: @escaping (ResponsePayload) -> ()) {
        self.dataSource.infinity(self.infinityTableView.tableView, dataForPage: page, self.engine.sessionID) { (responsePayload) in
            if self.engine.responseIsValid(atPage: page, withReloadControl: self.reloadControl, withResponsePayload: responsePayload) == true {
                completion(responsePayload)
            }
        }
    }
    
    internal func updateControllerView() {
        self.infinityTableView.tableView.reloadData()
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.engine.infinteScrollMonitor(scrollView)
    }
}

extension TableViewEngine: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.engine.dataCount.count == 0 {
            return 1
        }
        return self.engine.dataCount.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.scrollViewDidScroll(self.infinityTableView.tableView)
        if self.engine.page == 1 {
            
            if (indexPath as NSIndexPath).row == InfinityEngine.shared.params.placeholderCount - 1 {
                return self.loadingCell()
            }
            
            let cell = self.dataSource.infinity(self.infinityTableView.tableView, cellForRowAtIndexPath: indexPath)
            
            
            if let placeholderableCell = cell as? InfinityCellManualPlaceholdable {
                placeholderableCell.showPlaceholder()
            } else if let placeholderableCell = cell as? InfinityCellViewAutoPlaceholdable {
                placeholderableCell.placeholderView.isHidden = false
                UIView.animate(withDuration: 0.3, animations: {
                    placeholderableCell.placeholderView.alpha = 1.0
                }) 
            }
            return cell
            
        } else {
            
            if (indexPath as NSIndexPath).section == self.engine.dataCount.count - 1 {
                if (indexPath as NSIndexPath).row == self.engine.dataCount[self.engine.dataCount.count - 1] {
                    return self.loadingCell()
                }
            }
            
            let cell = self.dataSource.infinity(self.infinityTableView.tableView, cellForRowAtIndexPath: indexPath)
            if let placeholderableCell = cell as? InfinityCellManualPlaceholdable {
                placeholderableCell.hidePlaceholder()
            } else if let placeholderCell = cell as? InfinityCellViewAutoPlaceholdable {
                UIView.animate(withDuration: 0.3, animations: {
                    placeholderCell.placeholderView.alpha = 0.0
                }, completion: { (complete) in
                    placeholderCell.placeholderView.isHidden = true
                }) 
            }
            return cell
        }
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.engine.page == 1 {
            
            if (indexPath as NSIndexPath).row == InfinityEngine.shared.params.placeholderCount - 1 {
                return self.infinityTableView.loadingHeight
            }
            
            return self.dataSource.infinity(self.infinityTableView.tableView, heightForRowAt: indexPath)
            
        } else {
            
            if (indexPath as NSIndexPath).section == self.engine.dataCount.count - 1 {
                if (indexPath as NSIndexPath).row == self.engine.dataCount[self.engine.dataCount.count - 1] {
                    return self.infinityTableView.loadingHeight
                }
            }
            
            return self.dataSource.infinity(self.infinityTableView.tableView, heightForRowAt: indexPath)
        }
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSource.infinity?(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    // MARK: - Overrides ...  Work around for Swift 3 UITableViewDelegate not being open
    
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {}
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {}
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {}
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return nil }
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}
    open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {}
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {}
    open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {}
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 0.0 }
    open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool { return true }
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? { return nil }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return nil }
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { return false }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0.0 }
    open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {}
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { return nil }
    open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool { return false }
    open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {}
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return nil }
    open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? { return nil }
    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return false }
}




