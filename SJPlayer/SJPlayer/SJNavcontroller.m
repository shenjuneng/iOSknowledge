//
//  SJNavcontroller.m
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "SJNavcontroller.h"

@interface SJNavcontroller ()

@end

@implementation SJNavcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    return NO;
}

/*
 UIDeviceOrientationUnknown,
 UIDeviceOrientationPortrait,
 UIDeviceOrientationPortraitUpsideDown,
 UIDeviceOrientationLandscapeLeft,
 UIDeviceOrientationLandscapeRight,
 UIDeviceOrientationFaceUp,
 UIDeviceOrientationFaceDown
 */
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//
//    if ([self.topViewController isKindOfClass:NSClassFromString(@"SecondViewController")]) {
////        UIDeviceOrientation deviceOr = [UIDevice currentDevice].orientation;
////
////        UIInterfaceOrientationMask interfaceOrmMask = UIInterfaceOrientationMaskPortrait;
//        return UIInterfaceOrientationMaskAll;
//    } else {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

@end
