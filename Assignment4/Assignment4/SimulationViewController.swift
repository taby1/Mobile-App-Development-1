//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Patrick on 7/14/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, GridViewDelegate{	//Icon from http://www.iconbeast.com

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		lifeGrid.grid = Grid(rows: lifeEngine.rows, cols: lifeEngine.cols)
		lifeEngine.delegate = self
		lifeGrid.delegate = self
//		lifeEngine.rows = lifeGrid.rows
//		lifeEngine.cols = lifeGrid.cols
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func touchChange(row: Int, col: Int, newState: CellState) {
		lifeEngine._grid[row,col] = newState
	}
	func engineDidUpdate(withGrid: GridProtocol) {
		lifeGrid.grid = withGrid
	}
//	var lifeEngine = StandardEngine(rows: 20, cols: 20)
	var lifeEngine = StandardEngine.engine
	
	@IBOutlet weak var lifeGrid: GridView!
	@IBAction func stepButtonClicked(sender: AnyObject) {
		
		lifeEngine.step()
	}
}

