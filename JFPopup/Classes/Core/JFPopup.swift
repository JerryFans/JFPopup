//
//  Popup.swift
//  PopupKit
//
//  Created by 逸风 on 2021/10/9.
//
import JRBaseKit
public struct JFPopup<Base> {
    public let base: Base 
    init(_ base: Base) {
        self.base = base
    }
}

public protocol JFPopupCompatible {}
public extension JFPopupCompatible {
    static var popup: JFPopup<Self>.Type {
        set {}
        get { JFPopup<Self>.self }
    }
    var popup: JFPopup<Self> {
        set {}
        get { JFPopup(self) }
    }
}
