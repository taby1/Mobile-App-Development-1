//
//  ENgine.swift
//  Assignment3
//
//  Created by Patrick on 7/7/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation

class StandardEngine:EngineProtocol{
	private static var _engine = StandardEngine(rows: 10, cols: 10)
	static var engine:StandardEngine{
		get{
			return _engine
		}
	}
    var delegate: EngineDelegate
	var _grid:GridProtocol! = nil{
        didSet{
            delegate.engineDidUpdate(self._grid)
			let center = NSNotificationCenter.defaultCenter()
			let n = NSNotification(name: "GridUpdate", object: nil, userInfo: ["hey":"name"])
			center.postNotification(n)
        }
    }
    var grid: GridProtocol{
        get{return _grid}
    }
	var refreshRate: Double = 0//{     //WIP
//		didSet{
//			if self.refreshRate != 0{
//				if let refreshTimer = refreshTimer {refreshTimer.invalidate()}
//				let sel = #selector(StandardEngine.step())
//				refreshTimer = NSTimer.scheduledTimerWithTimeInterval
//			}
//		}
//	}
	var refreshTimer: NSTimer = NSTimer()
	var _rows:Int{
		didSet{
			self._grid = Grid(rows: rows, cols: cols)
		}
	}
	var _cols:Int{
		didSet{
			self._grid = Grid(rows: rows, cols: cols)
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
    }
    func step() -> GridProtocol {
        var output:GridProtocol = Grid(rows: rows, cols: cols)
        for i in 0..<rows{    //step through 1 generation
            for j in 0..<cols{
                var coords = (col:0, row:0) //'cause I don't want no enums
                coords.row = i + rows
                coords.col = j + cols
                
                var toCheck = self.grid.neighbors(coords)
                var aliveNeighbors = 0
                for k in 0..<8{ //counts number of living neighbors
                    if(grid[toCheck[k].row,toCheck[k].col] == (.Alive || .Born)) {
                        aliveNeighbors += 1
                    }
                }
                coords.row = coords.row%rows
                coords.col = coords.col%cols
                
                switch aliveNeighbors{
                case 0,1:
                    output[coords.row,coords.col] = .Empty
                case 2:
                    output[coords.row][coords.col] = arrayIn[coords.row][coords.col]
                case 3:
                    output[coords.row][coords.col] = true
                case 4,5,6,7,8:
                    output[coords.row][coords.col] = false
                default:
                    output[coords.row][coords.col] = false
                }
            }
        }
        for i in 0..<rows{
            for j in 0..<cols{
                _grid[row:i, col:j] = output[i,j]
            }
        }
        return output
    }
}