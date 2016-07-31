//
//  HomeViewController.swift
//  InfintyEngineV2
//
//  Created by Ryan Willis on 26/04/2016.
//  Copyright © 2016 RyanWillis. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    init() {
        super.init(nibName: "HomeViewController", bundle: NSBundle.mainBundle())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Infinity Engine Sample"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func collectionvViewBtn(sender: AnyObject) {
        //self.navigationController?.pushViewController(TestCollectionViewController(), animated: true)
    }
    
    @IBAction func tableViewBtn(sender: AnyObject) {
        self.navigationController?.pushViewController(TestTableViewController(), animated: true)
    }
}



