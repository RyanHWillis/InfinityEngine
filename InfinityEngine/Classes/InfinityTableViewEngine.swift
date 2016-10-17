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
    
    internal var infinityTableView: InfinityTable!
    internal var engine:InfinityDataEngine!
    internal var dataSource: InfinityTableSourceable!
    internal var reloadControl:UIRefreshControl?
    
    var meh: UITableViewDelegate?
    
    // MARK: - Lifecycle
    
    public init(infinityTableView:InfinityTable) {
        super.init()
        self.infinityTableView = infinityTableView
        self.dataSource = infinityTableView.dataSource
        self.engine = InfinityDataEngine(withDelegate: self)
        self.setupTableView()
    }
    
    fileprivate func setupTableView() {
            
        // Set Table View Instance With Appropriate Object
        self.infinityTableView.tableView.delegate = self
        self.infinityTableView.tableView.dataSource = self
        self.infinityTableView.tableView.separatorStyle = .none

        // Refresh Control
        self.reloadControl = UIRefreshControl()
        self.reloadControl?.addTarget(self, action: #selector(TableViewEngine.reload), for: UIControlEvents.valueChanged)
        self.infinityTableView.tableView.addSubview(self.reloadControl!)
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
        self.dataSource.infinity(self.infinityTableView.tableView, withDataForPage: page, forSession: self.engine.sessionID) { (responsePayload) in
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

extension TableViewEngine: UITableViewDataSource {
    
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
}

extension TableViewEngine: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.engine.page == 1 {
            
            if (indexPath as NSIndexPath).row == InfinityEngine.shared.params.placeholderCount - 1 {
                return self.dataSource.infinity(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath, forLoadingCell: true)
            }
            return self.dataSource.infinity(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath, forLoadingCell: false)
            
        } else {
            
            if (indexPath as NSIndexPath).section == self.engine.dataCount.count - 1 {
                if (indexPath as NSIndexPath).row == self.engine.dataCount[self.engine.dataCount.count - 1] {
                    return self.dataSource.infinity(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath, forLoadingCell: true)
                }
            }
            return self.dataSource.infinity(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath, forLoadingCell: false)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSource.infinity?(tableView, didSelectRowAtIndexPath: indexPath)
    }
}
