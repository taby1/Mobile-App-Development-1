//
//  Protocols.swift
//  FinalProject
//
//  Created by Patrick on 7/26/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation

protocol GridProtocol{
	init(rows:Int, cols:Int)
	var rows:Int {get set}
	var cols:Int {get set}
	subscript(pos: Position) -> CellState { get set }
	var ofInterest:[Cell] {get set}
    var state:Set<Cell> {get}
}

protocol EngineDelegate{
	func engineDidUpdate(withGrid:GridProtocol)
	func dimensionsDidChange(rows:Int, cols:Int)
    func timerDidChange(newState:Bool)
}

protocol EngineProtocol{
	var delegate:EngineDelegate? {get set}
	var grid:GridProtocol{ get set}
	var refreshRate:Double {get set}
	var refreshTimer:NSTimer? {get set}
	var rows:Int {get set}
	var cols:Int {get set}
	init(rows:Int, cols:Int)
	func step() -> GridProtocol
}

protocol GridViewDelegate{
	func touchChange(row:Int, col:Int, newState:CellState)	//Allows 'drawn' cells to be propagated to the engine object
}