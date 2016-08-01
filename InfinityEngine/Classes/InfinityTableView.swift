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

public typealias InfinityTableDelegate = UITableViewDelegate


/**
 Defines a struct used when incoporating an InfinityTableView.
 
 - parameter tableView:                 Reference to a UICollectionView, whether it be an Object or IBOutlet reference.
 - parameter cells:                     Will need to define the name of your cells, loading cel and bundle id.
 - parameter modifiers:                 See InfinityModiers - modifiers the behavior of InfinityEngine,
                                        in reference to a UICollectionView.
 
 */

public struct InfinityTableView {
    public let tableView: UITableView!
    public let cells: InfinityCells!
    public let dataSource: InfinityTableSourceable!
    public let delegate: InfinityTableDelegate?
    public let modifiers: InfinityModifers!
    
    public init(withTableView tableView: UITableView, withCells cells: InfinityCells, withDataSource dataSource:InfinityTableSourceable, withDelegate delegate: UITableViewDelegate?,
                withModifiers modifiers: InfinityModifers? = InfinityModifers()) {
        self.tableView = tableView
        self.cells = cells
        self.dataSource = dataSource
        self.delegate = delegate
        self.modifiers = modifiers
    }
}

//public protocol InfinityTableProtocol: InfinityTableDataSource, InfinityTableDelegate {}

/**
 Defines a Protocol to be Implemented on a UIViewControl
 
 - func infinityCellForIndexPath:       Used to return the the corect cell in either placeholder, or live data state.
 - func infinityLoadingCell:            Used to return the desired loading cell you would like to appear at the bottom of the pages InfinityTableView.
 - func infinityTableView:              Used to define the height of each cell, excluding the loading cell.

*/


public protocol InfinityTableSourceable: InfinityDataSource, InfinityTableDelegate {
    func infinityCellForIndexPath(indexPath: NSIndexPath, withPlaceholder placeholder:Bool) -> UITableViewCell
    func infinityLoadingCell(indexPath: NSIndexPath) -> UITableViewCell
    func infinityTableView(heightForRowAtIndexPath indexPath: NSIndexPath, withLoading loading:Bool) -> CGFloat
}


public protocol InfinityTableProtocol: InfinityTableSourceable {
    func startInfinityTableView(infinityTableView infinityTable:InfinityTableView)
    func createTableViewEngine(infinityTableView: InfinityTableView) -> TableViewEngine
    func resetInfinityTable(withCustomTableEngine engine:TableViewEngine?)
}

/**
 Defines an Optional Protocol to be Implemented on a UIViewControl
 
 - func infinityTableView:              Used to return the loading cell height, else the default will be kLoadingCellHeight.
 */

/**
 Defines an extension to be Implemented on a UIViewController
 
 - func startInfinityTableView:         Used to start the InfinityTableView session.
 - func resetInfinityTable:             Used to reset/restart the InfinityTableView session.
 */


extension InfinityTableProtocol where Self: UIViewController {
    public func startInfinityTableView(infinityTableView infinityTable:InfinityTableView) {
        self.createTableViewEngine(infinityTable)
    }
    
    public func createTableViewEngine(infinityTableView: InfinityTableView) -> TableViewEngine {
        return TableViewEngine(infinityTableView: infinityTableView)
    }
    
    public func resetInfinityTable(withCustomTableEngine engine:TableViewEngine?) {
        
        if let engine = engine {
            engine.reload()
        } else {
            for collectionInstance in InfinityEngineRoom.sharedTableInstances {
                collectionInstance.reload()
            }
        }
    }
}

/**
 Defines an extension to be Implemented on a UIView
 
 - func startInfinityTableView:         Used to start the InfinityTableView session.
 - func resetInfinityTable:             Used to reset/restart the InfinityTableView session.
 */

extension InfinityTableProtocol where Self: UIView {
    public func startInfinityTableView(infinityTableView infinityTable:InfinityTableView) {
        self.createTableViewEngine(infinityTable)
    }
    
    public func createTableViewEngine(infinityTableView: InfinityTableView) -> TableViewEngine {
        return TableViewEngine(infinityTableView: infinityTableView)
    }
    
    public func resetInfinityTable(withCustomTableEngine engine:TableViewEngine?) {
        
        if let engine = engine {
            engine.reload()
        } else {
            for collectionInstance in InfinityEngineRoom.sharedTableInstances {
                collectionInstance.reload()
            }
        }
    }
}