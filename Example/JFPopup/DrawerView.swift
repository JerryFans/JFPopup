//
//  DrawerView.swift
//  JFPopup
//
//  Created by 逸风 on 2021/10/10.
//

import UIKit

class DrawerView: UIView {
    
    var closeHandle: (() -> ())?

    lazy var closeBtn: UIButton = {
        var btn = UIButton(type: .system)
        if #available(iOS 13.0, *) {
             btn = UIButton(type: .close)
        } else {
            btn.setTitle("关闭", for: .normal)
            btn.setTitleColor(.black, for: .normal)
        }
        btn.jf.right = self.jf_width - 60
        btn.jf.top = 15 + CGFloat.jf.statusBarHeight()
        btn.jf.size = CGSize(width: 45, height: 45)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return btn
    }()
    
    @objc func closeAction() {
        self.closeHandle?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.jf.rgb(0x7e7eff)
        self.addSubview(self.closeBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
