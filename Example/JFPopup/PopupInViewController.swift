//
//  PopupInViewController.swift
//  JFPopup_Example
//
//  Created by 逸风 on 2021/10/19.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import JFPopup

class PopupInViewController: UIViewController {
    
    var count = 0
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
        self.title = "Popup From UIView"
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollView)
        self.scrollView.frame = self.view.frame
        
        self.buildLabel(withTitle: "通用组件示例")
        self.buildSubLabel(withTitle: "所有Popup type")
        self.buildSubLabel(withTitle: "self.view.popup.xxx, add 到当前 view")
        self.buildSubLabel(withTitle: "JFPopupView.popup.xxx add 到 window")
        
        let btn3 = self.buildButton(withTitle: "Drawer")
        btn3.addTarget(self, action: #selector(clickAction3), for: .touchUpInside)
        
        self.buildLabel(withTitle: "ActionSheet")
        let btn4 = self.buildButton(withTitle: "add to current view")
        btn4.addTarget(self, action: #selector(clickAction4), for: .touchUpInside)
        
        let btn5 = self.buildButton(withTitle: "add to window view")
        btn5.addTarget(self, action: #selector(clickAction5), for: .touchUpInside)
        
        self.buildLabel(withTitle: "Toast Usage (v1.1 add)")
        
        let btn6 = self.buildButton(withTitle: "普通toast,默认superview可以响应")
        btn6.addTarget(self, action: #selector(clickAction6), for: .touchUpInside)
        
        let btn7 = self.buildButton(withTitle: "自定义参数")
        btn7.addTarget(self, action: #selector(clickAction7), for: .touchUpInside)
        
        let btn8 = self.buildButton(withTitle: "默认Icon")
        btn8.addTarget(self, action: #selector(clickAction8), for: .touchUpInside)
        
        let btn9 = self.buildButton(withTitle: "自定义Icon,可以没文本")
        btn9.addTarget(self, action: #selector(clickAction9), for: .touchUpInside)
        
        self.buildLabel(withTitle: "Loading Usage (v1.3 add)")
        
        let btn10 = self.buildButton(withTitle: "常规不带文字")
        btn10.addTarget(self, action: #selector(clickAction10), for: .touchUpInside)
        
        let btn11 = self.buildButton(withTitle: "带文字")
        btn11.addTarget(self, action: #selector(clickAction11), for: .touchUpInside)
        
        let btn12 = self.buildButton(withTitle: "loading in view")
        btn12.addTarget(self, action: #selector(clickAction12), for: .touchUpInside)
    }
    
    @objc func clickAction10() {
        JFPopupView.popup.loading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            JFPopupView.popup.hideLoading()
        }
    }
    
    @objc func clickAction11() {
        JFPopupView.popup.loading(hit: "正在载入视频")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            JFPopupView.popup.hideLoading()
        }
    }
    
    @objc func clickAction12() {
        //只支持 controller.view, 默认keywindow
        JFPopupView.popup.loading(hit: "加载中", inView: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            JFPopupView.popup.hideLoading()
        }
    }
    
    @objc func clickAction3() {
        JFPopupView.popup.drawer { mainContainer in
            let view = DrawerView(frame: CGRect(x: 0, y: 0, width: CGSize.jf.screenWidth(), height: CGSize.jf.screenHeight()))
            view.backgroundColor = UIColor.jf.rgb(0x7e7eff)
            view.closeHandle = { [weak mainContainer] in
                mainContainer?.dismissPopupView()
            }
            return view
        }
    }
    
    @objc func clickAction6() {
        JFPopupView.popup.toast(hit: "普通toast,默认superview可以响应")
    }
    
    @objc func clickAction8() {
        let random = arc4random() % 2
        if random == 0 {
            JFPopupView.popup.toast(hit: "支付成功", icon: .success)
        } else {
            JFPopupView.popup.toast(hit: "支付失败", icon: .fail)
        }
    }
    
    @objc func clickAction7() {
        // mainContainer 在当前view 弹出， 默认 keywindow
        // mainContainer in current view popup， default is keywindow
        // withoutAnimation 不用动画
        // enableUserInteraction 如果 true 相当于mask遮挡superview手势 不能触发
        JFPopupView.popup.toast {
            [
                .hit("不响应super view,带背景色,加大时长,不用动画，在当前view弹出,position top"),
                .enableUserInteraction(true),
                .bgColor(UIColor.jf.rgb(0x000000,alpha: 0.3)),
                .autoDismissDuration(.seconds(value: 3)),
                .mainContainer(self.view),
                .withoutAnimation(true),
                .position(.top)
            ]
        }
    }
    
    @objc func clickAction9() {
        var options: [JFToastOption] = [.icon(.imageName(name: "face"))]
        let random = arc4random() % 2
        if random == 0 {
            options += [.hit("Hello Word !")]
        }
        JFPopupView.popup.toast { options }
    }
                   
    @objc func clickAction5() {
        self.view.popup.actionSheet {
            [
                JFPopupAction(with: "拍摄", subTitle: "照片或视频照片", clickActionCallBack: { [weak self] in
                    self?.pushVC()
                }),
                JFPopupAction(with: "从手机相册选择", subTitle: nil, clickActionCallBack: {

                }),
                JFPopupAction(with: "用秒剪制作视频", subTitle: nil, clickActionCallBack: {

                }),
            ]
        }
    }
    
    @objc func clickAction4() {
        JFPopupView.popup.actionSheet {
            [
                JFPopupAction(with: "拍摄", subTitle: "照片或视频照片", clickActionCallBack: { [weak self] in
                    self?.pushVC()
                }),
                JFPopupAction(with: "从手机相册选择", subTitle: nil, clickActionCallBack: {

                }),
                JFPopupAction(with: "用秒剪制作视频", subTitle: nil, clickActionCallBack: {

                }),
            ]
        }
    }
    
    @objc func pushVC() {
        let vc = OCViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
