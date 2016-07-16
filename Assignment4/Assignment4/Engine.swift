//
//  ENgine.swift
//  Assignment3
//
//  Created by Patrick on 7/7/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation


func step2(arrayIn:[[Bool]]) -> [[Bool]] {
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
            coords.x = j + xSize
            
            var toCheck = neighbors(coords, sizeX: xSize, sizeY: ySize) //takes size constraints so can be used with arbitrarily sized arrays
            var aliveNeighbors = 0
            for k in 0..<8{ //counts number of living neighbors
                if(arrayIn[toCheck[k].y][toCheck[k].x]) {
                    aliveNeighbors += 1
                }
            }
            coords.y = coords.y%ySize
            coords.x = coords.x%xSize
            
            switch aliveNeighbors{
            case 0,1:
                after[coords.y][coords.x] = false
            case 2:
                after[coords.y][coords.x] = arrayIn[coords.y][coords.x]
            case 3:
                after[coords.y][coords.x] = true
            case 4,5,6,7,8:
                after[coords.y][coords.x] = false
            default:
                after[coords.y][coords.x] = false
            }
        }
    }
    return after
}

func neighbors(coordinates:(x:Int, y:Int), sizeX:Int, sizeY:Int) -> [(x:Int,y:Int)]{    //In case you're pedantic; takes size constraints so can be used with arbitrarily sized arrays
    var around = simpleNeighbors(coordinates)
    for i in 0..<8 {
        around[i].x = around[i].x%sizeX  //doing fancy stuff with modulo - wrapping logic
        around[i].y = around[i].y%sizeY
    }
    return around
}


func simpleNeighbors(coordinates:(x:Int, y:Int)) -> [(x:Int,y:Int)] { //You see, I had already made this function in problem 2 because it's a reasonable thing to do
    var output:[(x:Int,y:Int)] = []
    output.append((coordinates.x+1,coordinates.y))
    output.append((coordinates.x+1,coordinates.y+1))
    output.append((coordinates.x,coordinates.y+1))
    output.append((coordinates.x-1,coordinates.y+1))
    output.append((coordinates.x-1,coordinates.y))
    output.append((coordinates.x-1,coordinates.y-1))
    output.append((coordinates.x,coordinates.y-1))
    output.append((coordinates.x+1,coordinates.y-1))
    return output
}