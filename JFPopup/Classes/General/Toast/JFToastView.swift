//
//  JFToastView.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/16.
//

import UIKit

//only loading style have queue
var JFLoadingViewsQueue: [JFToastQueueTask] = []

public enum JFToastOption {
    case hit(String)
    case icon(JFToastAssetIconType)
    case enableAutoDismiss(Bool)
    case enableUserInteraction(Bool)
    case autoDismissDuration(JFTimerDuration)
    case bgColor(UIColor)
    case mainContainer(UIView)
    case withoutAnimation(Bool)
    case position(JFToastPosition)
    case enableRotation(Bool)
    case contentInset(UIEdgeInsets)
    case itemSpacing(CGFloat)
}

public enum JFToastAssetIconType {
    
    case success
    case fail
    case imageName(name: String, imageType: String = "png")
    
    func getImageName() -> (name: String, imageType: String)? {
        switch self {
        case .success:
            return ("success","png")
        case .fail:
            return ("fail","png")
        case .imageName(name: let name, imageType: let imageType):
            return (name,imageType)
        }
    }
}

public struct JFToastConfig {
    var title: String?
    var assetIcon: JFToastAssetIconType?
    var enableDynamicIsLand: Bool = false
    var enableRotation: Bool = false
    var contentInset: UIEdgeInsets = .init(top: 12, left: 25, bottom: 12, right: 25)
    var itemSpacing: CGFloat = 5.0
}

