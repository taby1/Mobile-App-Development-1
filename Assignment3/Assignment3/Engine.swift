//
//  ENgine.swift
//  Assignment3
//
//  Created by Patrick on 7/7/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation
import UIKit

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

@IBDesignable class GridView: UIView {
    @IBInspectable var rows:Int = 20{
        didSet{
            grid = [[CellState]](count: rows/2, repeatedValue:[CellState](count: cols/2, repeatedValue: .Empty))
        }
    }
    @IBInspectable var cols:Int = 20{
        didSet{
            grid = [[CellState]](count: rows/2, repeatedValue:[CellState](count: cols/2, repeatedValue: .Empty))
        }
    }
    @IBInspectable var livingColor:UIColor = UIColor.blueColor()
    @IBInspectable var emptyColor:UIColor = UIColor.whiteColor()
    @IBInspectable var bornColor:UIColor = UIColor.greenColor()
    @IBInspectable var diedColor:UIColor = UIColor.redColor()
    @IBInspectable var gridColor:UIColor = UIColor.blackColor()
    @IBInspectable var gridWidth:CGFloat = CGFloat(1.0)
    var grid:[[CellState]]!
    
    override func drawRect(rect: CGRect) {
        
    }
}


