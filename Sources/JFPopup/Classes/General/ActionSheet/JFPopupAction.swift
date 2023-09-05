//
//  JFPopupAction.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/9.
//

import UIKit

@objc public class JFPopupAction: NSObject {
    
    var title: String?
    var subTitle: String?
    var subAttributedTitle: NSAttributedString?
    var clickActionCallBack: (() -> ())?
    var autoDismiss: Bool = true //auto dismiss when you click action
    
    @objc public convenience init(with title: String?, subTitle: String?, autoDismiss: Bool = true, clickActionCallBack: @escaping (() -> ())) {
        self.init()
        self.title = title
        self.subTitle = subTitle
        self.autoDismiss = autoDismiss
        self.clickActionCallBack = clickActionCallBack
    }
    
    @objc public convenience init(with title: String?, subAttributedTitle: NSAttributedString?, autoDismiss: Bool = true, clickActionCallBack: @escaping (() -> ())) {
        self.init()
        self.title = title
        self.subAttributedTitle = subAttributedTitle
        self.autoDismiss = autoDismiss
        self.clickActionCallBack = clickActionCallBack
    }
    
}
