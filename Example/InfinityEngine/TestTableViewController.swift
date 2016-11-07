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
        self.tableView.register(UINib(nibName: "TestTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TestTableViewCell")
        self.startInfinity()
    }
    
    func startInfinity() {
        self.startInfinityListable(InfinityTable(self.tableView, loadingHeight: 40.0, self))
    }
    
    @IBAction func resetInfinity() {
        self.resetInfinityTable()
    }
}

extension TestTableViewController: InfinityListable {
    func infinity(_ tableView: UITableView, dataForPage page: Int, _ session: String, completion: @escaping (ResponsePayload) -> ()) {
        completion(ResponsePayload(count: [8 * page, 3, 12], lastPage: false, session: session))
    }
    func infinity(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
    }
    func infinity(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}


