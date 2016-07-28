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
	
	override func drawRect(rect: CGRect) {
		if (bounds.height == rect.height) && (bounds.width == rect.width){	//If we're redrawing the entire thing
			let xSize = bounds.width / CGFloat(cols)
			let ySize = bounds.height / CGFloat(rows)
			for row in (0..<rows){
				for col in (0..<cols){
					let rect:CGRect = CGRect(x: CGFloat(col) * xSize, y: CGFloat(row) * ySize, width: xSize, height: ySize)
					CellState.Living.allValues().reduce(emptyColor){grid[(row:row, col:col)] == $1 ? colors[$1]! : $0}.setFill()
					UIBezierPath(rect: rect).fill()
				}
			}
		}
	}
}
