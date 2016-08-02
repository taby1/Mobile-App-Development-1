//
//  TableView.swift
//  FinalProject
//
//  Created by Patrick Yoon on 7/30/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

//Derived from Ronald Simmons' Lecture 11 code

import UIKit

class TableView: UITableViewController, UITextFieldDelegate{
    
	var names = StaticNames().sharedInstance
	var grids = StaticPoints().sharedInstance
	
	override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.gridSaved(_:)), name: "GridSaved", object: nil)
        let url = NSURL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json")!
        URLField.delegate = self
        guard grids.loadedGrids.isEmpty else{return}
        let fetcher = Fetcher()
        fetcher.requestJSON(url) { (json, message) in
            if let json = json, array = json as? Array<Dictionary<String, AnyObject>>{
                array.reduce(0){
                    if let name = $1["title"] as? String, points = $1["contents"] as? [[Int]]{
						self.grids.loadedGrids[self.addToLoad(name)] = points.map{return Position(row: $0[0], col: $0[1])}
					}
					return $0 + 1
                }
//                self.names = Array(self.loadedGrids.keys)
				
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
    
    
    @IBOutlet weak var URLField: UITextField!
    @IBAction func reloadClicked(sender: AnyObject) {
        URLField.endEditing(true)
        guard let text = URLField.text, url = NSURL(string: text) else{URLField.text = ""; return}
        let fetcher = Fetcher()
        fetcher.requestJSON(url) { (json, message) in
            if let json = json, array = json as? Array<Dictionary<String, AnyObject>>{
                self.names.loadedNames.removeAll()
                self.grids.loadedGrids.removeAll()
                self.URLField.text = ""
                array.reduce(0){
                    if let name = $1["title"] as? String, points = $1["contents"] as? [[Int]]{
                        self.grids.loadedGrids[self.addToLoad(name)] = points.map{return Position(row: $0[0], col: $0[1])}
                    }
                    return $0 + 1
                }
                let op = NSBlockOperation {
                    self.tableView.reloadData()
                }
                NSOperationQueue.mainQueue().addOperation(op)
            }
            if let message = message{
                let op = NSBlockOperation{
                    let alert = UIAlertController(title: "Invalid URL", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                NSOperationQueue.mainQueue().addOperation(op)
            }
            if json == nil && message == nil{
                let op = NSBlockOperation{
                    let alert = UIAlertController(title: "Network Error", message: "Invalid JSON received", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.URLField.text = ""
                }
                NSOperationQueue.mainQueue().addOperation(op)
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {    //can't make gesture recognizer or touchesBegan() work, so this is it.
        URLField.resignFirstResponder()
        return true
    }
    
    
    
    //MARK: Stuff for adding rows
    @IBAction func addName(sender: AnyObject) {
        add("Add new grid...")
    }
    
    @objc func gridSaved(notification: NSNotification) {
        if let data = notification.userInfo, points = data["grid"] as? PointsContainer, name = data["name"] as? String{
            let tag = add(name)
            grids.savedGrids[tag] = points.points
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    func add(name:String) -> Int{
		var tag = 0
		while(names.tags.contains(tag)){tag += 1}	//I'm actually not sure why this compiles, but it looks like it should work.
        var runningName = name
        let existingNames = (names.savedNames.map{$0.1} + names.loadedNames.map{$0.1})
        while(existingNames.contains(runningName)){runningName += "(copy)"}
		names.savedNames[tag] = runningName
        let itemRow = names.savedNames.count - 1
        let itemPath = NSIndexPath(forRow:itemRow, inSection: 1)
		let op = NSBlockOperation {
            self.tableView.insertRowsAtIndexPaths([itemPath], withRowAnimation: .Automatic)
            self.tableView.reloadData()
        }
		NSOperationQueue.mainQueue().addOperation(op)
		return tag
    }
    func addToLoad(name:String) -> Int{
        var tag = 0
        while(names.tags.contains(tag)){tag += 1}	//I'm actually not sure why this compiles, but it looks like it should work.
        var runningName = name
        let existingNames = (names.savedNames.map{$0.1} + names.loadedNames.map{$0.1})
        while(existingNames.contains(runningName)){runningName += "(copy)"}
        names.loadedNames[tag] = runningName
        return tag
    }
	
    //MARK: UITableViewDelegation
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return names.loadedNames.count
        case 1: return names.savedNames.count
        default: return 0
        }
    }
	
	//Generates cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Default")else {preconditionFailure("missing Default reuse identifier")}
        let row = indexPath.row
        guard let nameLabel = cell.textLabel else {preconditionFailure("Cell has no textLabel")}
        switch indexPath.section{
        case 0:
			let tag = Array(names.loadedNames.keys)[row]
			nameLabel.text = names.loadedNames[tag]
			cell.tag = tag
		case 1:
			let tag = Array(names.savedNames.keys)[row]
			nameLabel.text = names.savedNames[tag]
			cell.tag = tag
        default:nameLabel.text = "Error"
        }
        return cell
    }
	
	//Cell Delete Handler
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                               forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
			guard let cell = tableView.cellForRowAtIndexPath(indexPath) else{preconditionFailure("There was no matching cell for that indexPath")}
            switch indexPath.section{
            case 0:
                break
//                names.removeAtIndex(indexPath.row)
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                loadedGrids.removeValueForKey(names[indexPath.row])
            case 1:
				grids.savedGrids.removeValueForKey(cell.tag)
                names.savedNames.removeValueForKey(cell.tag)
                tableView.deleteRowsAtIndexPaths([indexPath],withRowAnimation: .Automatic)
            default: break
            }
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tag = (sender as! UITableViewCell).tag
        var editingString:String!
		Array(names.loadedNames.keys).contains(tag) ? (editingString = names.loadedNames[tag]) : (editingString = names.savedNames[tag])
        guard let editingVC = segue.destinationViewController as? GridEditViewController
            else {
                preconditionFailure("Another wtf?")
        }
        editingVC.name = editingString
        editingVC.commit = {
			//$1 is the grid, $0 is the new name
			self.grids.savedGrids[self.add($0)] = $1
        }
        editingVC.save = {     //$1 is grid, $0 is new name
			self.grids.savedGrids[tag] = $1
            self.names.savedNames[tag] = $0
            let op = NSBlockOperation {self.tableView.reloadData()}
            NSOperationQueue.mainQueue().addOperation(op)
        }
        if let current = grids.loadedGrids[tag]{
            editingVC.points = current
            editingVC.cols = (current.reduce(0){$1.col > $0 ? $1.col : $0} + 1) * 2
            editingVC.rows = (current.reduce(0){$1.row > $0 ? $1.row : $0} + 1) * 2
            editingVC.rows > editingVC.cols ? (editingVC.cols = editingVC.rows) : (editingVC.rows = editingVC.cols)
        }
        if let current = grids.savedGrids[tag]{
            editingVC.points = current
            editingVC.cols = (current.reduce(0){$1.col > $0 ? $1.col : $0} + 1) * 2
            editingVC.rows = (current.reduce(0){$1.row > $0 ? $1.row : $0} + 1) * 2
            editingVC.rows > editingVC.cols ? (editingVC.cols = editingVC.rows) : (editingVC.rows = editingVC.cols)
        }   //making the gridview square
    }

}
