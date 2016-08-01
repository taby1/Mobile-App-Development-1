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
	var savedNames:[Int:String] = [:]
	var loadedNames:[Int:String] = [:]
	func tagOf(name:String) -> Int{
		if (savedNames as NSDictionary).allKeysForObject(name).count > 0{return (savedNames as NSDictionary).allKeysForObject(name)[0] as! Int}
		if (loadedNames as NSDictionary).allKeysForObject(name).count > 0{return (loadedNames as NSDictionary).allKeysForObject(name)[0] as! Int}
		return -1
	}
	var tags:[Int]{get{return Array(savedNames.keys) + Array(loadedNames.keys)}}
}

class StaticPoints{
	private static var _sharedInstance = StaticPoints()
	var sharedInstance:StaticPoints{get{return StaticPoints._sharedInstance}}
	var savedGrids:[Int:[Position]] = [:]
	var loadedGrids:[Int:[Position]] = [:]
}