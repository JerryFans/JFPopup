//
//  JFAlertView.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/21.
//

import UIKit

public enum JFAlertOption {
    case title(String)
    case titleColor(UIColor)
    case subTitle(String)
    case subTitleColor(UIColor)
    case showCancel(Bool)
    case cancelAction([JFAlertActionOption])
    case confirmAction([JFAlertActionOption])
    case withoutAnimation(Bool)
}

public struct JFAlertConfig {
    var title: String?
    var titleColor: UIColor = UIColor(red: 20 / 255.0, green: 20 / 255.0, blue: 20 / 255.0, alpha: 1)
    var subTitle: String?
    var subTitleColor: UIColor = UIColor(red: 94 / 255.0, green: 94 / 255.0, blue: 94 / 255.0, alpha: 1)
    var showCancel = true
    var cancelAction: [JFAlertActionOption]?
    var confirmAction: [JFAlertActionOption]?
    var itemSpacing: CGFloat = 20
    var contentInset = UIEdgeInsets.init(top: 30, left: 20, bottom: 30, right: 20)

}

class JFAlertView: UIView {
    
    let margin:  CGFloat = 15 * UIScreen.main.scale
    
    var cancelAction: JFAlertAction?
    var confirmAction: JFAlertAction?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = self.config.titleColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = self.config.subTitleColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    lazy var verStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel,self.subTitleLabel])
        stackView.alignment = .center
        stackView.spacing = self.config.itemSpacing
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 221 / 255.0, green: 221 / 255.0, blue: 221 / 255.0, alpha: 1)
        return view
    }()
    
    var config: JFAlertConfig = JFAlertConfig()
    var clickActionHandle: (() -> ())?
    
    public convenience init?(with config: JFAlertConfig) {
        //subTitle or title must have one value
        guard config.subTitle != nil || config.title != nil else {
            return nil
        }
        self.init(frame: .zero)
        self.config = config
        self.configSubview()
    }

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: CGSize.jf.screenWidth(), y: CGSize.jf.screenHeight(), width: CGSize.jf.screenWidth(), height: CGSize.jf.screenHeight()))
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .white
    }
    
    func configAutolayout() {
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.bottomView)
        self.addConstraints([
            NSLayoutConstraint(item: self.bottomView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.bottomView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.bottomView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 55),
        ])
        
        self.addSubview(self.verStackView)
        self.verStackView.translatesAutoresizingMaskIntoConstraints = false
        self.verStackView.addConstraints([
            NSLayoutConstraint(item: self.titleLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: CGSize.jf.screenWidth() - (margin * 2 + self.config.contentInset.left + self.config.contentInset.right)),
            NSLayoutConstraint(item: self.subTitleLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: CGSize.jf.screenWidth() - (margin * 2 + self.config.contentInset.left + self.config.contentInset.right)),
        ])
        self.addConstraints(
            [
                NSLayoutConstraint(item: self.verStackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.verStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -27.5),
          ]
        )
    }
    
    func configSubview() {
        
        self.configAutolayout()
        var cancelAction: [JFAlertActionOption]? = JFAlertActionOption.cancel
        if let cancel = self.config.cancelAction {
            cancelAction = cancel
        }
        if self.config.showCancel == false {
            cancelAction = nil
        }
        var arrangedSubviews: [UIView] = []
        if let cancel = cancelAction {
            let action = JFAlertAction(with: cancel, defaultColor: JFAlertCancelColor)
            action.clickBtnCallBack = { [weak self] in
                if let supV = self?.superview as? JFPopupView {
                    supV.dismissPopupView { isFinished in
                        
                    }
                } else {
                    self?.clickActionHandle?()
                }
            }
            self.cancelAction = action
            if let btn = action.buildActionButton() {
                arrangedSubviews.append(btn)
            }
        }
        if let confirm = config.confirmAction {
            let action = JFAlertAction(with: confirm, defaultColor: JFAlertSureColor)
            action.clickBtnCallBack = { [weak self] in
                if let supV = self?.superview as? JFPopupView {
                    supV.dismissPopupView { isFinished in
                        
                    }
                } else {
                    self?.clickActionHandle?()
                }
            }
            self.confirmAction = action
            if let btn = action.buildActionButton() {
                arrangedSubviews.append(btn)
            }
        }
        
        if arrangedSubviews.count > 0 {
            if let btn1 = arrangedSubviews.first, let btn2 = arrangedSubviews.last {
                let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
                stackView.backgroundColor = .clear
                stackView.alignment = .bottom
                stackView.spacing = 1
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                
                var constraints: [NSLayoutConstraint] = []
                constraints.append(NSLayoutConstraint(item: btn1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 54))
                if btn1 != btn2 {
                    constraints.append(NSLayoutConstraint(item: btn2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 54))
                }
                self.bottomView.addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.addConstraints(constraints)
                
                self.addConstraints([
                    NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self.bottomView, attribute: .left, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: self.bottomView, attribute: .right, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomView, attribute: .bottom, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.bottomView, attribute: .top, multiplier: 1, constant: 1),
                ])
            }
        }
        
        if let title = self.config.title {
            self.titleLabel.text =  title
            self.titleLabel.isHidden = false
        }
        
        if let subTitle = self.config.subTitle {
            self.subTitleLabel.text =  subTitle
            self.subTitleLabel.isHidden = false
        }
        self.layoutIfNeeded()
        let titleSize = self.titleLabel.frame.size
        let subTitleSize  = self.subTitleLabel.frame.size
        var height: CGFloat = self.config.contentInset.bottom + self.config.contentInset.top
        let width = CGSize.jf.screenWidth() - margin * 2
        
        if  titleSize != .zero {
            height += titleSize.height
        }
        
        if subTitleSize != .zero {
            height += titleSize != .zero ? self.config.itemSpacing : 0
            height += subTitleSize.height
        }
        height += 55
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
