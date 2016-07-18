//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Patrick on 7/16/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {	//Icon from http://www.iconbeast.com
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateHandler(_:)), name: "GridUpdate", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//	@objc func updateHandler(notification:NSNotification){
//		counts.empty = 0;counts.living = 0;counts.empty = 0; counts.died = 0
//		if let userInfo = notification.userInfo{
//			if let thing = userInfo["newGrid"]{
//				let newGrid:GridProtocol = thing as! GridProtocol
//				for i in 0..<newGrid.rows{
//					for j in 0..<newGrid.cols{
//						switch newGrid[i, j]{
//						case .Living:
//							counts.living += 1
//						case .Empty:
//							counts.empty += 1
//						case .Born:
//							counts.born += 1
//						case .Died:
//							counts.died += 1
//						}
//					}
//				}
//			}
//		}
//		emptyLabel.text = "Empty: \(counts.empty)"
//		livingLabel.text = "Living: \(counts.living)"
//		bornLabel.text = "Just Born: \(counts.born)"
//		diedLabel.text = "Just Died: \(counts.died)"
//	}
	var counts = (empty:0, living:0, born:0, died:0)
	@IBOutlet weak var emptyLabel: UILabel!
	@IBOutlet weak var livingLabel: UILabel!
	@IBOutlet weak var bornLabel: UILabel!
	@IBOutlet weak var diedLabel: UILabel!
	
}