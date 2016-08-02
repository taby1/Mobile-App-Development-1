//
//  Engine.swift
//  FinalProject
//
//  Created by Patrick on 7/24/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation

typealias Position = (row:Int, col:Int)
struct Cell:Hashable{
	var hashValue: Int{get{return self.position.col * self.position.row * self.state.rawValue}}
	
	init(position:Position, state:CellState){
		_position = position
		_state = state
	}
	var _position:Position!
	var _state:CellState!
	var position:Position{get{return _position}}
	var state:CellState{get{return _state}}
}
func ==(lhs:Cell, rhs:Cell) -> Bool{return (lhs.position == rhs.position) && (lhs.state == rhs.state)}
struct Coordinates:Hashable{
	init(row:Int, col:Int){
		self.row = row
		self.col = col
	}
	var row:Int
	var col:Int
	var hashValue: Int{get{return row * col}}
}
func ==(lhs:Coordinates, rhs:Coordinates) -> Bool{return (lhs.row == rhs.row) && (lhs.col == rhs.col)}
func ==(lhs:Coordinates, rhs:Position) -> Bool{return (lhs.row == rhs.row) && (lhs.col == rhs.col)}

enum CellState:Int{
	case Living
	case Empty
	case Born
	case Died
	func description() -> String{
		switch self{
		case .Born:
			return "Born"
		case .Living:
			return "Living"
		case .Died:
			return "Died"
		case .Empty:
			return "Empty"
		}
	}
	func allValues() -> [CellState]{
		return [CellState.Living,CellState.Empty,CellState.Born,CellState.Died]
	}
	func toggle() -> CellState {
		switch self {
		case .Living, .Born:
			return .Died
		case .Empty,.Died:
			return .Born
		}
	}
	func isLiving() -> Bool{
		switch self{
		case .Living, .Born: return true
		case .Died, .Empty: return false
		}
	}
}

class Grid:GridProtocol{
	required init(rows: Int, cols: Int) {
		_rows = rows
		_cols = cols
	}
	var _rows:Int!{didSet{self.state = Set(self.state.filter{$0.position.row <= rows})}}
	var _cols:Int!{didSet{self.state = Set(self.state.filter{$0.position.col <= cols})}}
	var rows: Int{
		get{return _rows}
		set{_rows = newValue}
	}
	var cols: Int{
		get{return _cols}
		set{_cols = newValue}
	}
	var state = Set<Cell>()
	subscript(pos: Position) -> CellState{
		get{return CellState.Living.allValues().reduce(.Empty){state.contains(Cell(position: (row:pos.row, col:pos.col), state:$1)) ? $1 : $0}}
		set{
			CellState.Living.allValues().reduce(nil){self.state.contains(Cell(position: (row:pos.row, col:pos.col), state: $1)) ? self.state.remove(Cell(position: (row:pos.row, col:pos.col), state: $1)) : $0}
			if newValue != .Empty{self.state.insert(Cell(position: (row:pos.row, col:pos.col), state: newValue))}
		}
	}
	var ofInterest: [Cell]{get{return Array(state)}
		set{state = Set(newValue)}
	}
		//Sorry I couldn't conscience putting neighbors() here so it's in Engine
}

class StandardEngine:EngineProtocol{
	private static var _sharedInstance: EngineProtocol = StandardEngine(rows: 20, cols: 20)
	static var sharedInstance: EngineProtocol{get{return _sharedInstance}}
	required init(rows: Int, cols: Int) {
		_rows = rows
		_cols = cols
		self.grid = Grid(rows: rows, cols: cols)
	}
    var _rows:Int{didSet{if let delegate = delegate{delegate.dimensionsDidChange(rows, cols:cols)}}}
	var _cols:Int{didSet{if let delegate = delegate{delegate.dimensionsDidChange(rows, cols:cols)}}}
	var rows: Int{get{return _rows}
		set{_rows = newValue}}
	var cols: Int{get{return _cols}
		set{_cols = newValue}}
	
	var delegate: EngineDelegate?
    var grid: GridProtocol{
        didSet{
            if let delegate=delegate {delegate.engineDidUpdate(self.grid)}
        }
    }
	
    var refreshRate: Double = 0{    //timer handling methods derived from Ronald Simmons' ProjectPrototype code
        didSet{
            if refreshRate != 0{
                refreshTimer?.invalidate()
                refreshTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(refreshRate), target: self, selector: #selector(StandardEngine.timerHandler(_:)), userInfo: nil, repeats: true)
            }
            else{
                refreshTimer?.invalidate()
                refreshTimer = nil
            }
            if let _ = refreshTimer, delegate = delegate{
                delegate.timerDidChange(true)
            }
            else if let delegate = delegate{
                delegate.timerDidChange(false)
            }
        }
    }
    var refreshTimer: NSTimer?
    @objc func timerHandler(_:NSTimer){
        self.step()
    }
	
	func step() -> GridProtocol{
        var nextGen:[Coordinates:Int] = [:]
		(grid.ofInterest.filter{$0.state.isLiving()}).map{	//iterates through living Cell()s
			neighbors($0.position).map{	//for every living cell iterates through it's neighbors
				let coords = Coordinates(row: $0.row, col: $0.col)
				nextGen.keys.contains(coords) ? (nextGen[coords]! += 1) : (nextGen[coords] = 1)
			}
		}
		var newGrid:GridProtocol = Grid(rows: self.rows, cols: self.cols)
		nextGen.map{
			let currentPos = (row:$0.0.row, col:$0.0.col)
			switch $0.1{
			case 2 where grid[currentPos].isLiving(), 3 where grid[currentPos].isLiving(): newGrid[currentPos] = .Living
			case 3 where !grid[currentPos].isLiving(): newGrid[currentPos] = .Born
			case _ where grid[currentPos].isLiving(): newGrid[currentPos] = .Died
			default: newGrid[currentPos] = .Empty
			}
		}
		self.grid = newGrid
		if let delegate = delegate { delegate.engineDidUpdate(grid) }
        NSNotificationCenter.defaultCenter().postNotificationName("GridUpdated", object: nil)
		return self.grid
	}
	func numberIn(toFind: Position, within:[Position]) -> Int{
		return within.reduce(0){$1 == toFind ? $0 + 1: $0}
	}
	func neighbors(pos: Position) -> [Position] {   //Derived from Ronald Simmons' ProjectPrototype Code
        return StandardEngine.offsets.map { (row:(pos.row + rows + $0.row) % rows, col:
			(pos.col + cols + $0.col) % cols) }
	}
	private static let offsets:[Position] = [   //Derived from Ronald Simmons' ProjectPrototype Code
		(-1, -1), (-1, 0), (-1, 1),
		( 0, -1),          ( 0, 1),
		( 1, -1), ( 1, 0), ( 1, 1)
	]
}