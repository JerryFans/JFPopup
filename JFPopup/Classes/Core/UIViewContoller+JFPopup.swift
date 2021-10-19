//
//  UIViewContoller+Popup.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/9.
//

import UIKit
extension UIViewController: JFPopupCompatible {}

public extension JFPopup where Base: UIViewController {
    
    func dismiss() {
        if let navi = base.presentedViewController as? UINavigationController, let vc = navi.viewControllers.first as? JFPopupController {
            vc.closeVC(with: nil)
        }
    }
    
    
    /// popup a actionSheet
    /// - Parameters:
    ///   - autoCancelAction: is true, will add cancel action in the last
    ///   - actions: the actions item
    func actionSheet(with autoCancelAction: Bool = true, actions: (() -> [JFPopupAction])) {
        self.bottomSheet(with: true, enableDrag: false) {
            let v = JFPopupActionSheetView(with: actions(), autoCancelAction: autoCancelAction)
            v.autoDismissHandle = {
                dismiss()
            }
            return v
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
    
    func toast(msg: String? = nil, assetIcon: JFToastAssetIconType? = nil) {
        guard msg != nil || assetIcon != nil else {
            assert(msg != nil || assetIcon != nil, "msg or assetIcon only can one value nil")
            return
        }
        var config: JFPopupConfig = .dialog
        config.bgColor = .clear
        config.withoutAnimation = true
        config.enableUserInteraction = false
        let v = JFPopupView(with: config) { mainContainer in
            JFToastView(with: JFToastConfig(title: msg, assetIcon: assetIcon))
        }
        v.popup()
        //vc 模式无法穿透手势，慎用  toast 一般直接addSubview 不需要vc模式 modal
//        self.custom(with: config) {
//            JFToastView(with: JFToastConfig(title: msg, assetIcon: assetIcon))
//        }
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
