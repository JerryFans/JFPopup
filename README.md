# JFPopup

[![Version](https://img.shields.io/cocoapods/v/JFPopup.svg?style=flat)](https://cocoapods.org/pods/JFPopup)
[![License](https://img.shields.io/cocoapods/l/JFPopup.svg?style=flat)](https://cocoapods.org/pods/JFPopup)
[![Platform](https://img.shields.io/cocoapods/p/JFPopup.svg?style=flat)](https://cocoapods.org/pods/JFPopup)
[![Language](https://img.shields.io/badge/language-Swift-DE5C43.svg?style=flat)](https://cocoapods.org/pods/JFPopup)
[![Support](http://img.shields.io/badge/support-ObjC-brightgreen.svg?style=flat)](https://cocoapods.org/pods/JFPopup)

JFPopup is a Swift Module help you popup your custom view easily.

Support 3 way to popup, Drawer, Dialog and BottomSheet.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Quick Create your popup view

### Dialog 

对话框模式，类似UIAlertConroller, 你也可以编写你的自定义AlertView

```
self.popup.dialog {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            v.backgroundColor = .red
            return v
        }
```

![](http://image.jerryfans.com/dialog.gif)

### Drawer
抽屉模式，支持左右抽屉，宽度自定义，最大可以全屏，

```
//default left
self.popup.drawer {
            let v = DrawerView(frame: CGRect(x: 0, y: 0, width: CGSize.jf.screenWidth(), height: CGSize.jf.screenHeight()))
            v.closeHandle = { [weak self] in
                self?.popup.dismiss()
            }
            return v
        }

self.popup.drawer(with: .right) {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: CGSize.jf.screenHeight()))
            v.backgroundColor = .red
            return v
        }
```

![](http://image.jerryfans.com/drawer.gif)

### Bottomsheet

类似Flutter Bottomsheet, 底部往上弹出一个容器。 你也可以给予此创建你的个人自定义风格UIActionSheet. 底下有微信风格的组件已封装

```
self.popup.bottomSheet {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: CGSize.jf.screenWidth(), height: 300))
            v.backgroundColor = .red
            return v
        }
```

![](http://image.jerryfans.com/bottom_sheet.gif)

### 通用组件

- v1.0,暂时只有一款微信风格ActionSheet, 基于上面bottomSheet打造，后续会基于上面基础popup,打造更多基础组件

- v1.1 新增JFToastView, 支持多种Toast

### Toast

```
1、only hit

JFPopupView.popup.toast(hit: "普通toast,默认superview可以响应")

2、 hit + icon (内置success和fail, 支持自定义)

JFPopupView.popup.toast(hit: "支付成功", icon: .success)


JFPopupView.popup.toast(hit: "自定义Icon", icon: .imageName(name: "face"))

3、完全自定义

JFPopupView.popup.toast {
            [
                .hit("不响应super view,带背景色,加大时长,不用动画，在当前view弹出,position top"),
                .enableUserInteraction(true),
                .bgColor(UIColor.jf.rgb(0x000000,alpha: 0.3)),
                .autoDismissDuration(.seconds(value: 3)),
                .mainContainer(self.view),
                .withoutAnimation(true),
                .position(.top)
            ]
        }

```

![](http://image.jerryfans.com/toast.gif)


### ActionSheet

```
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
```

![](http://image.jerryfans.com/wechat_sheet.gif)

## VC模式创建

此方法推荐兼容OC情况下使用，或者你的popup View代码量非常大 需要一个vc来管理。

继承写法 （类似继承UITableView,dataSoure写在内部）

```
var config = JFPopupConfig.bottomSheet
        config.isDismissible = false
        let vc = TestCustomViewController(with: config)
        vc.show(with: self)
```
闭包写法

```
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
```


## Requirements

## Installation

JFPopup is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JFPopup', '1.1.0'
```

## Author

JerryFans, fanjiarong_haohao@163.com

## License

JFPopup is available under the MIT license. See the LICENSE file for more info.


