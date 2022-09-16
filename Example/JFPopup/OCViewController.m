//
//  OCViewController.m
//  JFPopup_Example
//
//  Created by 逸风 on 2021/10/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "OCViewController.h"
#import "JFPopup_Example-Swift.h"

@interface OCViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *button1;
@end

@implementation OCViewController

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"不停点我" forState:UIControlStateNormal];
        [_button setBackgroundColor:UIColor.redColor];
    }
    return _button;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button1 setTitle:@"Dismiss" forState:UIControlStateNormal];
        [_button1 setBackgroundColor:UIColor.blueColor];
    }
    return _button1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC";
    self.view.backgroundColor = UIColor.whiteColor;
    [self popup_actionSheetWith:YES actions:^NSArray<JFPopupAction *> * _Nonnull{
        return  @[[[JFPopupAction alloc] initWith:@"拍摄" subTitle:@"照片或视频照片" autoDismiss:YES clickActionCallBack:^{
            
        }]];
    }];
    [JFToastView toastWithHit:@"你好我兼容Object-C"];
    [self.view addSubview:self.button];
    self.button.frame = CGRectMake(50, 150, 150, 150);
    [self.button addTarget:self action:@selector(clickMe) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.button1];
    self.button1.frame = CGRectMake(50, 315, 150, 150);
    [self.button1 addTarget:self action:@selector(clickMe1) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)clickMe1 {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clickMe {
    //暂时只兼容 这三种， 后续有issue 可以继续支持
    int random = arc4random() % 3;
    if (random == 0) {
        [JFToastView toastWithHit:@"你好我兼容Object-C"];
    } else if (random == 1) {
        [JFToastView toastWithIcon:JFToastObjcAssetTypeImageName imageName:@"face"];
    } else {
        [JFToastView toastWithHit:@"支付成功" type:JFToastObjcAssetTypeSuccess imageName:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
