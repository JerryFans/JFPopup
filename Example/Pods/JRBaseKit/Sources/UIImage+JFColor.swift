//
//  UIImage+JFColor.swift
//  JRBaseKit
//
//  Created by 逸风 on 2021/10/10.
//

import UIKit

extension UIImage: JFCompatible {}
public extension JF where Base: UIImage {
    static func color(_ hex:UInt32, alpha:CGFloat = 1.0) -> UIImage {
        return UIImage(customColor: UIColor.jf.rgb(hex, alpha: alpha))
    }
}

public extension UIImage {
    @objc convenience init(customColor: UIColor,size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(customColor.cgColor);
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: cgImage)
    }
}
