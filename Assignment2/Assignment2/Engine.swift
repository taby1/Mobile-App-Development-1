//
//  Engine.swift
//  Assignment2
//
//  Created by Patrick on 7/4/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation

func step(arrayIn:[[Bool]]) -> [[Bool]] {
    let ySize = arrayIn.count
    let xSize = arrayIn[0].count
    var after:[[Bool]] = []
    for i in 0..<ySize{    //initialize after[] to be full of 'falses'
        after.append([])
        for _ in 0..<xSize{
            after[i].append(false)
        }
    }
    for i in 0..<ySize{    //step through 1 generation
        for j in 0..<xSize{
            var coords = (x:0, y:0) //'cause I don't want no enums
            coords.y = i + ySize
            coords.x = j + xSize   //I want to do some fancy stuff with modulo.
            var toCheck = neighbors(coords)
            var aliveNeighbors = 0
            for k in 0..<8{ //does wrapping logic
                toCheck[k].x = toCheck[k].x%xSize  //doing fancy stuff with modulo - wrapping logic
                toCheck[k].y = toCheck[k].y%ySize
                if(arrayIn[toCheck[k].y][toCheck[k].x]) {
                    aliveNeighbors += 1
                }
            }
            coords.x = coords.x%xSize
            coords.y = coords.y%ySize
            switch aliveNeighbors{
            case 0,1:
                after[coords.y][coords.x] = false
            case 2:
                if arrayIn[coords.y][coords.x]{
                    after[coords.y][coords.x] = true
                }
            case 3:
                after[coords.y][coords.x] = true
            case 4,5,6,7,8:
                after[coords.y][coords.x] = false
            default:
                break
            }
        }
    }
    return after
}

func neighbors(coordinates:(x:Int, y:Int)) -> [(x:Int,y:Int)] {
    var output:[(x:Int,y:Int)] = []
    output.append((coordinates.x+1,coordinates.y))
    output.append((coordinates.x+1,coordinates.y+1))
    output.append((coordinates.x,coordinates.y+1))
    output.append((coordinates.x-1,coordinates.y+1))
    output.append((coordinates.x-1,coordinates.y))
    output.append((coordinates.x-1,coordinates.y-1))
    output.append((coordinates.x,coordinates.y+1))
    output.append((coordinates.x+1,coordinates.y-1))
    return output
}