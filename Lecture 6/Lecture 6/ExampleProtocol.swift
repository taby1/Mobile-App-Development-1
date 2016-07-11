//
//  ExampleProtocol.swift
//  Lecture 6
//
//  Created by Patrick on 7/11/16.
//  Copyright © 2016 Taby Corp. All rights reserved.
//

import Foundation


protocol ExampleProtocol {
    var rows:UInt{get set}
    var cols:UInt{get set}
    func step() -> [[Bool]]
}

protocol ExampleDelegateProtocol{
    func example(example:Example, didUpdateRows:UInt)
}

class Example:ExampleProtocol{
    var rows: UInt = 20{
        didSet{
            if let delegate = delegate{
                delegate.example(self, didUpdateRows: rows)
            }
        }
    }
    var cols: UInt = 20
    var delegate:ExampleDelegateProtocol?
    func step() -> [[Bool]] {
        return [[]]
    }
}

class ExampleDelegate:ExampleDelegateProtocol{
    func example(example: Example, didUpdateRows: UInt) {
        print("Nothing")
    }
}