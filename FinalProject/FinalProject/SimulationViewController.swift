//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Patrick on 7/24/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate{

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        engine.delegate = self
        engine.refreshRate != 0.0 ? flowButton.setTitle("Pause", forState: .Normal) : flowButton.setTitle("Step", forState: .Normal)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    func engineDidUpdate(withGrid: GridProtocol) {
        
    }
    func dimensionsDidChange(rows: Int, cols: Int) {
        
    }
    func timerDidChange(newState: Bool) {   //where true is enabled
        newState ? flowButton.setTitle("Pause", forState: .Normal) : flowButton.setTitle("Step", forState: .Normal)
    }
    
    var engine:EngineProtocol = StandardEngine.sharedInstance

    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var gridAspect: NSLayoutConstraint!
    @IBAction func flowButtonClicked(sender: AnyObject) {
    }
    @IBAction func resetButtonClicked(sender: AnyObject) {
    }
    @IBOutlet weak var flowButton: UIButton!

}

