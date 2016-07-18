//
//  Protocols.swift
//  Assignment4
//
//  Created by Patrick on 7/14/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation


protocol GridProtocol{
    init(rows:Int, cols:Int)
    var rows:Int {get}
    var cols:Int {get}
    func neighbors(coordinates:(row:Int, col:Int)) -> [(row:Int,col:Int)]
    subscript(row: Int, col:Int) -> CellState { get set }
}

protocol EngineDelegate{
    func engineDidUpdate(withGrid:GridProtocol)
	func dimensionsDidChange(rows:Int, cols:Int)
}

protocol EngineProtocol{
    var delegate:EngineDelegate? {get set}
    var grid:GridProtocol{ get}
    var refreshRate:Double {get set}
    var refreshTimer:NSTimer {get set}
    var rows:Int {get set}
    var cols:Int {get set}
    init(rows:Int, cols:Int)
    func step() -> GridProtocol
}

protocol GridViewDelegate{	//because I can't think of a way which fits in the bounds of the assignment of changing the EngineProtcol object's grid to reflect changes which originate in gridView, like drawing on the screen
	func touchChange(row:Int, col:Int, newState:CellState)	//Allows 'drawn' cells to be probagated to the engine object 
}