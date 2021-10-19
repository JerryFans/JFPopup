//
//  JFToastView.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/16.
//

import UIKit

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
}

public enum JFToastPosition {
    case center
    case top
    case bottom
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
        stackView.spacing = 5
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
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.jf.rgb(0x09081B)
    }
    
    func configSubview() {
        self.addSubview(self.verStackView)
        self.verStackView.translatesAutoresizingMaskIntoConstraints = false
        self.verStackView.addConstraints([
            NSLayoutConstraint(item: self.titleLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: CGSize.jf.screenWidth() - 30 - 50),
        ])
        self.addConstraints(
            [
                NSLayoutConstraint(item: self.verStackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.verStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
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
        var height: CGFloat = 24
        var width = max(titleSize.width, iconSize.width) + CGFloat(50)
        
        if  titleSize != .zero {
            height += titleSize.height
        }
        
        if iconSize != .zero {
            height += titleSize != .zero ? 5 : 0
            height += iconSize.height
            if titleSize == .zero {
                width = height
            }
        }
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
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
