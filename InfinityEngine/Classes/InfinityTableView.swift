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
 Defines a struct used when incoporating an InfinityTableView.
 
 - parameter tableView:                 Reference to a UICollectionView, whether it be an Object or IBOutlet reference.
 - parameter cells:                     Will need to define the name of your cells, loading cel and bundle id.
 - parameter modifiers:                 See InfinityModiers - modifiers the behavior of InfinityEngine,
                                        in reference to a UICollectionView.
 */

public struct InfinityTable {
    public let tableView: UITableView!
    public let dataSource: InfinityTableSourceable!
    
    public init(withTableView tableView: UITableView, withDataSource source:InfinityTableSourceable) {
        self.tableView = tableView
        self.dataSource = source
    }
}

/**
 Defines a Protocol to be Implemented on a UIViewControl
 
 - func infinityCellForIndexPath:       Used to return the the corect cell in either placeholder, or live data state.
 - func infinityLoadingCell:            Used to return the desired loading cell you would like to appear at the bottom of the pages InfinityTableView.
 - func infinityTableView:              Used to define the height of each cell, excluding the loading cell.
*/

public protocol InfinityTableSourceable: InfinityDataSource, InfinityTableSourceableOptional {
    func infinity(_ tableView: UITableView, withDataForPage page: Int, forSession session: String, completion: @escaping (ResponsePayload) -> (Void))
    func infinity(_ tableView:UITableView, cellForRowAtIndexPath indexPath:IndexPath) -> UITableViewCell
    func infinity(_ tableView:UITableView, heightForRowAtIndexPath indexPath:IndexPath, forLoadingCell loadingCell:Bool) -> CGFloat
}

@objc public protocol InfinityTableSourceableOptional: class {
    @objc optional func infinity(_ tableView:UITableView, didSelectRowAtIndexPath indexPath:IndexPath)
}

public protocol InfinityListable: InfinityTableSourceable {
    func startInfinityTableView(infinityTableView infinityTable:InfinityTable)
    func createTableViewEngine(_ infinityTableView: InfinityTable) -> TableViewEngine
    func resetInfinityTable()
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


extension InfinityListable where Self: UIViewController {
    public func startInfinityTableView(infinityTableView infinityTable:InfinityTable) {
        InfinityEngine.sharedTableInstances.removeAll()
        
        let engine = self.createTableViewEngine(infinityTable)
        engine.initiateEngine()
        InfinityEngine.sharedTableInstances.append(engine)
    }
    
    public func createTableViewEngine(_ infinityTableView: InfinityTable) -> TableViewEngine {
        return TableViewEngine(infinityTableView: infinityTableView)
    }
    
    public func resetInfinityTable() {
        for tableInstance in InfinityEngine.sharedTableInstances {
            tableInstance.reload()
        }
    }
}

/**
 Defines an extension to be Implemented on a UIView
 
 - func startInfinityTableView:         Used to start the InfinityTableView session.
 - func resetInfinityTable:             Used to reset/restart the InfinityTableView session.
 */

extension InfinityListable where Self: UIView {
    public func startInfinityTableView(infinityTableView infinityTable:InfinityTable) {
        InfinityEngine.sharedTableInstances.removeAll()
        
        let engine = self.createTableViewEngine(infinityTable)
        engine.initiateEngine()
        InfinityEngine.sharedTableInstances.append(engine)
    }
    
    public func createTableViewEngine(_ infinityTableView: InfinityTable) -> TableViewEngine {
        return TableViewEngine(infinityTableView: infinityTableView)
    }
    
    public func resetInfinityTable() {
        for tableInstance in InfinityEngine.sharedTableInstances {
            tableInstance.reload()
        }
    }
}
