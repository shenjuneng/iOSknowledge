//
//  ViewController.m
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/22.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "ViewController.h"
#import "CLap_PlayerFrontView.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *grayBack;

@property (strong, nonatomic) UIImageView *playBackImageView;

/** playerFrontView */
@property (nonatomic, strong) CLap_PlayerFrontView *playerFrontView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"ll");
    
    self.playBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Library_播放背景"]];
    self.playBackImageView.frame = self.grayBack.bounds;
    [self.grayBack addSubview:self.playBackImageView];
}

- (IBAction)clickPlay:(UIButton *)sender {
    [self showPlayerView];
}


- (void)showPlayerView
{
    UIButton *btn = [[UIButton alloc] init];
//    [btn setBackgroundImage:[UIImage imageNamed:@"shop_white"] forState:UIControlStateNormal];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(kScreenWidth - btn.currentImage.size.width - 50, 30, btn.currentImage.size.width + 30, btn.currentImage.size.height + 30);
    btn.frame = CGRectMake(kScreenWidth - 150, 80, 100, 30);
    [btn addTarget:self action:@selector(hideGrayBack) forControlEvents:UIControlEventTouchUpInside];
    [self.grayBack addSubview:btn];
    
    //    self.playerFrontView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*kScreenWidth/kScreenHeight);
    //    self.playerFrontView.center = self.grayBack.center;
    [self.grayBack addSubview:self.playerFrontView];
    [self.playerFrontView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //                make.top.left.right.equalTo(@0);
        make.center.equalTo(self.grayBack);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(kScreenWidth*kScreenWidth/kScreenHeight));
    }];
    
    [self.navigationController.view addSubview:self.grayBack];
    self.grayBack.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.grayBack.alpha = 1.0;
    }];
}

- (void)hideGrayBack {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.grayBack.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [self.playerFrontView destroySelf];
        [self.playerFrontView removeFromSuperview];
        
        //        [self.audioPlayerView destroySelf];
        //        [self.audioPlayerView removeFromSuperview];
        [self.grayBack removeFromSuperview];
    }];
}


#pragma mark - set get
- (UIView *)grayBack
{
    if (_grayBack == nil) {
        _grayBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _grayBack.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        UIView *whiteBack = [[UIView alloc] init];
        whiteBack.backgroundColor = [UIColor clearColor];
        
        whiteBack.size = CGSizeMake(270, 300);
        
        whiteBack.center =  CGPointMake(_grayBack.center.x, _grayBack.center.y*0.9);
        [_grayBack addSubview:whiteBack];
    }
    return _grayBack;
}

- (CLap_PlayerFrontView *)playerFrontView {
    if (_playerFrontView == nil) {
        _playerFrontView = [CLap_PlayerFrontView playerFrontViewWithNavView:self.navigationController.view VCView:self.grayBack];
        
//        _playerFrontView.playerView.urlStr = self.post.video_path;
//        _playerFrontView.playerView.urlStr = @"http://vodymfmheh7.vod.126.net/vodymfmheh7/34c5572d-c5be-4173-8539-642fc612a10a.mp4";
//        _playerFrontView.playerView.urlStr = @"http:\/\/vodymfmheh7.vod.126.net\/vodymfmheh7\/582f5226-ccb1-47e3-a553-d0500d20124c.mp4";
        _playerFrontView.playerView.urlStr = @"http:\/\/vodymfmheh7.vod.126.net\/vodymfmheh7\/1709f89a-2c6e-4af6-b6f7-85abd07696b6.mp4";

//        _playerFrontView.shopProduct = nil;
    }
    return _playerFrontView;
}

@end
