//
//  JFPopupActionSheetView.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/9.
//

import UIKit

public extension JFPopup where Base: UIViewController {
    /// popup a actionSheet
    /// - Parameters:
    ///   - autoCancelAction: is true, will add cancel action in the last
    ///   - actions: the actions item
    func actionSheet(with autoCancelAction: Bool = true, actions: (() -> [JFPopupAction])) {
        self.bottomSheet(with: true, enableDrag: false) {
            let v = JFPopupActionSheetView(with: actions(), autoCancelAction: autoCancelAction)
            v.autoDismissHandle = {
                dismissPopup()
            }
            return v
        }
    }
}

public extension JFPopup where Base: UIView {
    /// popup a actionSheet
    /// - Parameters:
    ///   - autoCancelAction: is true, will add cancel action in the last
    ///   - actions: the actions item
    @discardableResult func actionSheet(with autoCancelAction: Bool = true, actions: @escaping (() -> [JFPopupAction])) -> JFPopupView? {
        return JFPopupView.popup.bottomSheet(with: true, enableDrag: false, yourView: base) { mainContainer in
            let v = JFPopupActionSheetView(with: actions(), autoCancelAction: autoCancelAction)
            v.autoDismissHandle = { [weak mainContainer] in
                mainContainer?.dismissPopupView(completion: { isFinished in
                    
                })
            }
            return v
        }
    }
}

public extension JFPopup where Base: JFPopupView {
    /// popup a actionSheet
    /// - Parameters:
    ///   - autoCancelAction: is true, will add cancel action in the last
    ///   - actions: the actions item
    @discardableResult static func actionSheet(with autoCancelAction: Bool = true, yourView: UIView? = nil, actions: @escaping (() -> [JFPopupAction])) -> JFPopupView? {
        return self.bottomSheet(with: true, enableDrag: false, yourView: yourView) { mainContainer in
            let v = JFPopupActionSheetView(with: actions(), autoCancelAction: autoCancelAction)
            v.autoDismissHandle = { [weak mainContainer] in
                mainContainer?.dismissPopupView(completion: { isFinished in
                    
                })
            }
            return v
        }
    }
}

class JFPopupActionView: UIView {
    
    var clickActionHandle: (() -> ())?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 19 / 255.0, green: 20 / 255.0, blue: 19 / 255.0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor =  UIColor.init(red: 135 / 255.0, green: 135 / 255.0, blue: 135 / 255.0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var verStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel,self.subTitleLabel])
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        return stackView
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1)
        return view
    }()
    
    lazy var clickBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        btn.setBackgroundImage(UIImage.jf.color(0x000000,alpha: 0.1), for: .highlighted)
        return btn
    }()
    
    @objc func clickAction() {
        self.clickActionHandle?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(self.verStackView)
        self.verStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(
            [
                NSLayoutConstraint(item: self.verStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.verStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.verStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
          ]
        )
        self.addSubview(self.lineView)
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(
            [
                NSLayoutConstraint(item: self.lineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.lineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.lineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0.5)
          ]
        )
        self.addSubview(self.clickBtn)
        self.clickBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: self.clickBtn, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.clickBtn, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.clickBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.clickBtn, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class JFPopupActionSheetView: UIView {
    
    var actions: [JFPopupAction]?
    var autoDismissHandle: (() -> ())?
    var autoCancelAction: Bool = true
    
    public convenience init(with actions: [JFPopupAction], autoCancelAction: Bool = true) {
        self.init(frame: .zero)
        self.autoCancelAction = autoCancelAction
        self.actions = actions
        self.configSubview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubview() {
        self.backgroundColor = UIColor.init(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
        guard let actions = self.actions, actions.count > 0 else { return }
        var originY: CGFloat = 0
        var views: [UIView] = []
        for element in actions.enumerated() {
            let action = element.element
            var actionHeight: CGFloat = 0
            let view = JFPopupActionView()
            view.clickActionHandle = { [weak self] in
                if action.autoDismiss {
                    self?.autoDismissHandle?()
                }
                action.clickActionCallBack?()
            }
            if let title = action.title {
                view.titleLabel.text = title
                view.titleLabel.isHidden = false
                view.titleLabel.sizeToFit()
                actionHeight += view.titleLabel.frame.size.height
            }
            if let subTitle = action.subTitle {
                view.subTitleLabel.text = subTitle
                view.subTitleLabel.isHidden = false
                view.subTitleLabel.sizeToFit()
                actionHeight += 5
                actionHeight += view.subTitleLabel.frame.size.height
            } else if let subAttTitle = action.subAttributedTitle {
                view.subTitleLabel.attributedText = subAttTitle
                view.subTitleLabel.isHidden = false
                view.subTitleLabel.sizeToFit()
                actionHeight += 5
                actionHeight += view.subTitleLabel.frame.size.height
            }
            view.lineView.isHidden = element.offset == (actions.count - 1)
            actionHeight += 30
            view.frame = CGRect(origin: CGPoint(x: 0, y: originY), size: CGSize(width: CGSize.jf.screenWidth(), height: actionHeight))
            originY += actionHeight
            self.addSubview(view)
            views.append(view)
        }
        
        if var view = views.last, self.autoCancelAction == false {
            view.jf.height += CGFloat.jf.safeAreaBottomHeight()
            self.frame.size.height = view.jf.bottom
        } else {
            var view = JFPopupActionView()
            view.titleLabel.text = "取消"
            view.clickActionHandle = { [weak self] in
                self?.autoDismissHandle?()
            }
            view.titleLabel.sizeToFit()
            view.jf.left = 0
            view.jf.top = originY + 5
            view.jf.width = CGSize.jf.screenWidth()
            view.jf.height = view.titleLabel.jf.height + 30 + CGFloat.jf.safeAreaBottomHeight()
            for constraint in view.constraints {
                if let first = constraint.firstItem, first.isEqual(view.verStackView) && constraint.firstAttribute == .centerY {
                    constraint.constant = -CGFloat.jf.safeAreaBottomHeight() / 2
                    break
                }
            }
            self.addSubview(view)
            self.frame.size.height = view.jf.bottom
        }
        self.frame.size.width = CGSize.jf.screenWidth()
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 12, height: 12))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
}
