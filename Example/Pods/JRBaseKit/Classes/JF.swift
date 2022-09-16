//
//  JF.swift
//  Example
//
//  Created by JerryFans on 2021/8/4.
//
import UIKit
public struct JF<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol JFCompatible {}
public extension JFCompatible {
    static var jf: JF<Self>.Type {
        set {}
        get { JF<Self>.self }
    }
    var jf: JF<Self> {
        set {}
        get { JF(self) }
    }
}


