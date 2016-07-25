//
//  ViewController.swift
//  Lectrue 10
//
//  Created by Patrick on 7/25/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBOutlet weak var textView: UITextView!
	@IBAction func fetch(sender: AnyObject) {
		let url = NSURL(string: "http://www.google.com/")!
		let fetcher = Fetcher()
		fetcher.requestJSON(url) { (json, message) in
			let op = NSBlockOperation{
				if let json = json{
					self.textView.text = json.description
				}
				else if let message = message{
					self.textView.text = message
				}
				else{
					self.textView.text = "SLDKJF"
				}
			}
			NSOperationQueue.mainQueue().addOperation(op)
		}
	}

}

