//
//  ViewController.swift
//  JFPopup
//
//  Created by fanjiaorng919 on 10/10/2021.
//  Copyright (c) 2021 fanjiaorng919. All rights reserved.
//

import UIKit
import JFPopup

let itemHeight: CGFloat = 50

class ViewController: UIViewController {
    
    let frame = CGRect(x: 15, y: 0, width: CGSize.jf.screenWidth() - 30, height: itemHeight)
    var originY: CGFloat = 0
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: CGSize.jf.screenWidth(), height: 0)
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        return scrollView
    }()
    
    @discardableResult private func buildLabel(withTitle title: String) -> UILabel {
        var label = UILabel()
        label.text = title + "："
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.black
        self.scrollView.addSubview(label)
        label.frame = frame
        label.numberOfLines = 1
        label.sizeToFit()
        label.jf.height = label.jf.height + 30
        label.jf.origin.y = originY
        originY += label.jf.height
        return label
    }
    
    @discardableResult private func buildSubLabel(withTitle title: String) -> UILabel {
        var label = UILabel()
        label.text = title
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        self.scrollView.addSubview(label)
        label.frame = frame
        label.numberOfLines = 2
        label.sizeToFit()
        label.jf.origin.y = originY
        originY += label.jf.height
        return label
    }
    
    private func buildButton(withTitle title: String) -> UIButton {
        var btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.contentHorizontalAlignment = .left
        btn.setBackgroundImage(UIImage.jf.color(0x000000,alpha: 0.1), for: .highlighted)
        self.scrollView.addSubview(btn)
        btn.frame = frame
        btn.jf.origin.y = originY
        addBottomLine(with: btn)
        originY += btn.jf.height
        return btn
    }
    
    private func addBottomLine(with actionItem: UIView) {
        var lineView = UIView()
        lineView.backgroundColor = UIColor.init(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1)
        actionItem.addSubview(lineView)
        lineView.jf.left = 0
        lineView.jf.top = actionItem.jf.height - 1
        lineView.jf.height = 0.5
        lineView.jf.width = actionItem.jf.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Example"
        self.view.addSubview(self.scrollView)
        self.scrollView.frame = self.view.frame
        self.buildLabel(withTitle: "示例代码")
        self.buildSubLabel(withTitle: "支持从Controller 弹出， 也支持从View 弹出")
        self.buildSubLabel(withTitle: "V1.1 add ToastView, Usage请看(从UIView弹出)")
        let btn = self.buildButton(withTitle: "从Controller弹出")
        btn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        
        let btn1 = self.buildButton(withTitle: "从UIView弹出")
        btn1.addTarget(self, action: #selector(clickAction1), for: .touchUpInside)
        
        let btn2 = self.buildButton(withTitle: "Objc兼容")
        btn2.addTarget(self, action: #selector(clickAction2), for: .touchUpInside)
        
        self.scrollView.contentSize = CGSize(width: CGSize.jf.screenWidth(), height: originY + itemHeight)
    }
    
    @objc func clickAction2() {
        self.navigationController?.pushViewController(OCViewController(), animated: true)
    }
    
    @objc func clickAction1() {
        self.navigationController?.pushViewController(PopupInViewController(), animated: true)
    }
    
    @objc func clickAction() {
        self.navigationController?.pushViewController(PresentVCModeViewController(), animated: true)
    }

}

