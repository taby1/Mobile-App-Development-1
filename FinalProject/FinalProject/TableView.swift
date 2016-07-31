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
    private var savedNames:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    var loadedGrids:[String:[Position]] = [:]
    var savedGrids:[String:[Position]] = [:]

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
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return names.count
        case 1: return savedNames.count
        default: return 0
        }
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
        switch indexPath.section{
        case 0:nameLabel.text = names[row]; cell.tag = row
        case 1:nameLabel.text = savedNames[row]; cell.tag = names.count + row
        default:nameLabel.text = "Error"
        }
//        cell.tag = row
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            switch indexPath.section{
            case 0:
                break
//                names.removeAtIndex(indexPath.row)
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                loadedGrids.removeValueForKey(names[indexPath.row])
            case 1:
                savedGrids.removeValueForKey(savedNames[indexPath.row])
                savedNames.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath],withRowAnimation: .Automatic)
            default: break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let editingRow = (sender as! UITableViewCell).tag
        var editingString:String!
        if editingRow < names.count{editingString = names[editingRow]}
        else{editingString = ((sender as! UITableViewCell).textLabel?.text)!}
        guard let editingVC = segue.destinationViewController as? GridEditViewController
            else {
                preconditionFailure("Another wtf?")
        }
        editingVC.name = editingString
        editingVC.commit = {
//            editingRow < self.savedNames.count ? self.savedNames[editingRow] = $0 :
            self.savedNames.append($0)
            self.savedGrids[$0] = $1
        }
        editingVC.save = {
            self.savedNames.contains(editingString) ? (self.savedGrids[editingString] = $0) : (self.loadedGrids[editingString] = $0)
        }
        if let current = loadedGrids[editingString]{
            editingVC.points = current
            editingVC.cols = (current.reduce(0){$1.col > $0 ? $1.col : $0} + 1) * 2
            editingVC.rows = (current.reduce(0){$1.row > $0 ? $1.row : $0} + 1) * 2
            editingVC.rows > editingVC.cols ? (editingVC.cols = editingVC.rows) : (editingVC.rows = editingVC.cols)
        }
        if let current = savedGrids[editingString]{
            editingVC.points = current
            editingVC.cols = (current.reduce(0){$1.col > $0 ? $1.col : $0} + 1) * 2
            editingVC.rows = (current.reduce(0){$1.row > $0 ? $1.row : $0} + 1) * 2
            editingVC.rows > editingVC.cols ? (editingVC.cols = editingVC.rows) : (editingVC.rows = editingVC.cols)
        }
    }

}
