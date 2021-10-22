//
//  JFAlertAction.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/22.
//

import UIKit

public typealias TapActionCallBack = () -> ()

let JFAlertCancelColor = UIColor(red: 20 / 255.0, green: 20 / 255.0, blue: 20 / 255.0, alpha: 1)
let JFAlertSureColor = UIColor(red: 69 / 255.0, green: 85 / 255.0, blue: 130 / 255.0, alpha: 1)

public enum JFAlertActionOption {
    case textColor(UIColor)
    case text(String)
    case tapActionCallback(TapActionCallBack)
    
    static var cancel: [JFAlertActionOption] = [
        .text("取消"),.textColor(JFAlertCancelColor),
    ]
}

class JFAlertAction: NSObject {
    
    var options: [JFAlertActionOption] = []
    var clickBtnCallBack: (() -> ())?
    var tapActionCallback: TapActionCallBack?
    var defaultColor: UIColor = UIColor(red: 20 / 255.0, green: 20 / 255.0, blue: 20 / 255.0, alpha: 1)
    
    convenience init(with options: [JFAlertActionOption], defaultColor: UIColor) {
        self.init()
        self.options = options
        self.defaultColor = defaultColor
    }
    
    override init() {
        super.init()
    }
    
    deinit {
        print("JFAlertAction dealloc")
    }
    
    @objc func clickAction() {
        self.clickBtnCallBack?()
        self.tapActionCallback?()
    }
    
    func buildActionButton() -> UIButton? {
        var color = self.defaultColor
        var text: String?
        for option in options {
            switch option {
            case .textColor(let uIColor):
                color = uIColor
            case .text(let t):
                text = t
            case .tapActionCallback(let tap):
                self.tapActionCallback = tap
            }
        }
        guard let text = text else {
            return nil
        }
        let button: UIButton = {
            let btn = UIButton(type: .custom)
            btn.setTitle(text, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            btn.setTitleColor(color, for: .normal)
            btn.setBackgroundImage(UIImage.jf.color(0xffffff), for: .normal)
            btn.setBackgroundImage(UIImage.jf.color(0x000000,alpha: 0.1), for: .highlighted)
            btn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
            return btn
        }()
        return button
    }
    
}
