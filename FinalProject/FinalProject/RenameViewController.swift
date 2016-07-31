//
//  RenameViewController.swift
//  FinalProject
//
//  Created by labuser on 7/31/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class RenameViewController: UIViewController {

    var name:String?
    var commit: (String -> Void)?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func save(sender: AnyObject) {
        guard let newText = nameTextField.text, commit = commit
            else { return }
        commit(newText)
        if let controller = navigationController {controller.popViewControllerAnimated(true)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
