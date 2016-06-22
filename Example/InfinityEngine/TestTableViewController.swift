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
        let tableViewStruct:InfinityTableView = InfinityTableView(withTableView: self.tableView, withCells: cells, withDelegate: self)
        startInfinityTableView(infinityTableView: tableViewStruct)
    }
    
    @IBAction func reset(sender: AnyObject) {
        resetInfinityTable()
    }
}

extension TestTableViewController: InfinityTableViewProtocol {
    func infinityData(atPage page: Int, withModifiers modifiers: InfinityModifers,
                             forSession session:String, completion: (responsePayload: ResponsePayload) -> ()) {

        if page == 1 {
            count = 0
        }
        
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
        
        // I'm returning more than one completiton here...to demonstrate multiple responses for a single session for a page will be ignored.
        // You only need to return one completion per page request.
        
        delay(3.0) {
            completion(responsePayload: ResponsePayload(dataCount: 10, lastPage: bool, page: page, session: session))
        }
        
        delay(4.5) {
            completion(responsePayload: ResponsePayload(dataCount: 10, lastPage: bool, page: page, session: session))
        }
        
        delay(6.0) {
            completion(responsePayload: ResponsePayload(dataCount: 10, lastPage: bool, page: page, session: session))
        }
        
        delay(7.0) {
            completion(responsePayload: ResponsePayload(dataCount: 10, lastPage: bool, page: page, session: session))
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
    
    func infinityTableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30.0
    }
}
