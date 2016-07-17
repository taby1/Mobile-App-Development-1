//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Patrick on 7/14/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBOutlet var lifeGrid: GridView!
	
	func engineDidUpdate(withGrid: GridProtocol) {
		lifeGrid.grid = withGrid
	}
}

@IBDesignable class GridView: UIView {
	@IBInspectable var rows:Int = 20{
		didSet{
			initCells()
			grid = Grid(rows: rows, cols: cols)
			redrawGrid = true
			self.setNeedsDisplay()
		}
	}
	@IBInspectable var cols:Int = 20{
		didSet{
			initCells()
			grid = Grid(rows: rows, cols: cols)
			redrawGrid = true
			self.setNeedsDisplay()
		}
	}
	@IBInspectable var livingColor:UIColor = UIColor.blueColor()
	@IBInspectable var emptyColor:UIColor = UIColor.whiteColor()
	@IBInspectable var bornColor:UIColor = UIColor.greenColor()
	@IBInspectable var diedColor:UIColor = UIColor.redColor()
	@IBInspectable var gridColor:UIColor = UIColor.blackColor()
	@IBInspectable var gridWidth:CGFloat = CGFloat(1.0){
		didSet{
			initCells()
		}
	}
	var grid:GridProtocol!
	var redrawGrid:Bool = false
	func initCells() {
		cells = [[(rect:CGRect!, touchState:Bool)]](count: rows, repeatedValue:[(rect:CGRect!, touchState:Bool)](count:cols, repeatedValue:(nil, false)))
		for i in 0..<rows{
			for j in 0..<cols{
				let width = (bounds.width / CGFloat(cols)) - (gridWidth + (gridWidth / CGFloat(cols)))
				let height = (bounds.height / CGFloat(rows)) - (1 * gridWidth)
				let x = CGFloat(j) * ((bounds.width - (CGFloat(cols + 1) * gridWidth)) / CGFloat(cols)) + (gridWidth * (CGFloat(j) + 1))   //Oh god jesus christ don't ask me about this
				let y = CGFloat(i) * ((bounds.height - (CGFloat(rows + 1) * gridWidth)) / CGFloat(rows)) + (gridWidth * (CGFloat(i) + 1))   //Oh god jesus christ don't ask me about this
				cells[i][j].rect = CGRect(x: x, y: y, width: width, height: height)
			}
		}
	}
	var cells:[[(rect:CGRect!, touchState:Bool)]] = []/* = [[CGRect!]](count: rows, repeatedValue:[CGRect!](count:cols, repeatedValue:nil))*/  //I get a funny feeling like this'll be useful later for touch detection as it is my understanding that checking for touches in individual rectanges is easy and this way I can just iterate through an array checking for touches
	
	override func drawRect(rect: CGRect) {
		if redrawGrid{
			initCells()
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
			redrawGrid = false
		}
		
		
		var cellPaths = UIBezierPath()
		cellPaths.lineWidth = CGFloat(0)
		for i in 0..<rows{
			for j in 0..<cols{
				cellPaths = (UIBezierPath(ovalInRect: cells[i][j].rect))
				switch grid[i, j]{
				case .Empty:
					emptyColor.setFill()
				case .Born:
					bornColor.setFill()
				case .Died:
					diedColor.setFill()
				case .Living:
					livingColor.setFill()
				}
				cellPaths.fill()
			}
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches{
			self.manageTouch(touch)
		}
	}
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches{
			self.manageTouch(touch)
		}
	}
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches{
			self.manageTouchToggle(touch)
		}
	}
	func manageTouchToggle(touch: UITouch){
		for i in 0..<rows{
			for j in 0..<cols{
				if CGRectContainsPoint(cells[i][j].rect, touch.locationInView(self)){
					grid[i, j] = grid[i, j].toggle(grid[i, j])
					setNeedsDisplayInRect(cells[i][j].rect)
					cells[i][j].touchState = false
				}
			}
		}
	}
	func manageTouch(touch: UITouch){
		for i in 0..<rows{
			for j in 0..<cols{
				if CGRectContainsPoint(cells[i][j].rect, touch.locationInView(self)){
					if !cells[i][j].touchState{
						cells[i][j].touchState = true
					}
				}
				else{
					if cells[i][j].touchState{
						grid[i, j] = grid[i, j].toggle(grid[i, j])
						setNeedsDisplayInRect(cells[i][j].rect)
						cells[i][j].touchState = false
					}
				}
			}
		}
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

class Grid:GridProtocol{
    required init(rows:Int, cols:Int){
        _cols = cols
        _rows = rows
        grid = [[CellState]](count:rows, repeatedValue:[CellState](count:cols, repeatedValue:.Empty))
    }
    var grid:[[CellState]]
    private var _rows:Int{
        didSet{
            grid = [[CellState]](count:rows, repeatedValue:[CellState](count:cols, repeatedValue:.Empty))
        }
    }
    private var _cols:Int{
        didSet{
            grid = [[CellState]](count:rows, repeatedValue:[CellState](count:cols, repeatedValue:.Empty))
        }
    }
    var rows: Int{
        get{
            return _rows
        }
    }
    var cols: Int{
        get{
            return _cols
        }
    }
    func neighbors(coordinates: (row: Int, col: Int)) -> [(row: Int, col: Int)] {
        var output:[(row:Int,col:Int)] = []
        output.append((coordinates.col+1,coordinates.row))
        output.append((coordinates.col+1,coordinates.row+1))
        output.append((coordinates.col,coordinates.row+1))
        output.append((coordinates.col-1,coordinates.row+1))
        output.append((coordinates.col-1,coordinates.row))
        output.append((coordinates.col-1,coordinates.row-1))
        output.append((coordinates.col,coordinates.row-1))
        output.append((coordinates.col+1,coordinates.row-1))
        for i in 0..<8 {
            output[i].col = output[i].col%cols  //doing fancy stuff with modulo - wrapping logic
            output[i].row = output[i].row%rows
        }
        return output
    }
    subscript(row:Int, col:Int) -> CellState{
        get{
            return grid[row][col]
        }
        set{
            grid[row][col] = newValue
            switch newValue{
            case .Empty, .Died:
                switch grid[row][col]{
                case .Living,.Born: //if it was alive and now needs to die
                    grid[row][col] = .Died
                case .Died:         //if it was just died and is still dead
                    grid[row][col] = .Empty
                case .Empty:            //if it was empty and is still dead
                    break
                }
            case .Living,.Born:
                switch grid[row][col]{
                case .Born:     //if it was just born and is still alive
                    grid[row][col] = .Living
                case .Empty,.Died:      //if it was dead and is now alive
                    grid[row][col] = .Born
                case .Living:       //if it was living and is still living
                    break
                }
            }
        }
    }
}