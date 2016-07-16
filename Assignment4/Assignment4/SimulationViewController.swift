//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Patrick on 7/14/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

enum CellState:String{
    case Living = "Living"
    case Empty = "Empty"
    case Born = "Born"
    case Died = "Died"
    func description() -> String{
        return self.rawValue
    }
    func allValues() -> [CellState]{
        return [CellState.Living,CellState.Empty,CellState.Born,CellState.Died]
    }
    func toggle(value:CellState) -> CellState {
        switch value {
        case .Living, .Born:
            return .Empty
        case .Empty,.Died:
            return .Living
        }
    }
}