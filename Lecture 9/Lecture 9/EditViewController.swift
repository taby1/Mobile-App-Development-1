//
//  EditViewController.swift
//  Lecture 9
//
//  Created by Patrick on 7/20/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
	
	var name:String?
	var commit:(String -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		nameTextField.text = name
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	@IBAction func save(sender: AnyObject) {
		guard let newText = nameTextField.text, commit = commit else{
			return
		}
		commit(newText)
		navigationController!.popViewControllerAnimated(true)
	}
	
	@IBOutlet weak var nameTextField: UITextField!
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}