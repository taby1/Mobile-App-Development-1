//
//  Engine.swift
//  FinalProject
//
//  Created by Patrick on 7/24/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation


protocol GridProtocol{
	init(rows:Int, cols:Int)
	var rows:Int {get}
	var cols:Int {get}
	subscript(row: Int, col:Int) -> CellState { get set }
}

protocol EngineDelegate{
	func engineDidUpdate(withGrid:GridProtocol)
	func dimensionsDidChange(rows:Int, cols:Int)
}

protocol EngineProtocol{
	var delegate:EngineDelegate? {get set}
	var grid:GridProtocol{ get set}
	var refreshRate:Double {get set}
	var refreshTimer:NSTimer {get set}
	var rows:Int {get set}
	var cols:Int {get set}
	init(rows:Int, cols:Int)
	func step()
	var sharedInstance:EngineProtocol{get}
}

protocol GridViewDelegate{
	func touchChange(row:Int, col:Int, newState:CellState)	//Allows 'drawn' cells to be probagated to the engine object
}

typealias Position = (row:Int, col:Int)
class Cell:Hashable{	//Since I didn't know how to make typealiases conform to protocols
	var hashValue: Int{get{return self.position.col * self.position.row * self.state.rawValue}}
	
	required init(position:Position, state:CellState){
		_position = position
		_state = state
	}
	var _position:Position!
	var _state:CellState!
	var position:Position{get{return _position}}
	var state:CellState{get{return _state}}
}
func ==(lhs:Cell, rhs:Cell) -> Bool{return lhs.hashValue == rhs.hashValue}

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
	required init(rows: Int, cols: Int) {
		_rows = rows
		_cols = cols
	}
	let _rows:Int!
	let _cols: Int!
	var rows: Int{get{return _rows}}
	var cols: Int{get{return _cols}}
	var state = Set<Cell>()
	subscript(row:Int, col:Int) -> CellState{get{return CellState.Living.allValues().reduce(.Empty){state.contains(Cell(position: (row:row, col:col), state:$1)) ? $1 : $0}}
		set{
			CellState.Living.allValues().reduce(nil){self.state.contains(Cell(position: (row:row, col:col), state: $1)) ? self.state.remove(Cell(position: (row:row, col:col), state: $1)) : $0}
			if newValue != .Empty{self.state.insert(Cell(position: (row:row, col:col), state: newValue))}
		}
	}
}

//class StandardEngine:EngineProtocol{
//	init(rows: Int, cols: Int) {
//
//	}
//}