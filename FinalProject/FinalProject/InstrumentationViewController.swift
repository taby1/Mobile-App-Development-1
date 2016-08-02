//
//  FirstViewController.swift
//  FinalProject
//
//  Created by Patrick on 7/24/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController { //Icon from http://www.iconbeast.com
	override func viewDidLoad() {
		super.viewDidLoad()
        engine.cols = Int(colStepper.value)
        engine.rows = Int(rowStepper.value)
        colDisplay.text = "\(engine.cols)"
        rowDisplay.text = "\(engine.rows)"
        refreshLabel.text = "Refresh Rate: \(refreshSliderValue.value) Hz"
	}
    override func viewDidAppear(animated: Bool) {
        colDisplay.text = "\(engine.cols)"
        rowDisplay.text = "\(engine.rows)"
        rowStepper.value = Double(engine.rows)
        colStepper.value = Double(engine.cols)
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    
    var engine:EngineProtocol = StandardEngine.sharedInstance

    @IBOutlet weak var rowStepper: UIStepper!
    @IBOutlet weak var colStepper: UIStepper!
    @IBOutlet weak var rowDisplay: UITextField!
    @IBOutlet weak var colDisplay: UITextField!
    @IBAction func rowStepperClicked(sender: AnyObject) {
        if(rowStepper.value <= 100){
            engine.rows = Int(rowStepper.value)
        }
        else{
            engine.rows = Int((rowStepper.value - 100) * 10 + 100)
        }
        rowDisplay.text = "\(engine.rows)"
    }
    @IBAction func colStepperClicked(sender: AnyObject) {
        if(colStepper.value <= 100){
            engine.cols = Int(colStepper.value)
        }
        else{
            engine.cols = Int((colStepper.value - 100) * 10 + 100)
        }
        colDisplay.text = "\(engine.cols)"
    }
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var refreshSliderValue: UISlider!
    @IBAction func refreshSliderMoved(sender: AnyObject) {
        refreshLabel.text = "Refresh Rate: \(refreshSliderValue.value) Hz"
        if refreshSwitch.on{ engine.refreshRate = Double(1/refreshSliderValue.value)}
    }
    @IBAction func refreshSwitchMoved(sender: AnyObject) {
        if refreshSwitch.on{ engine.refreshRate = Double(1/refreshSliderValue.value)}
        else{engine.refreshRate = 0.0}
    }
    @IBOutlet weak var refreshSwitch: UISwitch!
}

