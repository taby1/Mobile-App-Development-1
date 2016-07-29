//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Patrick on 7/24/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, GridViewDelegate{

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        engine.delegate = self
        gridView.delegate = self
        engine.refreshRate != 0.0 ? flowButton.setTitle("Pause", forState: .Normal) : flowButton.setTitle("Step", forState: .Normal)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    func engineDidUpdate(withGrid: GridProtocol) {
        gridView.grid.state.subtract(withGrid.state).map{gridView.setCell($0.position, state: .Empty)}
        gridView.grid.state.exclusiveOr(withGrid.state).map{gridView.setCell($0.position, state: $0.state)}
//        gridView.grid = withGrid
//        gridView.setNeedsDisplay()
    }
    func dimensionsDidChange(rows: Int, cols: Int) {
        gridView.rows = rows
        gridView.cols = cols
    }
    func timerDidChange(newState: Bool) {   //where true is enabled
        newState ? flowButton.setTitle("Pause", forState: .Normal) : flowButton.setTitle("Step", forState: .Normal)
    }
    
    func touchChange(row: Int, col: Int, newState: CellState) {
        engine.grid[(row:row, col:col)] = newState
    }
    
    var engine:EngineProtocol = StandardEngine.sharedInstance
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var gridAspect: NSLayoutConstraint!
    @IBAction func flowButtonClicked(sender: AnyObject) {
        engine.step()
    }
    @IBAction func resetButtonClicked(sender: AnyObject) {
    }
    @IBOutlet weak var flowButton: UIButton!

}

