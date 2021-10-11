//
//  TestCustomViewController.swift
//  JFPopup_Example
//
//  Created by 逸风 on 2021/10/11.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import JFPopup

class TestCustomViewController: JFPopupController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func clickBtnAction() {
        self.closeVC(with: nil)
    }
    
    override func viewForContainer() -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        view.frame = CGRect(x: 0, y: 0, width: CGSize.jf.screenWidth(), height: 300)
        var btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        btn.setTitle("点击才能退出", for: .normal)
        btn.addTarget(self, action: #selector(clickBtnAction), for: .touchUpInside)
        btn.setTitleColor(.white, for: .normal)
        view.addSubview(btn)
        btn.jf.centerY = view.jf.centerY
        btn.jf.centerX = view.jf.centerX
        return view
    }
    

}
