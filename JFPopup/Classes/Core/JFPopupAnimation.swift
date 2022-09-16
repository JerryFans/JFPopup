//
//  JFPopupAnimation.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/9.
//

import UIKit
import QuartzCore

class JFPopupAnimation: NSObject {
    
    static func present(with transitonContext: UIViewControllerContextTransitioning?, config: JFPopupConfig, contianerView: UIView, completion: ((_ isFinished: Bool) -> ())?) {
        let type = config.animationType
        switch type {
        case .bottomSheet:
            do {
                contianerView.frame.origin.y = CGSize.jf.screenSize().height
                contianerView.layoutIfNeeded()
                UIView.animate(withDuration: 0.25, animations: {
                    contianerView.frame.origin.y = CGSize.jf.screenSize().height - contianerView.frame.size.height
                    contianerView.layoutIfNeeded()
                }) { (finished) in
                    transitonContext?.completeTransition(true)
                    completion?(finished)
                }
            }
            break
        case .dialog:
            do {
                let originSize = contianerView.jf.size
                if config.toastPosition == .dynamicIsland {
                    contianerView.jf_size = CGSize(width: 120, height: 34)
                    contianerView.center = CGPoint(x: CGSize.jf.screenSize().width / 2, y: 27)
                }
                let updateV = {
                    contianerView.center = CGPoint(x: CGSize.jf.screenSize().width / 2, y: CGSize.jf.screenSize().height / 2)
                    if config.toastPosition == .top {
                        contianerView.jf_top = CGFloat.jf.navigationBarHeight() + 15
                    } else if config.toastPosition == .bottom {
                        contianerView.jf_bottom = CGSize.jf.screenHeight() - CGFloat.jf.safeAreaBottomHeight() - 15
                    } else if config.toastPosition == .dynamicIsland {
                        contianerView.jf_size = originSize
                        contianerView.center = CGPoint(x: CGSize.jf.screenSize().width / 2, y: originSize.height / 2 + 10)
                    }
                    contianerView.layoutIfNeeded()
                }
                guard config.withoutAnimation == false else {
                    updateV()
                    transitonContext?.completeTransition(true)
                    completion?(true)
                    return
                }
                if config.toastPosition == .dynamicIsland {
                    UIView.animate(withDuration: 0.25) {
                        updateV()
                    } completion: { finished in
                        transitonContext?.completeTransition(true)
                        completion?(finished)
                    }
                    return
                }
                updateV()
                let animation = CAKeyframeAnimation(keyPath: "transform")
                animation.duration = 0.25
                animation.isRemovedOnCompletion = true
                animation.fillMode = kCAFillModeForwards
                var values: [NSValue] = []
                values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
                values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
                values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
                animation.values = values
                contianerView.layer.add(animation, forKey: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    transitonContext?.completeTransition(true)
                    completion?(true)
                }
            }
            break
        case .drawer:
            do {
                var originY: CGFloat = -contianerView.frame.size.width
                var targetY: CGFloat = 0
                if config.direction == .right {
                    originY = CGSize.jf.screenWidth()
                    targetY =  CGSize.jf.screenWidth() - contianerView.frame.size.width
                }
                contianerView.frame.origin.x = originY
                contianerView.center.y = CGSize.jf.screenHeight() / 2
                contianerView.layoutIfNeeded()
                UIView.animate(withDuration: 0.25, animations: {
                    contianerView.frame.origin.x = targetY
                    contianerView.layoutIfNeeded()
                }) { (finished) in
                    transitonContext?.completeTransition(true)
                    completion?(finished)
                }
            }
            break
            
        }
    }
    
    static func dismiss(with transitonContext: UIViewControllerContextTransitioning?, config: JFPopupConfig, contianerView: UIView?, completion: ((_ isFinished: Bool) -> ())?) {
        let type = config.animationType
        switch type {
        case .bottomSheet:
            do {
                guard let _ = contianerView else {
                    transitonContext?.completeTransition(true)
                    completion?(true)
                    return
                }
                UIView.animate(withDuration: 0.25, animations: {
                    contianerView?.superview?.alpha = 0
                    contianerView?.frame.origin.y = CGSize.jf.screenSize().height
                    contianerView?.layoutIfNeeded()
                }) { (finished) in
                    transitonContext?.completeTransition(true)
                    completion?(finished)
                }
            }
            break
        case .dialog:
            do {
                UIView.animate(withDuration: 0.25, animations: {
                    if config.toastPosition == .dynamicIsland {
                        contianerView?.layer.cornerRadius = 17
                        contianerView?.jf_size = CGSize(width: 120, height: 34)
                        contianerView?.center = CGPoint(x: CGSize.jf.screenSize().width / 2, y: 27)
                    }
                    contianerView?.subviews.forEach({ v in
                        if config.toastPosition == .dynamicIsland {
                            v.isHidden = true
                        } else {
                            v.alpha = 0
                        }
                    })
                    contianerView?.alpha = 0
                }) { (finished) in
                    transitonContext?.completeTransition(true)
                    completion?(finished)
                }
            }
            break
        case .drawer:
            do {
                guard let view = contianerView else {
                    transitonContext?.completeTransition(true)
                    completion?(true)
                    return
                }
                var targetY: CGFloat = -view.frame.size.width
                if config.direction == .right {
                    targetY = CGSize.jf.screenWidth()
                }
                UIView.animate(withDuration: 0.25, animations: {
                    contianerView?.superview?.alpha = 0
                    contianerView?.frame.origin.x = targetY
                    contianerView?.layoutIfNeeded()
                }) { (finished) in
                    transitonContext?.completeTransition(true)
                    completion?(finished)
                }
            }
            break
        }
    }

}
