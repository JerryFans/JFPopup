//
//  JFPopupView.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/18.
//

import UIKit

/// popup va custom view use in view, not controller
public extension JFPopup where Base: JFPopupView {
    
    /// popup a bottomSheet with your custom view
    /// - Parameters:
    ///   - isDismissible: default true, will tap bg auto dismiss
    ///   - enableDrag: default true, will enable drag animate
    ///   - bgColor: background view color
    ///   - container: your custom view
    @discardableResult static func bottomSheet(with isDismissible: Bool = true, enableDrag: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), yourView: UIView? = nil, container: @escaping (_ mainContainer: JFPopupView?) -> UIView) -> JFPopupView? {
        var config: JFPopupConfig = .bottomSheet
        config.isDismissible = isDismissible
        config.enableDrag = enableDrag
        config.bgColor = bgColor
        return self.custom(with: config, yourView: yourView) { mainContainer in
            container(mainContainer)
        }
    }
    
    
    /// popup a drawer style view with your custom view
    /// - Parameters:
    ///   - direction: left or right
    ///   - isDismissible: default true, will tap bg auto dismiss
    ///   - enableDrag: default true, will enable drag animate
    ///   - bgColor: background view color
    ///   - container: your custom view
    @discardableResult static func drawer(with direction: JFPopupAnimationDirection = .left, isDismissible: Bool = true, enableDrag: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), yourView: UIView? = nil, container: @escaping (_ mainContainer: JFPopupView?) -> UIView) -> JFPopupView? {
        var config: JFPopupConfig = .drawer
        config.direction = direction
        config.isDismissible = isDismissible
        config.enableDrag = enableDrag
        config.bgColor = bgColor
        return self.custom(with: config, yourView: yourView) { mainContainer in
            container(mainContainer)
        }
    }
    
    
    /// popup a dialog style view with your custom view
    /// - Parameters:
    ///   - isDismissible: default true, will tap bg auto dismiss
    ///   - bgColor: background view color
    ///   - container: your custom view
    @discardableResult static func dialog(with isDismissible: Bool = true, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), yourView: UIView? = nil, container: @escaping (_ mainContainer: JFPopupView?) -> UIView) -> JFPopupView? {
        var config: JFPopupConfig = .dialog
        config.isDismissible = isDismissible
        config.bgColor = bgColor
        return self.custom(with: config, yourView: yourView) { mainContainer in
            container(mainContainer)
        }
    }
    
    /// popup a custom view with custom config
    /// - Parameters:
    ///   - config: popup config
    ///   - container: your custom view
    @discardableResult static func custom(with config: JFPopupConfig, yourView: UIView? = nil, container: @escaping (_ mainContainer: JFPopupView?) -> UIView?) -> JFPopupView? {
        if Thread.current != Thread.main {
            var v: JFPopupView?
            DispatchQueue.main.sync {
                v = JFPopupView(with: config) { mainContainer in
                    container(mainContainer)
                }
                v?.popup(into: yourView)
            }
            return v
        }
        let v = JFPopupView(with: config) { mainContainer in
            container(mainContainer)
        }
        v.popup(into: yourView)
        return v
    }
}

extension JFPopupView: JFPopupProtocol {
    
    public func dismissPopupView(completion: @escaping ((Bool) -> ())) {
        self.popupProtocol?.dismiss(with: nil, config: self.config, contianerView: self.container, completion: { [weak self] isFinished in
            self?.removeFromSuperview()
            completion(isFinished)
        })
    }
    
    public func autoDismissHandle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + self.config.autoDismissDuration.timeDuration()) {
            self.dismissPopupView { isFinished in
                
            }
        }
    }
    
    
}

public class JFPopupView: UIView {
    
    var beginTouchPoint: CGPoint = .zero
    var beginFrame: CGRect = .zero
    
    public weak var dataSource: JFPopupDataSource?
    
    public weak var popupProtocol: JFPopupAnimationProtocol?
    
    public var container: UIView?
    
    public var config: JFPopupConfig = .dialog
    
    deinit {
        print("JFPopupView dealloc")
    }
    
    public init(with config: JFPopupConfig, container: ((_ mainContainer: JFPopupView?) -> UIView?)?) {
        super.init(frame: UIScreen.main.bounds)
        self.container = container?(self)
        self.config = config
        self.configSubview()
        self.configGest()
    }

    public init(with config: JFPopupConfig, popupProtocol: JFPopupAnimationProtocol? = nil, container: ((_ mainContainer: JFPopupView?) -> UIView?)?) {
        super.init(frame: UIScreen.main.bounds)
        self.popupProtocol = popupProtocol
        self.container = container?(self)
        self.config = config
        self.configSubview()
        self.configGest()
    }
    
    func configSubview() {
        self.isUserInteractionEnabled = self.config.enableUserInteraction
        self.backgroundColor = self.config.bgColor
        if self.popupProtocol == nil {
            self.popupProtocol = self
        }
        if let container = self.container {
            self.addSubview(container)
        } else {
            if self.dataSource == nil {
                self.dataSource = self
            }
            if let v = self.dataSource?.viewForContainer() {
                self.addSubview(v)
                self.container = v
            }
        }
    }
    
    func configGest() {
        let panGest: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(gest:)))
        panGest.delegate = self
        self.addGestureRecognizer(panGest)
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tapBGAction))
        tapGest.delegate = self
        self.addGestureRecognizer(tapGest)
    }
    
    @objc func tapBGAction() {
        guard self.config.isDismissible else { return }
        self.dismissPopupView { isFinished in
            
        }
    }
    
    func popup(into yourView: UIView? = nil) {
        guard let view = self.container else { return }
        guard let window = UIApplication.shared.windows.first else { return }
        if let view = yourView {
            view.addSubview(self)
        } else {
            window.addSubview(self)
        }
        self.popupProtocol?.present(with: nil, config: self.config, contianerView: view, completion: { [weak self] isFinished in
            guard self?.config.enableAutoDismiss == true else { return }
            self?.autoDismissHandle()
        })
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JFPopupView: UIGestureRecognizerDelegate {
    
    @objc private func onPan(gest: UIPanGestureRecognizer) {
        guard self.config.enableDrag else {
            self.tapBGAction()
            return
        }
        guard let container = self.container else { return }
        switch gest.state {
        case .began:
            self.beginFrame = container.frame
            self.beginTouchPoint = gest.location(in: self)
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
        let currentTouch = pan.location(in: self)
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
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
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
}

extension JFPopupView: JFPopupDataSource {
    @objc public func viewForContainer() -> UIView? {
        return nil
    }
}

extension JFPopupView: JFPopupAnimationProtocol {
    public func dismiss(with transitonContext: UIViewControllerContextTransitioning?, config: JFPopupConfig, contianerView: UIView?, completion: ((Bool) -> ())?) {
        JFPopupAnimation.dismiss(with: transitonContext, config: self.config, contianerView: contianerView, completion: completion)
    }
    
    public func present(with transitonContext: UIViewControllerContextTransitioning?, config: JFPopupConfig, contianerView: UIView, completion: ((Bool) -> ())?) {
        JFPopupAnimation.present(with: transitonContext, config: self.config, contianerView: contianerView, completion: completion)
    }
}
