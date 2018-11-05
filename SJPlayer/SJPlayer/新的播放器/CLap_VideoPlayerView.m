//
//  CLap_VideoPlayerView.m
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "CLap_VideoPlayerView.h"
#import "CLap_VideoPlayerControlView.h"
#import "SJBasePlayerView.h"

@interface CLap_VideoPlayerView () <SJBasePlayerViewDelegate>

@property (weak, nonatomic) IBOutlet CLap_VideoPlayerControlView *playControlView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (strong, nonatomic) SJBasePlayerView *basePlayerView;

@end

@implementation CLap_VideoPlayerView

- (instancetype)initView
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CLap_VideoPlayerView" owner:nil options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[CLap_VideoPlayerView class]]) {
            self = object;
        }
    }
    
    if (self) {
        
    }
    
    return self;
}

+ (instancetype)CLap_VideoPlayerView
{
    return [[self alloc] initView];
}

#pragma mark - 准备设置
/**
 获取url， 立即初始化播放器
 */
- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    
    self.basePlayerView = [[SJBasePlayerView alloc] initWithUrlStr:_urlStr
                                                          delegate:self
                                                  playeAfterLoaded:NO];
    self.playControlView.basePlayerView = self.basePlayerView;
    self.basePlayerView.backgroundColor = UIColor.greenColor;
    [self insertSubview:self.basePlayerView atIndex:0];
    [self.basePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - SJBasePlayerViewDelegate
- (void)basePlayerStatusChangedWithOldValue:(AVPlayerStatus)oldValue
                                   newValue:(AVPlayerStatus)newValue {
    if (newValue == AVPlayerStatusReadyToPlay) {
        [self.activityView stopAnimating];
    }
}

- (void)basePlayerTimeControlStatusChangedWithOldValue:(AVPlayerTimeControlStatus)oldValue
                                              newValue:(AVPlayerTimeControlStatus)newValue {
    [self.playControlView basePlayerTimeControlStatusChangedWithOldValue:oldValue newValue:newValue];
}

@end
