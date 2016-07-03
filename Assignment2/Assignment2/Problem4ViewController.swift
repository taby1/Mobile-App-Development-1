//
//  ViewController.swift
//  Assignment2
//
//  Created by Patrick on 6/29/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class Problem4ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Problem 4"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPushed(sender: AnyObject) {
        textField.text = "Pushed!"
        print("buttonpushed")
        

    }
    
    @IBOutlet weak var textField: UITextView!
}