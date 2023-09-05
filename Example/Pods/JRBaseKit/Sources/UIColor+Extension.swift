//
//  UIColor+Extension.swift
//  Example
//
//  Created by JerryFans on 2021/8/4.
//

import UIKit
extension UIColor: JFCompatible {}
public extension JF where Base: UIColor {
    //0xRRGGBB
    static func rgb(_ hex:UInt32, alpha:CGFloat = 1.0) -> UIColor {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex & 0x0000FF       ) / divisor
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    //0xRRGGBBAA
    static func rgba(_ hex:UInt32) -> UIColor {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex & 0x000000FF       ) / divisor
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha == 0 ? 1 : alpha)
    }
    
    static func argb(_ hex:UInt32) -> UIColor {
        let divisor = CGFloat(255)
        let alpha     = CGFloat((hex & 0xFF000000) >> 24) / divisor
        let red        = CGFloat((hex & 0x00FF0000) >> 16) / divisor
        let green    = CGFloat((hex & 0x0000FF00) >>  8) / divisor
        let blue   = CGFloat( hex & 0x000000FF       ) / divisor
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha == 0 ? 1 : alpha)
    }
}
