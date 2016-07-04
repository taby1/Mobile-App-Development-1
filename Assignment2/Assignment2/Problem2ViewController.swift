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
        let arraySizeY = 10 //In the event I want to change the size (which I suspect will happen at some point)
        let arraySizeX = 10
//        textField.text = "Pushed!"    //placeholder
        //Initializing and counting before:[[Bool]]
        var before:[[Bool]] = []
        for i in 0..<arraySizeY{
            before.append([])
            for _ in 0..<arraySizeX{
                if arc4random_uniform(3) == 1{
                    before[i].append(true)
                }
                else{
                    before[i].append(false)
                }
            }
        }
        var count = 0
        for i in 0..<arraySizeY{
            for j in 0..<arraySizeX{
                if before[i][j] {
                    count += 1
                }
            }
        }
        print(count)
        textField.text = "\(count)"
        //Running the first generation
        var after:[[Bool]] = []
        for i in 0..<arraySizeY{    //initialize after[] to be full of 'falses'
            after.append([])
            for _ in 0..<arraySizeX{
                after[i].append(false)
            }
        }
        var afterCount = 0
        after = step(before)
        
        for i in 0..<arraySizeY{    //count live cells after a generation
            for j in 0..<arraySizeX{
                if after[i][j] {
                    afterCount += 1
                }
            }
        }
        print(afterCount)
        textField.text = "\(afterCount) currently alive"
    }
    @IBOutlet weak var textField: UITextView!
}