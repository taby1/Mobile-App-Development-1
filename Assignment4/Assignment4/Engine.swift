//
//  ENgine.swift
//  Assignment3
//
//  Created by Patrick on 7/7/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation

class StandardEngine:EngineProtocol{
	private static var _engine = StandardEngine(rows: 20, cols: 20)
	static var engine:StandardEngine{
		get{
			return _engine
		}
	}
    var delegate: EngineDelegate?
	var _grid:GridProtocol! = nil{
        didSet{
			if let delegate = delegate{ delegate.engineDidUpdate(self._grid)}
			NSNotificationCenter.defaultCenter().postNotificationName("GridUpdate", object: nil, userInfo: ["newGrid":self._grid as! Grid])
        }
    }
    var grid: GridProtocol{
        get{return _grid}
    }
	var refreshRate: Double = 0
	var refreshTimer: NSTimer = NSTimer()	//Doesn't do anything, as we weren't told to do anything with it
	private var _rows:Int{
		didSet{
			self._grid = Grid(rows: rows, cols: cols)
			if let delegate = delegate{ delegate.engineDidUpdate(self._grid); delegate.dimensionsDidChange(rows, cols: cols)}
		}
	}
	private var _cols:Int{
		didSet{
			self._grid = Grid(rows: rows, cols: cols)
			if let delegate = delegate{ delegate.engineDidUpdate(self._grid); delegate.dimensionsDidChange(rows, cols: cols)}
		}
	}
    var rows: Int{
        get{return _rows}
		set{_rows = newValue}
    }
    var cols: Int{
        get{return _cols}
		set{_cols = newValue}
    }
    required init(rows: Int, cols: Int) {
        _rows = rows
        _cols = cols
		_grid = Grid(rows: _rows, cols: _cols)
    }
    func step() -> GridProtocol {
        var output:GridProtocol = Grid(rows: rows, cols: cols)
        for i in 0..<rows{    //step through 1 generation
            for j in 0..<cols{
                var coords = (row:0, col:0) //'cause I don't want no enums
                coords.row = i + rows
                coords.col = j + cols
                
                var toCheck = self.grid.neighbors(coords)
                var aliveNeighbors = 0
                for k in 0..<8{ //counts number of living neighbors
                    if((grid[toCheck[k].row,toCheck[k].col] == .Living) || (grid[toCheck[k].row,toCheck[k].col] == .Born)) {
                        aliveNeighbors += 1
                    }
                }
                coords.row = coords.row%rows
                coords.col = coords.col%cols
                
                switch aliveNeighbors{
                case 0,1:
                    output[coords.row,coords.col] = .Empty
                case 2:
                    output[coords.row, coords.col] = _grid[coords.row,coords.col]
                case 3:
                    output[coords.row, coords.col] = .Living
                case 4,5,6,7,8:
                    output[coords.row, coords.col] = .Empty
                default:
                    output[coords.row, coords.col] = .Empty
                }
            }
        }
        for i in 0..<rows{
            for j in 0..<cols{
                _grid[i, j] = output[i,j]
            }
        }
        return output
    }
}

