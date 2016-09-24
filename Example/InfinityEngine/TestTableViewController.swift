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

    init() {
        super.init(nibName: "TestTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    func setupTableView() {
        let cells = InfinityCells(cellNames: ["TestTableViewCell", "SectionCell"], loadingCellName: "LoadingTableViewCell", bundle: nil)
        let tableView = InfinityTableView(withTableView: self.tableView, withCells: cells, withDataSource: self)
        self.startInfinityTableView(infinityTableView: tableView)
    }
    
    @IBAction func reset(_ sender: AnyObject) {
        self.resetInfinityTable()
    }
}

extension TestTableViewController: InfinityTableProtocol {
    func tableView(_ tableView: UITableView, withDataForPage page: Int, forSession session: String, completion: (ResponsePayload) -> ()) {
        completion(ResponsePayload(count: [8, 3, 12 * page * page], lastPage: false, session: session))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
    }
    
    func tableView(_ tableView: UITableView, withLoadingCellItemForIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as! LoadingTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath, forLoadingCell loadingCell: Bool) -> CGFloat {
        if loadingCell {
            return 30.0
        }
        return 98.0
    }
}
