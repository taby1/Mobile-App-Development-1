//
//  TableView.swift
//  FinalProject
//
//  Created by Patrick Yoon on 7/30/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

//Derived from Ronald Simmons' Lecture 11 code

import UIKit

class TableView: UITableViewController {
    
    private var names:Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    var loadedGrids:[String:[Position]] = [:]

    override func viewDidAppear(animated: Bool) {
        let url = NSURL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")!
        let fetcher = Fetcher()
        fetcher.requestJSON(url) { (json, message) in
            if let json = json, array = json as? Array<Dictionary<String, AnyObject>>{
//                self.names = array.map{if let result = $0["title"] as? String{return result}
//                else{return "Error"}}
                array.map{
                    if let result = $0["title"] as? String, points = $0["contents"] as? [[Int]]{self.loadedGrids[result] = points.map{return Position(row: $0[0], col: $0[1])}}
                    else{self.loadedGrids["Error"] = []}
                }
                self.names = Array(self.loadedGrids.keys)
                let op = NSBlockOperation {
                    self.tableView.reloadData()
                }
                NSOperationQueue.mainQueue().addOperation(op)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addName(sender: AnyObject) {
        names.append("Add new name...")
        let itemRow = names.count - 1
        let itemPath = NSIndexPath(forRow:itemRow, inSection: 0)
        tableView.insertRowsAtIndexPaths([itemPath], withRowAnimation: .Automatic)
    }
    
    //MARK: UITableViewDelegation
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Default")
            else {
                preconditionFailure("missing Default reuse identifier")
        }
        let row = indexPath.row
        guard let nameLabel = cell.textLabel else {
            preconditionFailure("wtf?")
        }
        nameLabel.text = names[row]
        cell.tag = row
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            names.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath],
                                             withRowAnimation: .Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let editingRow = (sender as! UITableViewCell).tag
        let editingString = names[editingRow]
        guard let editingVC = segue.destinationViewController as? GridEditViewController
            else {
                preconditionFailure("Another wtf?")
        }
        editingVC.name = editingString
        editingVC.commit = {
            self.names[editingRow] = $0
            let indexPath = NSIndexPath(forRow: editingRow, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath],
                                                  withRowAnimation: .Automatic)
        }
        if let current = loadedGrids[editingString]{
            editingVC.points = current
            editingVC.cols = (current.reduce(0){$1.col > $0 ? $1.col : $0} + 1) * 2
            editingVC.rows = (current.reduce(0){$1.row > $0 ? $1.row : $0} + 1) * 2
            editingVC.rows > editingVC.cols ? (editingVC.cols = editingVC.rows) : (editingVC.rows = editingVC.cols)
        }
    }

}
