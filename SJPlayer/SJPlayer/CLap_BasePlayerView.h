//
//  CLap_BasePlayerView.h
//  Animation0524
//
//  Created by 沈骏 on 2017/6/28.
//  Copyright © 2017年 沈骏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class  CLap_BasePlayerView;

@protocol CLap_BasePlayerViewDelegate <NSObject>

// 自动开始 播放代理
- (void)basePlayerViewAutoPlay:(CLap_BasePlayerView *)basePlayerView;

// 开始 播放代理
- (void)basePlayerViewReadyPlay:(CLap_BasePlayerView *)basePlayerView;

// 秒动
- (void)basePlayerViewTimeObserver:(CLap_BasePlayerView *)basePlayerView;

// 结束播放
- (void)basePlayerViewEndPlay:(CLap_BasePlayerView *)basePlayerView;

@end

@interface CLap_BasePlayerView : UIView

/** by Shenjun */
@property (nonatomic, strong) AVPlayerItem *basePlayerItem;

/** by Shenjun */
@property (nonatomic, strong) AVPlayer *basePlayer;


@property (nonatomic, strong) NSString *urlStr;

/** 视频总秒数 by Shenjun */
@property (nonatomic, assign) CGFloat totalSeconds;

/** 当前秒数 */
@property (nonatomic, assign) CGFloat currentTime;

/** 缓冲秒数 */
@property (nonatomic, assign) CGFloat bufferTime;

/** isPlaying */
@property (assign, nonatomic) BOOL isPlaying;

/**  */
@property (weak, nonatomic) id<CLap_BasePlayerViewDelegate> delegate;

#pragma mark 开始播放
- (void)startPlay;

#pragma mark 暂停播放
- (void)pausePlay;

#pragma mark 停止播放
- (void)stopPlay;

#pragma mark 播放每秒调用一次
- (void)timeObserver;

#pragma mark 以下是销毁以及销毁后再播放的相关方法
- (void)destoryAVPlayer;

#pragma mark 准备播放
- (void)readyToPlay;

#pragma mark 快进到指定秒数
- (void)seekToTheTimeValue:(float)value;

@end
