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

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC";
    self.view.backgroundColor = UIColor.whiteColor;
    [self popup_actionSheetWith:YES actions:^NSArray<JFPopupAction *> * _Nonnull{
        return  @[[[JFPopupAction alloc] initWith:@"拍摄" subTitle:@"照片或视频照片" autoDismiss:YES clickActionCallBack:^{
            
        }]];
    }];
    // Do any additional setup after loading the view.
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
