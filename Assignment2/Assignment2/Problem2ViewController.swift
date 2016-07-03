//
//  ViewController.swift
//  Assignment2
//
//  Created by Patrick on 6/29/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class Problem2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Problem 2"
        textField.text = "testing"
    }
    
    @IBAction func buttonPushed(sender: AnyObject) {
        print("Heya")
        textField.text = "Pushed!"
    }
    @IBOutlet weak var textField: UITextView!
}