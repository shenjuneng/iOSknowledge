//
//  CLap_PlayerFrontView.h
//  clap
//
//  Created by 沈骏 on 2017/6/29.
//  Copyright © 2017年 沈骏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLap_BasePlayerView.h"
//#import "CLap_ShopProduct.h"

@interface CLap_PlayerFrontView : UIView <CLap_BasePlayerViewDelegate>

@property (weak, nonatomic) IBOutlet CLap_BasePlayerView *playerView;

/** superView */
@property (strong, nonatomic) UIView *superVCView;

/** superNavView */
@property (strong, nonatomic) UIView *superNavView;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIView *changeTimeView;

@property (weak, nonatomic) IBOutlet UIView *controlBackView;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLB;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLB;

@property (weak, nonatomic) IBOutlet UIProgressView *playProgress;

@property (weak, nonatomic) IBOutlet UIProgressView *bufferProgress;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UILabel *changeTimeLB;

@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

/** isFull */
@property (assign, nonatomic) BOOL isFull;

@property (assign, nonatomic) BOOL hidenControl;

/** shopProduct */
//@property (strong, nonatomic) CLap_ShopProduct *shopProduct;



- (instancetype)initViewWithNavView:(UIView *)navView
                             VCView:(UIView *)vcView;

+ (instancetype)playerFrontViewWithNavView:(UIView *)navView
                                    VCView:(UIView *)vcView;

- (void)destroySelf;

@end
