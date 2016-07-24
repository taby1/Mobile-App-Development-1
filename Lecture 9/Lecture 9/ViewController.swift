//
//  ViewController.swift
//  Lecture 9
//
//  Created by Patrick on 7/20/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	private var names = ["Van", "Nate", "JP"]

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
			else{
				preconditionFailure("Missing 'Default' reuse identifier")
		}
		let row = indexPath.row
		guard let nameLabel = cell.textLabel else{
			preconditionFailure("asdf")
		}
		nameLabel.text = names[row]
		cell.tag = row
		return cell
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete{
			names.removeAtIndex(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		}
	}
	
	
	
	@IBAction func addName(sender: AnyObject) {
		names.append("Add new name...")
		let itemRow = names.count - 1
		let itemPath = NSIndexPath(forRow: itemRow, inSection: 0)
		tableView.insertRowsAtIndexPaths([itemPath], withRowAnimation: .Automatic)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let editingRow = (sender as! UITableViewCell).tag
		let editingString = names[editingRow]
		guard let editingVC = segue.destinationViewController as? EditViewController else{
			preconditionFailure("al;sdkfja;sdlkj")
		}
		editingVC.name = editingString
		editingVC.commit = {
			self.names[editingRow] = $0
			let indexPath = NSIndexPath(forRow: editingRow, inSection: 0)
			self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		}
	}
}

