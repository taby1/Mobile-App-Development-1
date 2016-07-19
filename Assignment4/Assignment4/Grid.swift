//
//  Grid.swift
//  Assignment4
//
//  Created by Patrick on 7/19/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation

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
	var rows: Int{get{return _rows}}
	var cols: Int{get{return _cols}}
	func neighbors(coordinates: (row: Int, col: Int)) -> [(row: Int, col: Int)] {
		var output:[(row:Int,col:Int)] = []
		output.append((coordinates.row+1,coordinates.col))
		output.append((coordinates.row+1,coordinates.col+1))
		output.append((coordinates.row,coordinates.col+1))
		output.append((coordinates.row-1,coordinates.col+1))
		output.append((coordinates.row-1,coordinates.col))
		output.append((coordinates.row-1,coordinates.col-1))
		output.append((coordinates.row,coordinates.col-1))
		output.append((coordinates.row+1,coordinates.col-1))
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
		set{		//Does living/born died/empty logic in set method; abstracts away this logic so engine can pretend grid has only living/empty states
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