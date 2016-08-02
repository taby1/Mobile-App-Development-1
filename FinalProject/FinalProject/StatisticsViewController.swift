//
//  StatisticsViewController.swift
//  FinalProject
//
//  Created by Patrick on 7/28/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController { //Icon from http://www.iconbeast.com

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateHandler(_:)), name: "GridUpdated", object: nil)
        updateHandler(NSNotification(name: "GridUpdated", object: nil))
    }
    override func viewDidAppear(animated: Bool) {
        updateHandler(NSNotification(name: "GridUpdated", object: nil))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var livingLabel: UILabel!
    @IBOutlet weak var diedLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!

    var engine:EngineProtocol = StandardEngine.sharedInstance
    
    func updateHandler(notification: NSNotification){
        let temp = engine.grid.ofInterest
        bornLabel.text = "Born: \(temp.reduce(0){$1.state == .Born ? $0 + 1 : $0})"
        diedLabel.text = "Died: \(temp.reduce(0){$1.state == .Died ? $0 + 1 : $0})"
        livingLabel.text = "Living: \(temp.reduce(0){$1.state == .Living ? $0 + 1 : $0})"
        emptyLabel.text = "Empty: \((engine.rows * engine.cols) - temp.count)"
    }
}
