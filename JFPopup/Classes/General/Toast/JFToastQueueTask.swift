//
//  JFToastQueueTask.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/21.
//

import UIKit

class JFToastQueueTask: NSObject {
    
    var config: JFPopupConfig?
    var toastConfig: JFToastConfig?
    weak var mainContainer: UIView?
    weak var popupView: JFPopupView?
    
    override init() {
        super.init()
    }
    
    convenience init(with config: JFPopupConfig, toastConfig: JFToastConfig?, mainContainer: UIView?, popupView: JFPopupView?) {
        self.init()
        self.config = config
        self.toastConfig = toastConfig
        self.mainContainer = mainContainer
        self.popupView = popupView
    }
}
