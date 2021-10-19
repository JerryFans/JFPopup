//
//  UIView+JFPopup.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/19.
//

import UIKit

extension UIView: JFPopupCompatible {}
public extension JFPopup where Base: UIView {
    
    /// popup a bottomSheet with your custom view
    /// - Parameters:
    ///   - isDismissible: default true, will tap bg auto dismiss
    ///   - enableDrag: default true, will enable drag animate
    ///   - bgColor: background view color
    ///   - container: your custom view
    @discardableResult func bottomSheet(with isDismissible: Bool = true, enableDrag: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: @escaping (_ mainContainer: JFPopupView?) -> UIView) -> JFPopupView? {
        return JFPopupView.popup.bottomSheet(with: isDismissible, enableDrag: enableDrag, bgColor: bgColor, yourView: base) { mainContainer in
            container(mainContainer)
        }
    }
    
    
    /// popup a drawer style view with your custom view
    /// - Parameters:
    ///   - direction: left or right
    ///   - isDismissible: default true, will tap bg auto dismiss
    ///   - enableDrag: default true, will enable drag animate
    ///   - bgColor: background view color
    ///   - container: your custom view
    @discardableResult func drawer(with direction: JFPopupAnimationDirection = .left, isDismissible: Bool = true, enableDrag: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: @escaping (_ mainContainer: JFPopupView?) -> UIView) -> JFPopupView? {
        return JFPopupView.popup.drawer(with: direction, isDismissible: isDismissible, enableDrag: enableDrag, bgColor: bgColor, yourView: base) { mainContainer in
            container(mainContainer)
        }
    }
    
    
    /// popup a dialog style view with your custom view
    /// - Parameters:
    ///   - isDismissible: default true, will tap bg auto dismiss
    ///   - bgColor: background view color
    ///   - container: your custom view
    @discardableResult func dialog(with isDismissible: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), container: @escaping (_ mainContainer: JFPopupView?) -> UIView) -> JFPopupView? {
        return JFPopupView.popup.dialog(with: isDismissible, bgColor: bgColor, yourView: base) { mainContainer in
            container(mainContainer)
        }
    }
}
