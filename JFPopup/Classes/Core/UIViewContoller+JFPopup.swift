//
//  UIViewContoller+Popup.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/9.
//

import UIKit
extension UIViewController: JFPopupCompatible {}

public extension JFPopup where Base: UIViewController {
    
    func dismissPopup() {
        if let navi = base.presentedViewController as? UINavigationController, let vc = navi.viewControllers.first as? JFPopupController {
            vc.closeVC(with: nil)
        }
    }
    
    /// popup a bottomSheet with your custom view
    /// - Parameters:
    ///   - isDismissible: default true, will tap bg auto dismiss
    ///   - enableDrag: default true, will enable drag animate
    ///   - bgColor: background view color
    ///   - container: your custom view
    func bottomSheet(with isDismissible: Bool = true, enableDrag: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: () -> UIView) {
        var config: JFPopupConfig = .bottomSheet
        config.isDismissible = isDismissible
        config.enableDrag = enableDrag
        config.bgColor = bgColor
        let view = container()
        let vc = JFPopupController(with: config) {
            view
        }
        vc.show(with: base)
    }
    
    
    /// popup a drawer style view with your custom view
    /// - Parameters:
    ///   - direction: left or right
    ///   - isDismissible: default true, will tap bg auto dismiss
    ///   - enableDrag: default true, will enable drag animate
    ///   - bgColor: background view color
    ///   - container: your custom view
    func drawer(with direction: JFPopupAnimationDirection = .left, isDismissible: Bool = true, enableDrag: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: () -> UIView) {
        var config: JFPopupConfig = .drawer
        config.direction = direction
        config.isDismissible = isDismissible
        config.enableDrag = enableDrag
        config.bgColor = bgColor
        self.custom(with: config, container: container)
    }
    
    
    /// popup a dialog style view with your custom view
    /// - Parameters:
    ///   - isDismissible: default true, will tap bg auto dismiss
    ///   - bgColor: background view color
    ///   - container: your custom view
    func dialog(with isDismissible: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: () -> UIView) {
        var config: JFPopupConfig = .dialog
        config.isDismissible = isDismissible
        config.bgColor = bgColor
        self.custom(with: config, container: container)
    }
    
    /// popup a custom view with custom config
    /// - Parameters:
    ///   - config: popup config
    ///   - container: your custom view
    func custom(with config: JFPopupConfig, container: () -> UIView?) {
        guard let view = container() else {
            return
        }
        let vc = JFPopupController(with: config) {
            view
        }
        vc.show(with: base)
    }
    
    // adapt objc extension
    func objc_custom(with animationType: JFPopupAnimationType = .dialog, isDismissible: Bool = true, enableDrag: Bool = true, direction: JFPopupAnimationDirection = .left, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: () -> UIView) {
        var config = JFPopupConfig()
        config.animationType = animationType
        config.isDismissible = isDismissible
        config.enableDrag = enableDrag
        config.direction = direction
        config.bgColor = bgColor
        self.custom(with: config, container: container)
    }
}
