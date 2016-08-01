//
//  DataStorage.swift
//  FinalProject
//
//  Created by Patrick on 8/1/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation

class StaticNames{
	private static var _sharedInstance = StaticNames()
	var sharedInstance:StaticNames{get{return StaticNames._sharedInstance}}
	var name:[Int:String] = [:]
}

class StaticPoints{
	private static var _sharedInstance = StaticPoints()
	var sharedInstance:StaticPoints{get{return StaticPoints._sharedInstance}}
	var grids:[String:[Position]] = [:]
}