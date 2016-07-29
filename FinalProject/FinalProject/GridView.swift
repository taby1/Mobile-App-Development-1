//
//  GridView.swift
//  FinalProject
//
//  Created by Patrick on 7/28/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {
	@IBInspectable var rows:Int = 20{
		didSet{
			grid.rows = rows
		}
	}
	@IBInspectable var cols:Int = 20{
		didSet{
			grid.cols = cols
		}
	}
	@IBInspectable var livingColor:UIColor = UIColor.blueColor(){didSet{colors = [.Living:livingColor, .Died:diedColor, .Born:bornColor, .Empty:emptyColor]}}
	@IBInspectable var emptyColor:UIColor = UIColor.whiteColor(){didSet{colors = [.Living:livingColor, .Died:diedColor, .Born:bornColor, .Empty:emptyColor]}}
	@IBInspectable var bornColor:UIColor = UIColor.greenColor(){didSet{colors = [.Living:livingColor, .Died:diedColor, .Born:bornColor, .Empty:emptyColor]}}
	@IBInspectable var diedColor:UIColor = UIColor.redColor(){didSet{colors = [.Living:livingColor, .Died:diedColor, .Born:bornColor, .Empty:emptyColor]}}
	private var colors:[CellState:UIColor]! = nil
	
	var grid:GridProtocol = Grid(rows: 20, cols: 20)
	
    var delegate:GridViewDelegate?
    
    override func drawRect(rect: CGRect) {
        let xSize = bounds.width / CGFloat(cols)
        let ySize = bounds.height / CGFloat(rows)
		if (bounds.height == rect.height) && (bounds.width == rect.width){	//If we're redrawing the entire thing
			for row in (0..<rows){
				for col in (0..<cols){
					let rect:CGRect = CGRect(x: CGFloat(col) * xSize, y: CGFloat(row) * ySize, width: xSize, height: ySize)
					CellState.Living.allValues().reduce(emptyColor){grid[(row:row, col:col)] == $1 ? colors[$1]! : $0}.setFill()
					UIBezierPath(rect: rect).fill()
				}
			}
		}
		else{	//if we're only drawing a subsection of the screen
			let minY = Int(floor(CGRectGetMinY(rect) / ySize))  //figure out which cell indexes need to be redrawn
            let minX = Int(floor(CGRectGetMinX(rect) / xSize))
            let maxY = Int(ceil(CGRectGetMaxY(rect) / ySize))
            let maxX = Int(ceil(CGRectGetMaxX(rect) / xSize))
            for row in (minY..<maxY){
                for col in (minX..<maxX){
                    let rect:CGRect = CGRect(x: CGFloat(col) * xSize, y: CGFloat(row) * ySize, width: xSize, height: ySize)
                    CellState.Living.allValues().reduce(emptyColor){grid[(row:row, col:col)] == $1 ? colors[$1]! : $0}.setFill()
                    UIBezierPath(rect: rect).fill()
                }
            }
		}
    }
    func getRect(y:CGFloat, x:CGFloat) -> Position{ //takes coordinate pair and determines what rectange they're in
        let xSize = bounds.width / CGFloat(cols)
        let ySize = bounds.height / CGFloat(rows)
        return (row:Int(floor(y / ySize)), col:Int(floor(x / xSize)))
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let nowTouch = touch.locationInView(self)
            self.manageTouch(touch)
            let currentCell = getRect(nowTouch.y, x: nowTouch.x)
            if let delegate = delegate{delegate.touchChange(currentCell.row, col: currentCell.col, newState: grid[(row:currentCell.row, col: currentCell.col)].toggle())}
            grid[(row:currentCell.row, col:currentCell.col)] = grid[(row:currentCell.row, col:currentCell.col)].toggle()
            let xSize = bounds.width / CGFloat(cols)
            let ySize = bounds.height / CGFloat(rows)
            self.setNeedsDisplayInRect(CGRect(x: CGFloat(currentCell.col) * xSize, y: CGFloat(currentCell.row) * ySize, width: xSize, height: ySize))
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            self.manageTouch(touch)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _ in touches{
        }
    }
    func manageTouch(touch: UITouch){
        let prevTouch = touch.previousLocationInView(self)
        let nowTouch = touch.locationInView(self)
        if getRect(prevTouch.y, x: prevTouch.x) != getRect(nowTouch.y, x: nowTouch.x) { //if the touch moved over into a new cell
            let currentCell = getRect(nowTouch.y, x: nowTouch.x)
            if let delegate = delegate{delegate.touchChange(currentCell.row, col: currentCell.col, newState: grid[(row:currentCell.row, col: currentCell.col)].toggle())}
            grid[(row:currentCell.row, col:currentCell.col)] = grid[(row:currentCell.row, col:currentCell.col)].toggle()
            let xSize = bounds.width / CGFloat(cols)
            let ySize = bounds.height / CGFloat(rows)
            self.setNeedsDisplayInRect(CGRect(x: CGFloat(currentCell.col) * xSize, y: CGFloat(currentCell.row) * ySize, width: xSize, height: ySize))
        }
    }
}