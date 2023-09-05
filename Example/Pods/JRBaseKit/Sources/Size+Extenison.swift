//
//  Size+Extenison.swift
//  Example
//
//  Created by JerryFans on 2021/8/4.
//

import UIKit
extension Bool: JFCompatible {}
public extension JF where Base == Bool {
    static func isBangsiPhone() -> Bool {
       var isBangs = false
        if #available(iOS 11.0, *) {
            isBangs = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 > 0.0
        }
       return isBangs
    }
}

extension CGFloat: JFCompatible {}
public extension JF where Base == CGFloat {
    
    static func navigationBarHeight() -> CGFloat {
        return self.safeAreaInsets().top + 44.0
    }
    
    static func statusBarHeight() -> CGFloat {
        return self.safeAreaInsets().top
    }
    
    static func safeAreaBottomHeight() -> CGFloat {
        return self.safeAreaInsets().bottom
    }
    
    static func safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }
}

extension CGSize: JFCompatible {}
public extension JF where Base == CGSize {
    
    static func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    static func screenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
}
