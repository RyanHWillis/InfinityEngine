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
    private var newEngine: NewEngine!

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
        let infinity = InfinityTable(tableView: self.tableView, loadingHeight: 50.0, dataSource: self)
        self.newEngine = NewEngine(infinityTableView: infinity)
        self.startInfinityListable(infinity)
    }
    
    func createTableViewEngine(_ infinityTableView: InfinityTable) -> TableViewEngine {
        return self.newEngine
    }
    
    @IBAction func resetInfinity() {
        self.resetInfinityTable()
    }
}

extension TestTableViewController: InfinityTableable {
    func infinity(_ tableView: UITableView, dataForPage page: Int, _ session: String, completion: @escaping (ResponsePayload) -> ()) {
        delay(1.0) { 
            completion(ResponsePayload(count: [8 * page, 3, 12], lastPage: false, session: session))
        }
    }
    func infinity(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
    }
    func infinity(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    func infinity(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        // Tap Logic
    }
}

class NewEngine: TableViewEngine {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.purple
        return view
    }
}
