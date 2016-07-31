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

internal final class TableViewEngine: NSObject {
    
    var infinityTableView: InfinityTableView!
    var engine:InfinityEngine!
    var dataSource: InfinityTableDataSource!
    var reloadControl:UIRefreshControl?
    
    // MARK: - Lifecycle
    
    init(infinityTableView:InfinityTableView, dataSource:InfinityTableDataSource) {
        super.init()
        self.infinityTableView = infinityTableView
        self.dataSource = dataSource
        self.engine = InfinityEngine(infinityModifiers: infinityTableView.modifiers, withDelegate: self)
        self.setupTableView()
        
        self.initiateEngine()
    }
    
    func setupTableView() {
            
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
            self.reloadControl?.addTarget(self, action: #selector(TableViewEngine.reloadFromRefreshControl), forControlEvents: UIControlEvents.ValueChanged)
            self.infinityTableView.tableView.addSubview(self.reloadControl!)
        }
    }
    
    func initiateEngine() {
        self.engine.performDataFetch()
    }
    
    func reloadFromRefreshControl() {
        self.engine.resetData()
        self.initiateEngine()
    }
}

extension TableViewEngine: InfinityDataEngineDelegate {
    
    func getData(atPage page: Int, withModifiers modifiers: InfinityModifers, completion: (responsePayload: ResponsePayload) -> ()) {
        self.dataSource.infinityData(atPage: page, withModifiers: modifiers, forSession: self.engine.sessionID) { (responsePayload) in
            
            if self.engine.responseIsValid(atPage: page, withReloadControl: self.reloadControl, withResponsePayload: responsePayload) == true {
                completion(responsePayload: responsePayload)
            }
        }
    }
    
    func dataDidRespond(withData data: [AnyObject]?) {
        self.dataSource.infinintyDataResponse?(withData: data)
    }
    
    func buildIndexsForInsert(dataCount count: [Int]) -> [NSIndexPath] {
        var indexs = [NSIndexPath]()
        return indexs
    }
    
    func dataEngine(responsePayload payload: ResponsePayload, withIndexPaths indexPaths: [NSIndexPath]?) {
        self.engine.dataCount = self.engine.dataFactory(payload)
    }
    
    func updateControllerView(atIndexes indexes: [NSIndexPath]?) {
        
        guard let indexes = indexes else {
            self.infinityTableView.tableView.reloadData()
            return
        }
        
        if self.infinityTableView.modifiers.forceReload == true {
            self.infinityTableView.tableView.reloadData()
            
        } else {
            
            let indexPathTuple = self.engine.splitIndexPaths(indexes)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if self.engine.dataCount[0] <= kPlaceHolderCellCount {
                    self.infinityTableView.tableView.reloadData()
                } else {
                    self.infinityTableView.tableView.beginUpdates()
                    self.infinityTableView.tableView.reloadRowsAtIndexPaths(indexPathTuple.reloadIndexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                    self.infinityTableView.tableView.insertRowsAtIndexPaths(indexPathTuple.insertIndexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
                    self.infinityTableView.tableView.endUpdates()
                }
                
            })
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.infinityTableView.modifiers.infiniteScroll == true {
            self.engine.infinteScrollMonitor(scrollView)
        }
    }
}

extension TableViewEngine: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.engine.dataCount.count == 0 {
            return 1
        }
        return self.engine.dataCount.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.engine.page == 1 {
            
            if indexPath.row == kPlaceHolderCellCount - 1 {
                return self.dataSource.infinityLoadingCell(indexPath)
            }
            return self.dataSource.infinityCellForIndexPath(indexPath, withPlaceholder: true)
            
        } else {
            
            if indexPath.section == self.engine.dataCount.count - 1 && self.infinityTableView.modifiers.infiniteScroll {
                if indexPath.row == self.engine.dataCount[self.engine.dataCount.count - 1] {
                    return self.dataSource.infinityLoadingCell(indexPath)
                }
            }
            return self.dataSource.infinityCellForIndexPath(indexPath, withPlaceholder: false)
        }
    }
}

extension TableViewEngine:UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if self.engine.page == 1 {
            
            if indexPath.row == kPlaceHolderCellCount - 1 {
                return self.dataSource.infinityTableView(heightForRowAtIndexPath: indexPath, withLoading: true)
            }
            return self.dataSource.infinityTableView(heightForRowAtIndexPath: indexPath, withLoading: false)
            
        } else {
            
            if indexPath.section == self.engine.dataCount.count - 1 && self.infinityTableView.modifiers.infiniteScroll {
                if indexPath.row == self.engine.dataCount[self.engine.dataCount.count - 1] {
                    return self.dataSource.infinityTableView(heightForRowAtIndexPath: indexPath, withLoading: true)
                }
            }
            return self.dataSource.infinityTableView(heightForRowAtIndexPath: indexPath, withLoading: false)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.infinityTableView.delegate?.tableView?(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.infinityTableView.delegate?.tableView?(tableView, estimatedHeightForRowAtIndexPath: indexPath) ?? UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.infinityTableView.delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.infinityTableView.delegate?.tableView?(tableView, viewForFooterInSection: section)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.infinityTableView.delegate?.tableView?(tableView, heightForFooterInSection: section) ?? UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return self.infinityTableView.delegate?.tableView?(tableView, estimatedHeightForFooterInSection: section) ?? UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.infinityTableView.delegate?.tableView?(tableView, heightForHeaderInSection: section) ?? UITableViewAutomaticDimension
        //return 20.0
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        //return self.infinityTableView.delegate?.tableView?(tableView, estimatedHeightForHeaderInSection: section) ?? UITableViewAutomaticDimension
//        //return 20.0
//
//    }
}