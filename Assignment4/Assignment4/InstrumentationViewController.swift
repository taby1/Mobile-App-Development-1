//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Patrick on 7/14/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {	//Icon from http://www.iconbeast.com

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		lifeEngine.cols = Int(colStepperOut.value)
		lifeEngine.rows = Int(rowStepperOut.value)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	var lifeEngine = StandardEngine.engine

	@IBAction func rowStepper(sender: UIStepper) {
		lifeEngine.rows = Int(rowStepperOut.value)
		rowsDisplay.text = "\(lifeEngine.rows)"
	}
	@IBAction func columnStepper(sender: AnyObject) {
		lifeEngine.cols = Int(colStepperOut.value)
		colsDisplay.text = "\(lifeEngine.cols)"
	}
	@IBAction func refreshSlider(sender: AnyObject) {
	}
	@IBAction func refreshSwitch(sender: AnyObject) {
	}
	@IBOutlet weak var rowStepperOut: UIStepper!
	@IBOutlet weak var colStepperOut: UIStepper!
	@IBOutlet weak var refreshSliderOut: UISlider!
	@IBOutlet weak var refreshSwitchOut: UISwitch!
	@IBOutlet weak var rowsDisplay: UITextField!
	@IBOutlet weak var colsDisplay: UITextField!
}