public class JFToastView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.isHidden = true
        return label
    }()
    
    let iconImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var verStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.iconImgView,self.titleLabel])
        stackView.alignment = .center
        stackView.spacing = self.config.itemSpacing
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    var config: JFToastConfig = JFToastConfig()
    
    public convenience init?(with config: JFToastConfig) {
        //assetIcon or title must have one value
        guard config.assetIcon != nil || config.title != nil else {
            return nil
        }
        self.init(frame: .zero)
        self.config = config
        self.configSubview()
    }

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: CGSize.jf.screenWidth(), y: CGSize.jf.screenHeight(), width: CGSize.jf.screenWidth(), height: CGSize.jf.screenHeight()))
        self.backgroundColor = .black
        self.layer.cornerRadius = self.config.enableDynamicIsLand ?  17 : 10
    }
    
    func configSubview() {
        self.addSubview(self.verStackView)
        self.verStackView.translatesAutoresizingMaskIntoConstraints = false
        self.verStackView.addConstraints([
            NSLayoutConstraint(item: self.titleLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: CGSize.jf.screenWidth() - 30 - self.config.contentInset.left - self.config.contentInset.right),
        ])
        self.addConstraints(
            [
                NSLayoutConstraint(item: self.verStackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.verStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: self.config.enableDynamicIsLand ? 34 / 2 : 0),
          ]
        )
        if let title = self.config.title {
            self.titleLabel.text =  title
            self.titleLabel.isHidden = false
        }
        
        if let assetIconType = self.config.assetIcon, let result = assetIconType.getImageName(), let image = self.getBundleImage(with: result.name, imageType: result.imageType) {
            self.iconImgView.image = image
            self.iconImgView.isHidden = false
        }
        
        self.layoutIfNeeded()
        let titleSize = self.titleLabel.frame.size
        let iconSize  = self.iconImgView.frame.size
        var height: CGFloat = self.config.contentInset.bottom + self.config.contentInset.top + (self.config.enableDynamicIsLand ? 34 : 0)
        let horInset = CGFloat(self.config.contentInset.left + self.config.contentInset.right)
        let dynamicisLandSize = 120.0 + 20.0 + (iconSize == .zero ? 20 : 0)
        var contentWidth = max(titleSize.width, iconSize.width)
        if iconSize.width > 0 && iconSize.width + horInset > titleSize.width {
            contentWidth = iconSize.width
        }
        var width = contentWidth + horInset
        
        if  titleSize != .zero {
            height += titleSize.height
            if self.config.enableDynamicIsLand {
                self.layer.cornerRadius = height / 2
            }
        }
        
        if iconSize != .zero {
            height += titleSize != .zero ? self.config.itemSpacing : 0
            height += iconSize.height
            if titleSize == .zero {
                width = height
            }
            if self.config.enableDynamicIsLand {
                self.layer.cornerRadius = 20
            }
        }
        if self.config.enableDynamicIsLand {
            width = max(width, dynamicisLandSize)
        }
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        if config.enableRotation {
            self.addRotationAnimation()
        }
    }
    
    func addRotationAnimation() {
        if self.iconImgView.layer.animationKeys() == nil {
            let baseAni = CABasicAnimation(keyPath: "transform.rotation.z")
            let toValue: CGFloat = .pi * 2.0
            baseAni.toValue = toValue
            baseAni.duration = 1.0
            baseAni.isCumulative = true
            baseAni.repeatCount = MAXFLOAT
            baseAni.isRemovedOnCompletion = false
            self.iconImgView.layer.add(baseAni, forKey: "rotationAnimation")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getBundleImage(with imageName: String, imageType: String = "png") -> UIImage? {
        if let img = UIImage(named: imageName) {
            return img
        }
        if let path = Bundle.main.path(forResource: imageName, ofType: imageType), let image = UIImage(contentsOfFile: path) {
            return image
        }
        guard let frameWorkPath = Bundle.main.path(forResource: "Frameworks", ofType: nil)?.appending("/JFPopup.framework") else { return nil }
        guard let bundlePath = Bundle(path: frameWorkPath)?.path(forResource: "JFPopup", ofType: "bundle") else { return nil }
        if let imgPath = Bundle(path: bundlePath)?.path(forResource: imageName + "@2x", ofType: imageType), let image = UIImage(contentsOfFile: imgPath) {
            return image
        }
        return nil
    }
}

public extension JFPopup where Base: JFPopupView {
    
    static func hideLoading() {
        
        let work = DispatchWorkItem {
            let firstTask = JFLoadingViewsQueue.first
            if firstTask != nil {
                JFLoadingViewsQueue.removeFirst()
            }
            if let v = firstTask?.popupView {
                v.dismissPopupView { isFinished in
                    if let nextTask = JFLoadingViewsQueue.first, let config = nextTask.config, let toastConfig = nextTask.toastConfig {
                        let popupView = JFPopupView.popup.custom(with: config, yourView: nextTask.mainContainer) { mainContainer in
                            JFToastView(with: toastConfig)
                        }
                        nextTask.popupView = popupView
                    }
                }
            }
        }
        
        if Thread.current == Thread.main {
            work.perform()
        } else {
            DispatchQueue.main.async(execute: work)
        }
        
    }
    
    static func loading() {
        self.loading(hit: nil)
    }
    
    static func loading(hit: String?) {
        self.loading(hit: hit, inView: nil)
    }
    
    
    ///show loading view
    /// - Parameters:
    ///   - hit: message
    ///   - inView: only support keywindow or ontroller.view, default keywindow
    static func loading(hit: String?, inView: UIView?) {
        var options: [JFToastOption] = [
            .enableAutoDismiss(false),
            .icon(.imageName(name: "jf_loading")),
            .enableRotation(true),
            .itemSpacing(15)]
        options += [.enableUserInteraction(true)]
        if let view = inView, !JFIsSupportDynamicIsLand {
            options += [.mainContainer(view)]
        }
        if let hit = hit {
            options += [.hit(hit)]
            options += [.contentInset(.init(top: 30, left: 47, bottom: 30, right: 47))]
        } else {
            options += [.contentInset(.init(top: 35, left: 35, bottom: 35, right: 35))]
        }
        JFPopupView.popup.toast { options }
    }
    
    static func toast(hit: String) {
        self.toast {
            [.hit(hit)]
        }
    }
    
    static func toast(hit: String, icon: JFToastAssetIconType) {
        self.toast {
            [.hit(hit),.icon(icon)]
        }
    }
    
    @discardableResult static func toast(options: () -> [JFToastOption]) -> JFPopupView? {
        let allOptions = options()
        var mainView: UIView?
        var config: JFPopupConfig = .dialog
        var toastConfig = JFToastConfig()
        config.bgColor = .clear
        config.enableUserInteraction = false
        config.enableAutoDismiss = true
        config.isDismissible = false
        toastConfig.enableDynamicIsLand = config.toastPosition == .dynamicIsland
        for option in allOptions {
            switch option {
            case .hit(let hit):
                toastConfig.title = hit
                break
            case .icon(let icon):
                toastConfig.assetIcon = icon
                break
            case .enableUserInteraction(let enable):
                config.enableUserInteraction = enable
                break
            case .enableAutoDismiss(let autoDismiss):
                config.enableAutoDismiss = autoDismiss
                break
            case .autoDismissDuration(let duration):
                config.autoDismissDuration = duration
                break
            case .bgColor(let bgColor):
                config.bgColor = bgColor
                break
            case .mainContainer(let view):
                mainView = view
                break
            case .withoutAnimation(let without):
                config.withoutAnimation = without
                break
            case .position(let pos):
                config.toastPosition = pos
                toastConfig.enableDynamicIsLand = config.toastPosition == .dynamicIsland && JFIsSupportDynamicIsLand
                break
            case .enableRotation(let enable):
                toastConfig.enableRotation = enable
                break
            case .contentInset(let inset):
                toastConfig.contentInset = inset
                break
            case .itemSpacing(let spcaing):
                toastConfig.itemSpacing = spcaing
                break
            }
        }
        
        guard toastConfig.title != nil || toastConfig.assetIcon != nil else {
            assert(toastConfig.title != nil || toastConfig.assetIcon != nil, "title or assetIcon only can one value nil")
            return nil
        }
        guard JFLoadingViewsQueue.count == 0 || config.enableAutoDismiss == true else {
            JFLoadingViewsQueue.append(JFToastQueueTask(with: config, toastConfig: toastConfig, mainContainer: mainView, popupView: nil))
            return nil
        }
        let popupView = self.custom(with: config, yourView: mainView) { mainContainer in
            JFToastView(with: toastConfig)
        }
        if config.enableAutoDismiss == false {
            JFLoadingViewsQueue.append(JFToastQueueTask(with: config, toastConfig: toastConfig, mainContainer: mainView, popupView: popupView))
        }
        return popupView
    }
}
