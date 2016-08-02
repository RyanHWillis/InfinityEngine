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
    
    var customTabEngine: NewTableViewEngine!

    init() {
        super.init(nibName: "TestTableViewController", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let cells:InfinityCells = InfinityCells(cellNames: ["TestTableViewCell", "SectionCell"], loadingCellName: "LoadingTableViewCell", customBundle: nil)
        let tableViewStruct:InfinityTableView = InfinityTableView(withTableView: tableView, withCells: cells, withDataSource: self, withDelegate: self)
        self.customTabEngine = NewTableViewEngine(infinityTableView: tableViewStruct)

        startInfinityTableView(infinityTableView: tableViewStruct)
    }
    
    
    func createTableViewEngine(infinityTableView: InfinityTableView) -> TableViewEngine {
        return customTabEngine
    }
    
    
    @IBAction func reset(sender: AnyObject) {
        self.resetInfinityTable(withCustomTableEngine: self.customTabEngine)
    }
}

extension TestTableViewController: InfinityTableProtocol {
    
    func tableView(tableView: UITableView, withDataForPage page: Int, withModifiers modifiers: InfinityModifers, forSession session: String, completion: (responsePayload: ResponsePayload) -> ()) {
        delay(1.0) {
            completion(responsePayload: ResponsePayload(count: [8, 3, 12 * page * page], lastPage: false, session: session))
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, withPlaceholder placeholder: Bool) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TestTableViewCell", forIndexPath: indexPath) as! TestTableViewCell
        if placeholder == true {
            cell.contentView.backgroundColor = UIColor.redColor()
        } else {
            cell.contentView.backgroundColor = UIColor.orangeColor()
        }
        
        cell.label.text = "Row " + String(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, withLoadingCellItemForIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("LoadingTableViewCell", forIndexPath: indexPath) as! LoadingTableViewCell
        cell.backgroundColor = UIColor.purpleColor()
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath, forLoadingCell loadingCell: Bool) -> CGFloat {
        if loadingCell {
            return 30.0
        }
        
        return 40.0
    }
}

class NewTableViewEngine: TableViewEngine {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("test")
    }
}
