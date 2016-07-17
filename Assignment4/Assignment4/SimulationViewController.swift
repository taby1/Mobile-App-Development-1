//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Patrick on 7/14/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		lifeGrid.grid = Grid(rows: lifeEngine.rows, cols: lifeEngine.cols)
		lifeEngine.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func engineDidUpdate(withGrid: GridProtocol) {
		lifeGrid.grid = withGrid
	}
	var lifeEngine = StandardEngine(rows: 20, cols: 20)
	@IBOutlet weak var lifeGrid: GridView!
}

