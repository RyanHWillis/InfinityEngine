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
        
        self.tableView.register(UINib(nibName: "TestTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TestTableViewCell")

        let tableView = InfinityTable(withTableView: self.tableView, withDataSource: self)
        self.startInfinityTableView(infinityTableView: tableView)
    }
    
    @IBAction func reset(_ sender: AnyObject) {
        self.resetInfinityTable()
    }
}

extension TestTableViewController: InfinityListable {
    func infinity(_ tableView: UITableView, withDataForPage page: Int, forSession session: String, completion: @escaping (ResponsePayload) -> (Void)) {
        delay(2.0) { 
            completion(ResponsePayload(count: [8 * page, 3, 12], lastPage: false, session: session))
        }
    }
    
    func infinity(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
    }
    
    func infinity(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath, forLoadingCell loadingCell: Bool) -> CGFloat {
        if loadingCell {
            return 30.0
        }
        return 98.0
    }
}


