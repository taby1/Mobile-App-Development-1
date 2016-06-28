//: Playground - noun: a place where people can play

import Foundation


let immutableSTring = "heelo, playground"
var str = "Hello, playground"


var myInt = 42
let myConstant = 50/100
let thingy:Double = 50/100

let implicitDouble = 70.0
let explicitDouble:Double = 70

let label = "the width is "
let width = 94
let widthLabel = label + String(width)
String(94)

let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let orangeSummary = "I have \(oranges) oranges."
var tiny:int_fast8_t = 23
//commenbt?
var shoppingList:Array<String> = ["catfish","water","blue aint"]
var copyList = shoppingList
shoppingList.append("toothpaste")
//var cool:Array<Array<String>> = [["heya","hi"],["bye","goodbye"]]
shoppingList[0]
copyList
var occupations:Dictionary<String,String> = [
    "malcom":"captain",
    "Kaylee":"mechanic"
]
occupations["Jayne"] = "Public Relations"
occupations

var occupationNames = occupations.map{(k:String,String) -> String in
    return k
}// == occupations.map {return $0.0} == occupations.map {$0.0}
occupationNames
//var moreNames = occupation.map{$0.0}.map{$0; return "blah" }

var r = 50...100
var g = r.generate()

g.next()
g.next()
var g1 = [11,21,31,41,51].generate()
g1.next()
g1.next()

var tuple1 = (1,2)
tuple1.0
tuple1.1

var tuple2 = (first:"van", last:"Simmons", seventh:"Son")
tuple2.0
tuple2.first
tuple2.last
tuple2.seventh
for (k,v) in occupations {
    print("\(k),\(v)")
}

func doubler(x:Int) -> Int{
    return x*2
}

doubler(4)
doubler(123)


func progression(v:Int,f:Int->Int) ->Int{
    return f(v)
}

progression(4, f: doubler)

var tf = false
tf = true

var oohThingy = [
[true,false,true],
[false,true,false]
]

var arrArr:Array<Array<Bool>> = [[true]]

var closure = {(x:Int) -> Int in
    return x*2
}
closure(6)
progression(6, f: closure)

progression(6) {(x:Int) -> Int in
    return x*2
}

var n:String? = nil
n = "Hi hell0"
n = nil

var optional:Int? = nil
var implicitOptional:Int!
//optional=18
if let blah = optional{
    let doubleOptional = doubler(blah)
}

doubler(implicitOptional)






