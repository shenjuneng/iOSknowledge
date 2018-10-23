//
//  SecondViewController.m
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "SecondViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AVPlayerViewController *avc = [[AVPlayerViewController alloc] init];
    // http:\/\/vodymfmheh7.vod.126.net\/vodymfmheh7\/582f5226-ccb1-47e3-a553-d0500d20124c.mp4
    NSURL * url = [NSURL URLWithString:@"http:\/\/vodymfmheh7.vod.126.net\/vodymfmheh7\/582f5226-ccb1-47e3-a553-d0500d20124c.mp4"];
//    NSURL * url = [NSURL URLWithString:@"http://vodymfmheh7.vod.126.net//vodymfmheh7//1709f89a-2c6e-4af6-b6f7-85abd07696b6.mp4"];
    avc.player = [AVPlayer playerWithURL:url];
    [self addChildViewController:avc];
    [self.view addSubview:avc.view];
    [avc.player play];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];

//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    
    [UIApplication sharedApplication].statusBarOrientation = UIDeviceOrientationLandscapeLeft;
}


@end
