//
//  PresentVCModeViewController.swift
//  JFPopup_Example
//
//  Created by 逸风 on 2021/10/19.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import JFPopup

//自定义实现动画
extension PresentVCModeViewController: JFPopupAnimationProtocol {
    func present(with transitonContext: UIViewControllerContextTransitioning?, config: JFPopupConfig, contianerView: UIView, completion: ((Bool) -> ())?) {
        var contianerView = contianerView
        contianerView.frame.origin.y = -contianerView.jf.height
        contianerView.jf.centerX = CGSize.jf.screenWidth() / 2
        contianerView.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            contianerView.jf.centerY = CGSize.jf.screenHeight() / 2
            contianerView.layoutIfNeeded()
        }) { (finished) in
            transitonContext?.completeTransition(true)
            completion?(finished)
        }
    }
    
    func dismiss(with transitonContext: UIViewControllerContextTransitioning?, config: JFPopupConfig, contianerView: UIView?, completion: ((Bool) -> ())?) {
        guard let contianerView = contianerView else {
            transitonContext?.completeTransition(true)
            completion?(false)
            return
        }
        UIView.animate(withDuration: 0.25, animations: {
            contianerView.superview?.alpha = 0
            contianerView.frame.origin.y = -contianerView.jf.height
            contianerView.layoutIfNeeded()
        }) { (finished) in
            transitonContext?.completeTransition(true)
            completion?(finished)
        }
    }
}

class PresentVCModeViewController: UIViewController {
    
    let frame = CGRect(x: 15, y: 0, width: CGSize.jf.screenWidth() - 30, height: itemHeight)
    var originY: CGFloat = 0
    
