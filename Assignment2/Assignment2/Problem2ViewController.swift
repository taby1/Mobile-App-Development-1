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
        for i in 0..<arraySizeY{    //step through 1 generation
            for j in 0..<arraySizeX{
                var coords = (x:0, y:0) //'cause I don't want no enums
                coords.y = i + arraySizeY
                coords.x = j + arraySizeX   //I want to do some fancy stuff with modulo.
                var toCheck = simpleNeighbors(coords) //I rather preemtively made this function because that was much easier
                var aliveNeighbors = 0
                for k in 0..<8{ //does wrapping logic
                    toCheck[k].x = toCheck[k].x%arraySizeX  //doing fancy stuff with modulo - wrapping logic
                    toCheck[k].y = toCheck[k].y%arraySizeY
                    if(before[toCheck[k].y][toCheck[k].x]) {
                        aliveNeighbors += 1
                    }
                }
                coords.x = coords.x%arraySizeX
                coords.y = coords.y%arraySizeY
                switch aliveNeighbors{
                case 0,1:
                    after[coords.y][coords.x] = false
                case 2:
                    if before[coords.y][coords.x]{
                        after[coords.y][coords.x] = true
                    }
                case 3:
                    after[coords.y][coords.x] = true
                case 4,5,6,7,8:
                    after[coords.y][coords.x] = false
                default:
                    break
                }
            }
        }
        
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
//    func neighbors(coordinates:(x:Int, y:Int)) -> [(x:Int,y:Int)] {   //First made neighbors() here before moving to Engine.swift
//        var output:[(x:Int,y:Int)] = []
//        output.append((coordinates.x+1,coordinates.y))
//        output.append((coordinates.x+1,coordinates.y+1))
//        output.append((coordinates.x,coordinates.y+1))
//        output.append((coordinates.x-1,coordinates.y+1))
//        output.append((coordinates.x-1,coordinates.y))
//        output.append((coordinates.x-1,coordinates.y-1))
//        output.append((coordinates.x,coordinates.y+1))
//        output.append((coordinates.x+1,coordinates.y-1))
//        return output
//    }
    @IBOutlet weak var textField: UITextView!
}