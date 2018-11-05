//
//  SecondViewController.m
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "SecondViewController.h"
#import "CLap_VideoPlayerView.h"

@interface SecondViewController ()



@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

/**
 安全区域
 */
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    CLap_VideoPlayerView *view = [CLap_VideoPlayerView CLap_VideoPlayerView];
//    view.urlStr = @"http://vodymfmheh7.vod.126.net/vodymfmheh7/582f5226-ccb1-47e3-a553-d0500d20124c.mp4";
//    view.urlStr = @"http:\/\/vodymfmheh7.vod.126.net\/vodymfmheh7\/1709f89a-2c6e-4af6-b6f7-85abd07696b6.mp4";
    view.urlStr = @"https://media.w3.org/2010/05/sintel/trailer.mp4";
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.safeAreaInsets.top);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];
}


@end
