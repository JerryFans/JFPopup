//
//  JFAlertView+PopupView.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/22.
//

import UIKit

public extension JFPopup where Base: JFPopupView {
    
    @discardableResult static func alert(options: () -> [JFAlertOption]) -> JFPopupView? {
        let allOptions = options()
        var config: JFPopupConfig = .dialog
        var alertConfig = JFAlertConfig()
        config.enableUserInteraction = true
        config.enableAutoDismiss = false
        config.isDismissible = false
        for option in allOptions {
            switch option {
            case .title(let string):
                alertConfig.title = string
            case .titleColor(let uIColor):
                alertConfig.titleColor = uIColor
            case .subTitle(let string):
                alertConfig.subTitle = string
            case .subTitleColor(let uIColor):
                alertConfig.subTitleColor = uIColor
            case .showCancel(let bool):
                alertConfig.showCancel = bool
            case .cancelAction(let actions):
                alertConfig.cancelAction = actions
            case .confirmAction(let actions):
                alertConfig.confirmAction = actions
            case .withoutAnimation(let bool):
                config.withoutAnimation = bool
            }
        }
            guard alertConfig.title != nil || alertConfig.subTitle != nil else {
                assert(alertConfig.title != nil || alertConfig.subTitle != nil, "title or subTitle only can one value nil")
            return nil
        }
        let popupView = self.custom(with: config, yourView: nil) { mainContainer in
            JFAlertView(with: alertConfig)
        }
        return popupView
    }
}
