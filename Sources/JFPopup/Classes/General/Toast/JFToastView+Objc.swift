//
//  JFToastView+Objc.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/19.
//

import UIKit

@objc public enum JFToastObjcAssetType: Int {
    case unknow
    case success
    case fail
    case imageName
}

public extension JFToastView {
    
    @objc class func toast(hit: String) {
        JFToastView.toast(hit: hit, type: .unknow, imageName: nil)
    }
    
    @objc class func toast(icon: JFToastObjcAssetType, imageName: String?) {
        JFToastView.toast(hit: nil, type: icon, imageName: imageName)
    }
    
    @objc class func toast(hit: String?, type: JFToastObjcAssetType, imageName: String?) {
        var options: [JFToastOption] = []
        if let hit = hit {
            options += [.hit(hit)]
        }
        if type != .unknow {
            var iconType: JFToastAssetIconType?
            if type == .success {
                iconType = .success
            } else if type == .fail {
                iconType = .fail
            } else if let name = imageName, type == .imageName {
                iconType = .imageName(name: name, imageType: "png")
            }
            if let icon = iconType {
                options += [.icon(icon)]
            }
        }
        JFPopupView.popup.toast {
            options
        }
    }
}
