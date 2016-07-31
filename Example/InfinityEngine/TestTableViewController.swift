//
//  TestTableViewController.swift
//  InfintyEngineV2
//
//  Created by Ryan Willis on 26/04/2016.
//  Copyright © 2016 RyanWillis. All rights reserved.
//

import UIKit
import InfinityEngine

class TestTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var count = 0

    init() {
        super.init(nibName: "TestTableViewController", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cells:InfinityCells = InfinityCells(cellNames: ["TestTableViewCell"], loadingCellName: "LoadingTableViewCell", customBundle: nil)
        let tableViewStruct:InfinityTableView = InfinityTableView(withTableView: tableView, withCells: cells, withDataSource: self, withDelegate: self)
        startInfinityTableView(infinityTableView: tableViewStruct)
    }
    
    @IBAction func reset(sender: AnyObject) {
        resetInfinityTable()
    }
}

extension TestTableViewController: InfinityTableProtocol {
    func infinityData(atPage page: Int, withModifiers modifiers: InfinityModifers,
                             forSession session:String, completion: (responsePayload: ResponsePayload) -> ()) {
        // I'm returning more than one completiton here...to demonstrate multiple responses for a single session for a page will be ignored.
        // You only need to return one completion per page request.
        
        delay(3.0) {
            completion(responsePayload: ResponsePayload(count: [2, 2, 2 * page], lastPage: false, session: session))
        }
    }
    
    func infinityCellForIndexPath(indexPath: NSIndexPath, withPlaceholder placeholder: Bool) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TestTableViewCell", forIndexPath: indexPath) as! TestTableViewCell
        if placeholder == true {
            cell.contentView.backgroundColor = UIColor.redColor()
        } else {
            cell.contentView.backgroundColor = UIColor.orangeColor()
        }
        
        cell.label.text = "Row " + String(indexPath.row)
        
        return cell
    }
    
    func infinityLoadingCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("LoadingTableViewCell", forIndexPath: indexPath) as! LoadingTableViewCell
        cell.backgroundColor = UIColor.purpleColor()
        return cell
    }
    
    func infinityTableView(heightForRowAtIndexPath indexPath: NSIndexPath, withLoading loading: Bool) -> CGFloat {
        if loading {
            return 50.0
        }
        
        return 20.0
    }
}
