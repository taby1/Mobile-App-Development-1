//
//  GridEditViewController.swift
//  FinalProject
//
//  Created by labuser on 7/30/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class GridEditViewController: UIViewController, EngineDelegate, GridViewDelegate {

    var name:String?
    var commit: ((name: String, points:[Position]) -> Void)?
    var save: ((points:[Position]) -> Void)?
    var points:[Position]?
    var rows:Int! = 5
    var cols:Int! = 5
    var section:Int?
    
    @IBAction func saveAs(sender: AnyObject) {
        guard let newText = name, commit = commit
            else { return }
        commit(name: newText, points:self.gridView.points)
        navigationController!.popViewControllerAnimated(true)
    }
    @IBAction func load(sender: AnyObject) {
        singleEngine.cols = cols
        singleEngine.rows = rows
        singleEngine.grid = gridView.grid
        tabBarController?.selectedIndex = 1
        navigationController?.popViewControllerAnimated(false)
    }
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonClicked(sender: AnyObject) {
        if let save = save{save(points: gridView.points)}
        navigationController!.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let points = points{gridView.points = points}
        if let rows = rows, cols = cols{
            gridView.rows = rows
            gridView.cols = cols
            engine.cols = cols
            engine.rows = rows
        }
        engine.delegate = self
        gridView.delegate = self
        engine.grid = gridView.grid
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let renameVC = segue.destinationViewController as? RenameViewController, name = name else{preconditionFailure("you done done it")}
        renameVC.name = name
        renameVC.commit = {
            self.name = $0
            self.saveAs(Grid(rows: 0, cols: 0))   //Couldn't think of a good placeholder object
        }
    }
    
    func engineDidUpdate(withGrid: GridProtocol) {
        gridView.grid.state.subtract(withGrid.state).map{gridView.setCell($0.position, state: .Empty)}
        gridView.grid.state.exclusiveOr(withGrid.state).map{gridView.setCell($0.position, state: $0.state)}
    }
    func dimensionsDidChange(rows: Int, cols: Int) {
        return
    }
    func timerDidChange(newState: Bool) {
        return
    }
    func touchChange(row: Int, col: Int, newState: CellState) {
        engine.grid[(row:row, col: col)] = newState
    }
    
    var singleEngine:EngineProtocol = StandardEngine.sharedInstance
    var engine:EngineProtocol = StandardEngine(rows: 5, cols: 5)
    @IBOutlet weak var gridView: GridView!
}