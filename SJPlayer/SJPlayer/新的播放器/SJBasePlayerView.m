//
//  SJBasePlayerView.m
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//


/*
 AVPlayer相关属性:
 @abstract
 接收机用于回放的能力。
 @discussion
 此属性的值是AVPlayerStatus，指示接收器是否可用于回放。当
 这个属性的值是AVPlayerStatusFailed，接收器不能再用于回放和一个新的
 需要在其位置创建实例。发生这种情况时，客户机可以检查error属性的值
 确定失败的性质。此属性是可使用KVO。
 @property (nonatomic, readonly) AVPlayerStatus status;
 
 @interface AVPlayer (AVPlayerPlaybackControl)
 
 @abstract
 表示希望的播放速率;0.0表示“暂停”，1.0表示希望以当前项目的正常速度播放。
 @discussion
 速率为0.0导致 timeControlStatus 变为 AVPlayerTimeControlStatusPaused
 @property (nonatomic) float rate;

 
 @property (nonatomic, readonly) AVPlayerTimeControlStatus timeControlStatus NS_AVAILABLE(10_12, 10_0);

 @abstract        Immediately plays the available media data at the specified rate.
 - (void)playImmediatelyAtRate:(float)rate NS_AVAILABLE(10_12, 10_0);
 
 @interface AVPlayer (AVPlayerItemControl)
 
 @property (nonatomic, readonly, nullable) AVPlayerItem *currentItem;
 
 @abstract        Replaces the player's current item with the specified player item.
 - (void)replaceCurrentItemWithPlayerItem:(nullable AVPlayerItem *)item;
 
 @property (nonatomic) AVPlayerActionAtItemEnd actionAtItemEnd;
 
 @interface AVPlayer (AVPlayerTimeControl)
 
 @abstract 获取当前时间
 @discussion        Returns the current time of the current item. Not key-value observable; use -addPeriodicTimeObserverForInterval:queue:usingBlock: instead.
 - (CMTime)currentTime;
 
 @discussion 指定时间和查找的时间可能不同， 如果要精确查找 参见seekToTime:toleranceBefore:toleranceAfter:
 - (void)seekToDate:(NSDate *)date;
 
 @interface AVPlayer (AVPlayerAdvancedRateControl)
 
 @interface AVPlayer (AVPlayerTimeObservation)

 @interface AVPlayer (AVPlayerMediaControl)
 
 @abstract 参考 MPVolumeView
 @property (nonatomic) float volume NS_AVAILABLE(10_7, 7_0);
 
 @property (nonatomic, getter=isMuted) BOOL muted NS_AVAILABLE(10_7, 7_0);

 
 AVPlayerItem相关属性:
 
 
 */

#import "SJBasePlayerView.h"

@interface SJBasePlayerView ()

@property (nonatomic, strong) AVPlayerItem *basePlayerItem;

@property (nonatomic, strong) AVPlayer *basePlayer;

@property (nonatomic, strong) NSString *basePlayUrlStr;

/** 视频总秒数 by Shenjun */
@property (nonatomic, assign) CGFloat baseTotalSeconds;

/** 当前秒数 */
@property (nonatomic, assign) CGFloat baseCurrentTime;

/** 缓冲秒数 */
@property (nonatomic, assign) CGFloat baseBufferTime;

/** 是否正在播放 */
@property (assign, nonatomic) BOOL isBasePlaying;

@end

@implementation SJBasePlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (instancetype)initWithUrlStr:(NSString *)urlStr delegate:(id)delegate playeAfterLoaded:(BOOL)needPlay
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        // 此处需要提前设置代理， 因为kVO方法会很快调用
        self.delegate = delegate;
        self.basePlayUrlStr = urlStr;
        [self setupPlayerItems:needPlay];
    }
    return self;
}

- (void)setupPlayerItems:(BOOL)needPlay {
    
    self.basePlayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_basePlayUrlStr]];
    [self.basePlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Item_loadedTimeRanges"];
    [self.basePlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Item_playbackLikelyToKeepUp"];
    [self.basePlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Item_playbackBufferEmpty"];
    [self.basePlayerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Item_playbackBufferFull"];
    [self.basePlayerItem addObserver:self forKeyPath:@"presentationSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Item_presentationSize"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.basePlayerItem];
    
    self.basePlayer = [AVPlayer playerWithPlayerItem:self.basePlayerItem];
    [self.basePlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Player_status"];
    [self.basePlayer addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"Player_timeControlStatus"];
    
    [(AVPlayerLayer *)self.layer setPlayer:self.basePlayer];
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    // 视频宽高比
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    if (@available(iOS 10.0, *)) {
        self.basePlayer.automaticallyWaitsToMinimizeStalling = NO;
    }
    
    if (needPlay) {
        [self.basePlayer play];
    }
    
}


/**
 KVO
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *contextStr = (__bridge NSString *)context;
    if ([contextStr isEqualToString:@"Player_status"]) {
        AVPlayerStatus newStatus = [change[@"new"] integerValue];
        AVPlayerStatus oldStatus = [change[@"old"] integerValue];
        if ([self.delegate respondsToSelector:@selector(basePlayerStatusChangedWithOldValue:newValue:)]) {
            [self.delegate basePlayerStatusChangedWithOldValue:oldStatus newValue:newStatus];
        }
    } else if ([contextStr isEqualToString:@"Player_timeControlStatus"]) {
        AVPlayerTimeControlStatus newStatus = [change[@"new"] integerValue];
        AVPlayerTimeControlStatus oldStatus = [change[@"old"] integerValue];
        if ([self.delegate respondsToSelector:@selector(basePlayerTimeControlStatusChangedWithOldValue:newValue:)]) {
            [self.delegate basePlayerTimeControlStatusChangedWithOldValue:oldStatus newValue:newStatus];
        }
    }
}


/**
 KVO监听需要移除， 否则闪退
 */
- (void)removeFromSuperview {
    [self.basePlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.basePlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.basePlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.basePlayerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
    [self.basePlayerItem removeObserver:self forKeyPath:@"presentationSize"];
    [self.basePlayer removeObserver:self forKeyPath:@"status"];
    [self.basePlayer removeObserver:self forKeyPath:@"timeControlStatus"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

#pragma mark - public method
- (void)basePlayerPlay {
    
    [self.basePlayer play];
}

- (void)basePlayerPause {
    [self.basePlayer pause];
}

- (void)basePlayerStop {
    
}

@end
