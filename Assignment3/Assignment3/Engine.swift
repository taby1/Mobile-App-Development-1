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
            grid = [[CellState]](count: rows, repeatedValue:[CellState](count: cols, repeatedValue: .Empty))
        }
    }
    @IBInspectable var cols:Int = 20{
        didSet{
            grid = [[CellState]](count: rows, repeatedValue:[CellState](count: cols, repeatedValue: .Empty))
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
        
        let gridPath = UIBezierPath()
        gridPath.lineWidth = gridWidth
        for i in 0..<cols + 1{
            let xPos:CGFloat = (CGFloat(CGFloat(i) * (bounds.width / CGFloat(cols)))) * ((bounds.width - gridWidth) / bounds.width) + gridWidth / 2     //Slight scale and translate so the gridlines don't get clipped off the edge
            gridPath.moveToPoint(CGPoint(x: xPos, y: 0))
            gridPath.addLineToPoint(CGPoint(x: xPos, y: bounds.height))
        }
        for i in 0..<rows + 1{
            let yPos:CGFloat = (CGFloat(CGFloat(i) * (bounds.height / CGFloat(rows)))) * ((bounds.height - gridWidth) / bounds.height) + gridWidth / 2     //Slight scale and translate so the gridlines don't get clipped off the edge
            gridPath.moveToPoint(CGPoint(x: 0, y: yPos))
            gridPath.addLineToPoint(CGPoint(x: bounds.width, y: yPos))
        }
        gridColor.setStroke()
        gridPath.stroke()
    }
}