    @discardableResult private func buildLabel(withTitle title: String) -> UILabel {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: CGSize.jf.screenWidth(), height: 0)
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        return scrollView
    }()
    
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
        self.title = "Present In VC Mode"
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollView)
        self.scrollView.frame = self.view.frame
        
        self.buildLabel(withTitle: "快速创建模式示例（闭包）")
        self.buildSubLabel(withTitle: "支持4种模式，左抽屉，右抽屉，底部Sheet，对话框，皆支持自定义View")
        
        let btn = self.buildButton(withTitle: "Drawer Right")
        btn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        
        let btn1 = self.buildButton(withTitle: "Dialog")
        btn1.addTarget(self, action: #selector(clickAction1), for: .touchUpInside)
        
        let btn2 = self.buildButton(withTitle: "BottomSheet")
        btn2.addTarget(self, action: #selector(clickAction2), for: .touchUpInside)
        
        let btn3 = self.buildButton(withTitle: "Drawer Left")
        btn3.addTarget(self, action: #selector(clickAction3), for: .touchUpInside)
        
        self.buildLabel(withTitle: "通用组件示例")
        
        let btn4 = self.buildButton(withTitle: "微信ActionSheet 自带取消")
        btn4.addTarget(self, action: #selector(clickAction4), for: .touchUpInside)
        
        let btn6 = self.buildButton(withTitle: "微信ActionSheet 不带取消")
        btn6.addTarget(self, action: #selector(clickAction6), for: .touchUpInside)
        
        let btn7 = self.buildButton(withTitle: "微信ActionSheet 点击action不退出")
        btn7.addTarget(self, action: #selector(clickAction7), for: .touchUpInside)
        
        let btn13 = self.buildButton(withTitle: "微信ActionSheet Attributed SubTitle")
        btn13.addTarget(self, action: #selector(clickAction13), for: .touchUpInside)
        
        let btn12 = self.buildButton(withTitle: "通用 Alert View From Present VC")
        btn12.addTarget(self, action: #selector(clickAction12), for: .touchUpInside)
        
        self.buildLabel(withTitle: "兼容OC写法")
        self.buildSubLabel(withTitle: "见UIViewController+JFPopupObjc.swift")
        
        let btn5 = self.buildButton(withTitle: "OC Usage（自行写Extension）")
        btn5.addTarget(self, action: #selector(pushVC), for: .touchUpInside)
        
        self.buildLabel(withTitle: "VC模式创建")
        
        let btn8 = self.buildButton(withTitle: "继承JFPopupController，点击背景不允许退出")
        btn8.addTarget(self, action: #selector(clickAction8), for: .touchUpInside)
        
        let btn9 = self.buildButton(withTitle: "直接初始化方法创建")
        btn9.addTarget(self, action: #selector(clickAction9), for: .touchUpInside)
        
        
        self.buildLabel(withTitle: "自定义")
        let btn10 = self.buildButton(withTitle: "扩展自定义动画")
        btn10.addTarget(self, action: #selector(clickAction10), for: .touchUpInside)
        
        let btn11 = self.buildButton(withTitle: "自定义配置")
        btn11.addTarget(self, action: #selector(clickAction11), for: .touchUpInside)
        
        self.scrollView.contentSize = CGSize(width: CGSize.jf.screenWidth(), height: originY + itemHeight)
    }
    
    @objc func clickAction13() {
        let highlightAttribute: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.red]
        let subTitle = NSAttributedString(string: "照片或视频照片", attributes: highlightAttribute)
        self.popup.actionSheet {
            [
                JFPopupAction(with: "拍摄", subAttributedTitle: subTitle, clickActionCallBack: { [weak self] in
                    self?.pushVC()
                }),
            ]
        }
    }
    
    @objc func clickAction12() {
        self.popup.alert {[
            .title("从VC弹出alertView"),
            .subTitle("也支持从UIView弹出，更多用法请看《从UIView弹出》示例"),
            .confirmAction([
                .text("过去看"),
                .tapActionCallback({ [weak self] in
                    self?.navigationController?.pushViewController(PopupInViewController(), animated: true)
                })
            ])
        ]}
    }
    
    @objc func clickAction11() {
        var config = JFPopupConfig.dialog
        config.bgColor = UIColor.jf.rgb(0x7e7eff,alpha: 0.5)
        self.popup.custom(with: config) {
            let view: UIView = {
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                view.layer.cornerRadius = 12
                view.backgroundColor = .black
                return view
            }()
            return view
        }
    }
    
    @objc func clickAction10() {
        var config = JFPopupConfig.dialog
        config.bgColor = .clear
        let vc = JFPopupController(with: config, popupProtocol: self) {
            let view: UIView = {
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                view.layer.cornerRadius = 12
                view.backgroundColor = .black
                return view
            }()
            return view
        }
        vc.show(with: self)
    }
    
    @objc func clickAction9() {
        var config = JFPopupConfig.dialog
        config.bgColor = .clear
        let vc = JFPopupController(with: config) {
            let view: UIView = {
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                view.layer.cornerRadius = 12
                view.backgroundColor = .black
                return view
            }()
            return view
        }
        vc.show(with: self)
    }
    
    @objc func clickAction8() {
        var config = JFPopupConfig.bottomSheet
        config.isDismissible = false
        let vc = TestCustomViewController(with: config)
        vc.show(with: self)
    }
    
    @objc func clickAction7() {
        self.popup.actionSheet {
            [
                JFPopupAction(with: "从手机相册选择", subTitle: nil, autoDismiss: false, clickActionCallBack: { [weak self] in
                    print("我没退出")
                    JFPopupView.popup.toast(hit: "3s后退出")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self?.popup.dismissPopup()
                    }
                }),
            ]
        }
    }
    
    @objc func clickAction6() {
        self.popup.actionSheet(with: false) {
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
        self.popup.actionSheet {
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
    
    @objc func clickAction3() {
        //default left
        self.popup.drawer {
            let v = DrawerView(frame: CGRect(x: 0, y: 0, width: CGSize.jf.screenWidth(), height: CGSize.jf.screenHeight()))
            v.closeHandle = { [weak self] in
                self?.popup.dismissPopup()
            }
            return v
        }
    }
    
    @objc func pushVC() {
        let vc = OCViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickAction2() {
        
        self.popup.bottomSheet {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: CGSize.jf.screenWidth(), height: 300))
            v.backgroundColor = .red
            return v
        }
    }
    
    @objc func clickAction1() {
        self.popup.dialog {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            v.backgroundColor = .red
            return v
        }
    }
    
    @objc func clickAction() {
        self.popup.drawer(with: .right) {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: CGSize.jf.screenHeight()))
            v.backgroundColor = .red
            return v
        }
    }
}
