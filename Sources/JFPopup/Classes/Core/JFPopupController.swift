//
//  JFPopupController.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/9.
//

import UIKit

extension JFPopupController: JFPopupProtocol {
    
    public func dismissPopupView(completion: ((Bool) -> ())) {
        self.closeVC(with: nil)
    }
    
    public func autoDismissHandle() {
        guard self.config.enableAutoDismiss else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.config.autoDismissDuration.timeDuration()) {
            self.dismissPopupView { isFinished in
                
            }
        }
    }
    
    
    
}

open class JFPopupController: UIViewController,JFPopupDataSource {
    
    //JFPopupProtocol
    public weak var dataSource: JFPopupDataSource?
    public weak var popupProtocol: JFPopupAnimationProtocol?
    public var container: UIView?
    public var config: JFPopupConfig = .dialog
    //JFPopupProtocol
    
    
    //JFPopupDataSource
    @objc open func viewForContainer() -> UIView? {
        return nil
    }
    //JFPopupDataSource

    weak var transitionContext: UIViewControllerAnimatedTransitioning?
    var isShow = false
    var beginTouchPoint: CGPoint = .zero
    var beginFrame: CGRect = .zero
    
    deinit {
        print("JFPopupController dealloc")
    }
    
    public init(with config: JFPopupConfig) {
        super.init(nibName: nil, bundle: nil)
        self.transitionContext = self
        self.config = config
    }
    
    public init(with config: JFPopupConfig, container: (() -> UIView)?) {
        super.init(nibName: nil, bundle: nil)
        self.container = container?()
        self.transitionContext = self
        self.config = config
    }
    
    public init(with config: JFPopupConfig, popupProtocol: JFPopupAnimationProtocol? = nil, container: (() -> UIView)?) {
        super.init(nibName: nil, bundle: nil)
        self.popupProtocol = popupProtocol
        self.container = container?()
        self.transitionContext = self
        self.config = config
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if self.popupProtocol == nil {
            self.popupProtocol = self
        }
        if let container = self.container {
            self.view.addSubview(container)
        } else {
            if self.dataSource == nil {
                self.dataSource = self
            }
            if let v = self.dataSource?.viewForContainer() {
                self.view.addSubview(v)
                self.container = v
            }
        }
        self.view.backgroundColor = self.config.bgColor
        let panGest: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(gest:)))
        panGest.delegate = self
        self.view.addGestureRecognizer(panGest)
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tapBGAction))
        tapGest.delegate = self
        self.view.addGestureRecognizer(tapGest)
    }
    
    @objc open func show(with vc: UIViewController) {
        let navi = UINavigationController.init(rootViewController: self)
        navi.transitioningDelegate = self
        navi.modalPresentationStyle = .custom
        self.isShow = true
        vc.present(navi, animated: true) {
        }
    }
    
    @objc func tapBGAction() {
        guard self.config.isDismissible else { return }
        self.closeVC(with: nil)
    }
    
    @objc open func closeVC(with completion: (() -> Void)?) {
        self.dismiss(animated: true, completion: completion)
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.isShow = false
        super.dismiss(animated: flag, completion: completion)
    }
    
    @objc private func onPan(gest: UIPanGestureRecognizer) {
        guard self.config.enableDrag else {
            self.tapBGAction()
            return
        }
        guard let container = self.container else { return }
        switch gest.state {
        case .began:
            self.beginFrame = container.frame
            self.beginTouchPoint = gest.location(in: self.view)
            break
        case .changed:
            guard self.config.animationType != .dialog else { break }
            self.container?.frame = self.getRectForPan(pan: gest)
            break
        case .ended,.cancelled:
            guard self.config.animationType != .dialog else {
                self.tapBGAction()
                break
            }
            self.container?.frame = self.getRectForPan(pan: gest)
            let isClosed: Bool = self.checkGestToClose(gest: gest)
            if isClosed == true {
                self.tapBGAction()
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.container?.frame = self.beginFrame
                }
            }
            break

        default:
            break
        }
    }
    
    private func checkGestToClose(gest: UIPanGestureRecognizer) -> Bool {
        if self.config.animationType == .drawer {
            if self.config.direction == .left {
                return gest.velocity(in: container).x < 0
            } else {
                return gest.velocity(in: container).x > 0
            }
        } else if self.config.animationType == .bottomSheet {
            return gest.velocity(in: container).y > 0
        }
        return false
    }

    private func getRectForPan(pan: UIPanGestureRecognizer) -> CGRect {
        guard let view = self.container else { return .zero }
        var rect: CGRect = view.frame
        let currentTouch = pan.location(in: self.view)
        if self.config.animationType == .drawer {
            let xRate = (self.beginTouchPoint.x - self.beginFrame.origin.x) / self.beginFrame.size.width
            let currentTouchDeltaX = xRate * view.jf.width
            var x = currentTouch.x - currentTouchDeltaX
            if x < self.beginFrame.origin.x && self.config.direction == .right {
                x = self.beginFrame.origin.x
            } else if x > self.beginFrame.origin.x && self.config.direction == .left {
                x = self.beginFrame.origin.x
            }
            
            rect.origin.x = x
        } else if self.config.animationType == .bottomSheet {
            let yRate = (self.beginTouchPoint.y - self.beginFrame.origin.y) / self.beginFrame.size.height
            let currentTouchDeltaY = yRate * view.jf.height
            var y = currentTouch.y - currentTouchDeltaY
            if y < self.beginFrame.origin.y {
                y = self.beginFrame.origin.y
            }
            rect.origin.y = y
        }
        return rect
    }
}

extension JFPopupController: UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isTapGest = gestureRecognizer is UITapGestureRecognizer
        let point = gestureRecognizer.location(in: gestureRecognizer.view)
        let rect = self.container?.frame ?? .zero
        let inContianer = rect.contains(point)
        if isTapGest {
            if inContianer {
                return false
            }
            if self.config.isDismissible == false {
                return false
            }
        } else {
            if self.config.enableDrag == false || self.config.isDismissible == false {
                return false
            }
        }
        return true
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transitionContext
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transitionContext
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.isShow == true {
            self.present(transitonContext: transitionContext)
        } else {
            self.dismiss(transitonContext: transitionContext)
        }
    }
    
    func present(transitonContext: UIViewControllerContextTransitioning) {
        let toNavi: UINavigationController = transitonContext.viewController(forKey:.to) as! UINavigationController
        let containerView = transitonContext.containerView
        containerView.addSubview(toNavi.view)
        guard let contianerView = self.container else {
            transitonContext.completeTransition(true)
            return
        }
        self.popupProtocol?.present(with: transitonContext, config: self.config, contianerView: contianerView, completion: { [weak self] isFinished in
            self?.autoDismissHandle()
        })
    }
    
    func dismiss(transitonContext: UIViewControllerContextTransitioning) {
        self.popupProtocol?.dismiss(with: transitonContext, config: self.config, contianerView: self.container, completion: nil)
    }
    
}

extension JFPopupController: JFPopupAnimationProtocol {
    
    public func dismiss(with transitonContext: UIViewControllerContextTransitioning?, config: JFPopupConfig, contianerView: UIView?, completion: ((Bool) -> ())?) {
        JFPopupAnimation.dismiss(with: transitonContext, config: self.config, contianerView: contianerView, completion: completion)
    }
    
    public func present(with transitonContext: UIViewControllerContextTransitioning?, config: JFPopupConfig, contianerView: UIView, completion: ((Bool) -> ())?) {
        JFPopupAnimation.present(with: transitonContext, config: self.config, contianerView: contianerView, completion: completion)
    }
}
