//
//  InfinityTableViewEngine.swift
//  InfintyEngineV2
//
//  Created by Ryan Willis on 25/04/2016.
//  Copyright © 2016 RyanWillis. All rights reserved.
//

/**
 Constructural modifers that change behavior.
 
 - Road: For streets or trails.
 - Touring: For long journeys.
 - Cruiser: For casual trips around town.
 - Hybrid: For general-purpose transportation.
 */

import UIKit

public final class TableViewEngine: NSObject {
    
    let reloadControl = UIRefreshControl()
    
    var infinityTableView: InfinityTableView!
    var engine:InfinityEngine!
    var delegate: InfinityTableViewProtocol!
    
    // MARK: - Lifecycle
    
    init(infinityTableView:InfinityTableView, delegate:InfinityTableViewProtocol) {
        super.init()
        self.infinityTableView = infinityTableView
        self.delegate = delegate
        self.engine = InfinityEngine(infinityModifiers: infinityTableView.modifiers, withDelegate: self)
        
        self.setupTableView()
    }
    
    func setupTableView() {
        
        // Set Table View Instance With Appropriate Object
        self.infinityTableView.tableView.delegate = self
        self.infinityTableView.tableView.dataSource = self
        self.infinityTableView.tableView.separatorStyle = .None
        
        // Register All Posible Nibs
        for nibName in self.infinityTableView.tableViewCellNibNames {
            self.infinityTableView.tableView.registerNib(UINib(nibName: nibName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: nibName)
        }
        
        // Register Loading Cell
        let loadingCellNibName:String = self.infinityTableView.tableViewLoadingCellINibName
        self.infinityTableView.tableView.registerNib(UINib(nibName: loadingCellNibName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: loadingCellNibName)


        // Refresh Control
        self.reloadControl.addTarget(self, action: #selector(TableViewEngine.reloadTableView), forControlEvents: UIControlEvents.ValueChanged)
        self.infinityTableView.tableView.addSubview(self.reloadControl)
    }
    
    func reloadFromRefreshControl() {
        self.engine.resetData()
        self.reloadControl.endRefreshing()
    }
    
    func reloadTableView(indexes:[NSIndexPath]?) {
        self.infinityTableView.tableView.reloadData()
    }
}

extension TableViewEngine: InfinityDataEngineDelegate {
    
    func getData(atPage page: Int, withModifiers modifiers: InfinityModifers, completion: (responsePayload: ResponsePayload) -> ()) {
        self.delegate.infinityData(atPage: page, withModifiers: modifiers) { (responsePayload) in
            completion(responsePayload: responsePayload)
        }
    }
    
    func buildIndexsForInsert(dataCount count: Int) -> [NSIndexPath] {
        var indexs = [NSIndexPath]()
        
        var numbObj:Int
        
        if self.engine.lastPageHit == true {
            
            if self.engine.dataCount() == 0 {
                numbObj = count - 1
            } else {
                numbObj = count - 2
            }
            
        } else {
            if self.engine.dataCount() == 0 {
                numbObj = count
            } else {
                numbObj = count - 1
            }
        }
        
        
        for index in (self.engine.dataCount())...(self.engine.dataCount() + numbObj) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            indexs.append(indexPath)
        }
        
        return indexs
    }
    
    func dataEngine(responsePayload payload: ResponsePayload, withIndexPaths indexPaths: [NSIndexPath]?) {
        self.engine.data = self.engine.dataFactory(payload)
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
                
                if self.engine.dataCount() <= kPlaceHolderCellCount {
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
}

extension TableViewEngine: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.engine.dataCount() == 0 && self.engine.page == 1 {
            return kPlaceHolderCellCount
        } else {
            if self.engine.lastPageHit == true {
                return self.engine.dataCount()
            } else {
                
                if self.engine.dataCount() == 0 {
                    return self.engine.dataCount()
                } else {
                    return self.engine.dataCount() + 1
                }
            }
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Calculate if we are used force reload
        if self.infinityTableView.modifiers.infiniteScroll == true {
            self.engine.infinteScrollMonitor(indexPath)
        }
        
        // Check our indexdBy Type
        var indexNum:Int = 0
        if self.infinityTableView.modifiers.indexedBy == IndexType.Section {
            indexNum = indexPath.section
        } else {
            indexNum = indexPath.row
        }
        
        if self.engine.page == 1 {
            
            if indexNum == kPlaceHolderCellCount - 1 {
                
                if self.infinityTableView.modifiers.infiniteScroll == true {
                    
                    // Becuase we have no tableview did finish loading callbacks,
                    // we'll calculate when to start data fetch when last placeholder cell
                    // has loaded
                    
                    self.engine.performDataFetch()
                    return self.delegate.infinityLoadingCell(indexPath)
                    
                } else {
                    return self.delegate.infinityCellForIndexPath(indexPath, placeholder: true)
                }
                
            } else {
                return self.delegate.infinityCellForIndexPath(indexPath, placeholder: true)
            }
            
        } else {
            
            if indexNum == self.engine.dataCount() {
                
                if self.infinityTableView.modifiers.infiniteScroll == true {
                    
                    if self.engine.dataCount() > 0 {
                        return self.delegate.infinityLoadingCell(indexPath)
                    } else {
                        return self.delegate.infinityCellForIndexPath(indexPath, placeholder: true)
                    }
                    
                } else {
                    return self.delegate.infinityCellForIndexPath(indexPath, placeholder: false)
                }
                
            } else {
                
                // Check if there was no data returned from the response
                if self.engine.dataCount() == 0 {
                    return self.delegate.infinityCellForIndexPath(indexPath, placeholder: true)
                } else {
                    return self.delegate.infinityCellForIndexPath(indexPath, placeholder: false)
                }
            }
        }
    }
}

extension TableViewEngine:UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate.infinityDidSelectItemAtIndexPath(indexPath)
    }
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Check our indexdBy Type
        var indexNum:Int = 0
        if self.infinityTableView.modifiers.indexedBy == .Section {
            indexNum = indexPath.section
        } else {
            indexNum = indexPath.row
        }
        
        if self.engine.page == 1 {
            if indexNum == kPlaceHolderCellCount - 1 {
                if self.infinityTableView.modifiers.infiniteScroll == true {
                    return kLoadingCellHeight
                } else {
                    return self.delegate.infinityTableView(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath)
                }
            } else {
                return self.delegate.infinityTableView(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath)
            }
            
        } else {
            if self.engine.dataCount() == indexNum {
                if self.infinityTableView.modifiers.infiniteScroll == true {
                    return kLoadingCellHeight
                } else {
                    return self.delegate.infinityTableView(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath)
                }
            } else {
                return self.delegate.infinityTableView(self.infinityTableView.tableView, heightForRowAtIndexPath: indexPath)
            }
        }
    }
}