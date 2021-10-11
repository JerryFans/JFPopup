//
//  UIViewController+Test.swift
//  JFPopup_Example
//
//  Created by 逸风 on 2021/10/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import JFPopup

@objc public extension UIViewController {

    @objc func popup_dismiss() {
        self.popup.dismiss()
    }

    @objc func popup_actionSheet(with autoCancelAction: Bool = true, actions: (() -> [JFPopupAction])) {
        self.popup.actionSheet(with: autoCancelAction, actions: actions)
    }

    @objc func popup_bottomSheet(with isDismissible: Bool = true, enableDrag: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: () -> UIView) {
        self.popup.bottomSheet(with: isDismissible, enableDrag: enableDrag, bgColor: bgColor, container: container)
    }

    func popup_drawer(with direction: JFPopupAnimationDirection = .left, isDismissible: Bool = true, enableDrag: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: () -> UIView) {
        self.popup.drawer(with: direction, isDismissible: isDismissible, enableDrag: enableDrag, bgColor: bgColor, container: container)
    }

    func popup_dialog(with isDismissible: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: () -> UIView) {
        self.popup.dialog(with: isDismissible, bgColor: bgColor, container: container)
    }

    func popup_custom(with animationType: JFPopupAnimationType = .dialog, isDismissible: Bool = true, enableDrag: Bool = true, direction: JFPopupAnimationDirection = .left, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: () -> UIView) {
        self.popup.objc_custom(with: animationType, isDismissible: isDismissible, enableDrag: enableDrag, direction: direction, bgColor: bgColor, container: container)
    }

}
