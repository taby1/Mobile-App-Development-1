//
//  ViewController.swift
//  Assignment3
//
//  Created by Patrick on 7/7/16.
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

    @IBAction func stepButton(sender: AnyObject) {
        var tempState:[[Bool]] = [[Bool]](count: lifeGrid.rows, repeatedValue:[Bool](count:lifeGrid.cols, repeatedValue: false))
        for i in 0..<lifeGrid.rows{     //reading lifeGrid's grid array into a format step() can handle
            for j in 0..<lifeGrid.cols{
                switch lifeGrid.grid[i][j]{
                case .Born,.Living:
                    tempState[i][j] = true
                default:
                    tempState[i][j] = false
                }
            }
        }
        tempState = step2(tempState)
        for i in 0..<lifeGrid.rows{     //reading back into lifeGrid's grid array
            for j in 0..<lifeGrid.cols{
                switch tempState[i][j]{
                case true:
                    lifeGrid.grid[i][j] = .Living
                default:
                    lifeGrid.grid[i][j] = .Empty
                }
            }
        }
        
    }

    @IBOutlet weak var lifeGrid: GridView!
}

