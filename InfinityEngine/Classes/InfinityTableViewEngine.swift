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

public class TableViewEngine: NSObject {
    
    var infinityTableView: InfinityTableView!
    var engine:InfinityEngine!
    var dataSource: InfinityTableSourceable!
    var reloadControl:UIRefreshControl?
    
    // MARK: - Lifecycle
    
    public init(infinityTableView:InfinityTableView) {
        super.init()
        self.infinityTableView = infinityTableView
        self.dataSource = infinityTableView.dataSource
        self.engine = InfinityEngine(infinityModifiers: infinityTableView.modifiers, withDelegate: self)
        self.setupTableView()
        
        self.initiateEngine()
    }
    
    private func setupTableView() {
            
        // Set Table View Instance With Appropriate Object
        self.infinityTableView.tableView.delegate = self
        self.infinityTableView.tableView.dataSource = self
        self.infinityTableView.tableView.separatorStyle = .None
        
        // Get the Bundle
        var bundle:NSBundle!
        if let identifier = self.infinityTableView.cells.bundleIdentifier {
            bundle = NSBundle(identifier: identifier)
        } else {
            bundle = NSBundle.mainBundle()
        }
        
        // Register All Posible Nibs
        for nibName in self.infinityTableView.cells.cellNames {
            self.infinityTableView.tableView.registerNib(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: nibName)
        }
        
        // Register Loading Cell
        let loadingCellNibName:String = self.infinityTableView.cells.loadingCellName
        self.infinityTableView.tableView.registerNib(UINib(nibName: loadingCellNibName, bundle: bundle), forCellReuseIdentifier: loadingCellNibName)


        // Refresh Control
        if self.engine.modifiers.refreshControl == true {
            self.reloadControl = UIRefreshControl()
            self.reloadControl?.addTarget(self, action: #selector(TableViewEngine.reload), forControlEvents: UIControlEvents.ValueChanged)
            self.infinityTableView.tableView.addSubview(self.reloadControl!)
        }
    }
    
    internal func initiateEngine() {
        self.engine.performDataFetch()
    }
    
    internal func reload() {
        self.engine.resetData()
        self.initiateEngine()
    }
}

extension TableViewEngine: InfinityDataEngineDelegate {
    
    func getData(atPage page: Int, withModifiers modifiers: InfinityModifers, completion: (responsePayload: ResponsePayload) -> ()) {
        
        self.dataSource.tableView(self.infinityTableView.tableView, withDataForPage: page, forSession: self.engine.sessionID) { (responsePayload) in
            
            if self.engine.responseIsValid(atPage: page, withReloadControl: self.reloadControl, withResponsePayload: responsePayload) == true {
                completion(responsePayload: responsePayload)
            }
        }
    }
    
    func updateControllerView() {
        self.infinityTableView.tableView.reloadData()
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        self.engine.infinteScrollMonitor(scrollView)
    }
}

extension TableViewEngine: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.engine.dataCount.count == 0 {
            return 1
        }
        return self.engine.dataCount.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.engine.dataCount == [] {
            return kPlaceHolderCellCount
        } else {
            if self.engine.lastPageHit == false {
                if section == self.engine.dataCount.count - 1 {
                    return self.engine.dataCount[section] + 1
                }
            }
        }
        
        return self.engine.dataCount[section]
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.scrollViewDidScroll(self.infinityTableView.tableView)
        if self.engine.page == 1 {
            
            if indexPath.row == kPlaceHolderCellCount - 1 {
                return self.dataSource.tableView(self.infinityTableView.tableView, withLoadingCellItemForIndexPath: indexPath)
            }
            
            let cell = self.dataSource.tableView(self.infinityTableView.tableView, cellForRowAtIndexPath: indexPath)
            if let placeholderableCell = cell as? InfinityCellPlaceholdable {
                placeholderableCell.showPlaceholder()
            }
            return cell
            
        } else {
            
            if indexPath.section == self.engine.dataCount.count - 1 {
                if indexPath.row == self.engine.dataCount[self.engine.dataCount.count - 1] {
                    return self.dataSource.tableView(self.infinityTableView.tableView, withLoadingCellItemForIndexPath: indexPath)
                }
            }
            
            let cell = self.dataSource.tableView(self.infinityTableView.tableView, cellForRowAtIndexPath: indexPath)
            if let placeholderableCell = cell as? InfinityCellPlaceholdable {
                placeholderableCell.hidePlaceholder()
            }
            return cell
        }
    }
}

extension TableViewEngine:UITableViewDelegate {
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.engine.page == 1 {
            
            if indexPath.row == kPlaceHolderCellCount - 1 {
                return self.dataSource.tableView(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath, forLoadingCell: true)
            }
            return self.dataSource.tableView(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath, forLoadingCell: false)
            
        } else {
            
            if indexPath.section == self.engine.dataCount.count - 1 {
                if indexPath.row == self.engine.dataCount[self.engine.dataCount.count - 1] {
                    return self.dataSource.tableView(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath, forLoadingCell: true)
                }
            }
            return self.dataSource.tableView(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath, forLoadingCell: false)
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dataSource.tableView?(tableView, didSelectRowAtIndexPath: indexPath)
    }
}