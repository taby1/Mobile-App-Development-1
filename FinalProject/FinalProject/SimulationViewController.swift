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
    }
    func dimensionsDidChange(rows: Int, cols: Int) {
        gridView.rows = rows
        gridView.cols = cols
        gridView.setNeedsDisplay()
    }
    func timerDidChange(newState: Bool) {   //where true is enabled
        newState ? flowButton.setTitle("Pause", forState: .Normal) : flowButton.setTitle("Step", forState: .Normal)
    }
    
    func touchChange(row: Int, col: Int, newState: CellState) {
        engine.grid[(row:row, col:col)] = newState
    }
    
    var engine:EngineProtocol = StandardEngine.sharedInstance
    
    @IBOutlet weak var gridView: GridView!
    @IBAction func flowButtonClicked(sender: AnyObject) {
        guard let text = flowButton.titleLabel?.text else{return }
        switch text{
        case "Pause":
            engine.refreshTimer?.invalidate()
            flowButton.setTitle("Resume", forState: .Normal)
        case "Resume":
            engine.refreshRate = engine.refreshRate
            flowButton.setTitle("Pause", forState: .Normal)
        case "Step":
            engine.step()
        default:
            print("ugoh")
        }
    }
    @IBAction func resetButtonClicked(sender: AnyObject) {
        engine.grid = Grid(rows: engine.rows, cols: engine.cols)
        gridView.setNeedsDisplay()
    }
    @IBOutlet weak var flowButton: UIButton!

}

