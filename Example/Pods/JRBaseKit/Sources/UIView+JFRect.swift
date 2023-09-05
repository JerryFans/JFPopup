//
//  UIView+JFRect.swift
//  JRBaseKit
//
//  Created by 逸风 on 2021/10/10.
//
import UIKit

extension UIView: JFCompatible {}
public extension JF where Base: UIView {

    var top: CGFloat {
        get { return base.jf_top }
        set { base.jf_top = newValue }
    }
    
    var left: CGFloat {
        get { return base.jf_left }
        set { base.jf_left = newValue }
    }
    
    var bottom: CGFloat {
        get { return base.jf_bottom }
        set { base.jf_bottom = newValue }
    }
    
    var right: CGFloat {
        get { return base.jf_right }
        set { base.jf_right = newValue }
    }
    
    var centerX: CGFloat {
        get { return base.jf_centerX }
        set { base.jf_centerX = newValue }
    }
    
    var centerY: CGFloat {
        get { return base.jf_centerY }
        set { base.jf_centerY = newValue }
    }
    
    var width: CGFloat {
        get { return base.jf_width }
        set { base.jf_width = newValue }
    }
    
    var height: CGFloat {
        get { return base.jf_height }
        set { base.jf_height = newValue }
    }
    
    var origin: CGPoint {
        get { return base.jf_origin }
        set { base.jf_origin = newValue }
    }
    
    var size: CGSize {
        get { return base.jf_size }
        set { base.jf_size = newValue }
    }
    
    @available(iOS 10.0, *)
    static func shake() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    @available(iOS 10.0, *)
    func shake() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

}

//MARK: - For OC
public extension UIView {
    @objc var jf_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame:CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    @objc var jf_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame:CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    @objc var jf_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame:CGRect = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
    
    @objc var jf_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame:CGRect = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }
    
    @objc var jf_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = .init(x: newValue, y: self.center.y)
        }
    }
    
    @objc var jf_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = .init(x: self.center.x, y: newValue)
        }
    }
    
    @objc var jf_width: CGFloat {
        get {
            return self.bounds.width
        }
        set {
            var frame:CGRect = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    @objc var jf_height: CGFloat {
        get {
            return self.bounds.height
        }
        set {
            var frame:CGRect = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    @objc var jf_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame:CGRect = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    @objc var jf_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame:CGRect = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
}
