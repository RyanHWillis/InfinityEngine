//
//  TestTableViewController.swift
//  InfintyEngineV2
//
//  Created by Ryan Willis on 26/04/2016.
//  Copyright © 2016 RyanWillis. All rights reserved.
//

import UIKit
import InfinityEngine

class TestTableViewController: UIViewController, InfinityTableViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    
    init() {
        super.init(nibName: "TestTableViewController", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.lightGrayColor()
        
        let tableViewStruct:InfinityTableView = InfinityTableView(tableView: self.tableView,
            tableViewCellNibNames: ["TestTableViewCell"], tableViewLoadingCellINibName: "LoadingTableViewCell")
        
        startInfinityTableView(infinityTableView: tableViewStruct, withDelegate: self)

//        
//        
//        let tableViewStruct2:InfinityTableView = InfinityTableView(tableView: self.tableView2,
//                                                                  tableViewCellNibNames: ["TestTableViewCell"], tableViewLoadingCellINibName: "LoadingTableViewCell")
//        
//        startInfinityTableView(infinityTableView: tableViewStruct2, withDelegate: self)
 
    }
    
    var count = 0
    func infinityData(atPage page: Int, withModifiers modifiers: InfinityModifers,
                             forSession sessionID:String, completion: (responsePayload: ResponsePayload) -> ()) {
        
        print(page)
        
        let data:String = "test"
        var datas:[AnyObject] = [AnyObject]()
        
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        datas.append(data)
        
        
        count = count + 1
        
        var bool = false
        if count == 3 {
            bool = true
        }
        delay(3.0) {
            completion(responsePayload: ResponsePayload(data: datas, count: 10, lastPage: bool, perPage: 10, total: 10, page: page, session: sessionID))
        }
        
        delay(4.5) {
            completion(responsePayload: ResponsePayload(data: datas, count: 10, lastPage: bool, perPage: 10, total: 10, page: page, session: sessionID))
        }
        
        delay(6.0) {
            completion(responsePayload: ResponsePayload(data: datas, count: 10, lastPage: bool, perPage: 10, total: 10, page: page, session: sessionID))
        }
    }
    
    func infinityCellForIndexPath(indexPath: NSIndexPath, withData data: [AnyObject]?, withPlaceholder placeholder: Bool) -> UITableViewCell {
        
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
    
    func infinityDidSelectItemAtIndexPath(indexPath: NSIndexPath) {
        
    }
    

    
    func infinityTableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
}