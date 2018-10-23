//
//  CLap_BasePlayerView.m
//  Animation0524
//
//  Created by 沈骏 on 2017/6/28.
//  Copyright © 2017年 沈骏. All rights reserved.
//

#import "CLap_BasePlayerView.h"

@implementation CLap_BasePlayerView

#pragma mark - 用来将layer转为AVPlayerLayer, 必须实现的方法, 否则会崩
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

#pragma mark - set get
- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    
    self.basePlayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_urlStr]];
    [self.basePlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.basePlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.basePlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.basePlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.basePlayerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.basePlayerItem addObserver:self forKeyPath:@"presentationSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.basePlayerItem];
    
    
    [self.basePlayer play];
    
    if ([self.delegate respondsToSelector:@selector(basePlayerViewAutoPlay:)]) {
        self.isPlaying = YES;
        [self.delegate basePlayerViewAutoPlay:self];
    }
}

- (AVPlayer *)basePlayer
{
    if (_basePlayer == nil) {
        _basePlayer = [AVPlayer playerWithPlayerItem:self.basePlayerItem];
        [(AVPlayerLayer *)self.layer setPlayer:_basePlayer];
        
        AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
//        playerLayer.videoGravity =AVLayerVideoGravityResize;
        
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        if([[UIDevice currentDevice] systemVersion].intValue >= 10){
            //      增加下面这行可以解决ios10兼容性问题了
            _basePlayer.automaticallyWaitsToMinimizeStalling = NO;
        }
    }
    return _basePlayer;
}

#pragma mark - private method
//播放结束调用的方法
-(void)moviePlayEnd:(NSNotification *)notification
{
//    [_avplayer seekToTime:CMTimeMake(0, 1)];
    [self.basePlayer seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(basePlayerViewEndPlay:)]) {
            [self.delegate basePlayerViewEndPlay:self];
        }
    }];
}

#pragma mark - KVO方法 监听视频状态, 是核心部分
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusOk");
            if ([self.delegate respondsToSelector:@selector(basePlayerViewReadyPlay:)]) {
                [self.delegate basePlayerViewReadyPlay:self];
            }
            
            [self readyToPlay];
        }
        else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
        else {
            NSLog(@"AVPlayerStatusUnknown");
        }
        
    }
    else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        //本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f",totalBuffer);
        self.bufferTime = totalBuffer;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(updateBufferProgress:)]) {
//            [self.delegate updateBufferProgress:totalBuffer];
//        }
        
        
        
    }
    else if ([keyPath isEqualToString:@"rate"]) {
        // rate=1:播放，rate!=1:非播放
        float rate = self.basePlayer.rate;
        NSLog(@"rate: %f", rate);
    }
}

#pragma mark - public
#pragma mark 开始播放
- (void)startPlay
{
    [self.basePlayer play];
    self.isPlaying = YES;

}

#pragma mark 暂停播放
- (void)pausePlay
{
    [self.basePlayer pause];
    self.isPlaying = NO;
}

#pragma mark 停止播放
- (void)stopPlay
{
    [self.basePlayer pause];
    [self.basePlayer setRate:0];
    
    self.currentTime = 0;
    self.isPlaying = NO;
//    self.totalSeconds = 0;
}

#pragma mark 播放每秒调用一次
- (void)timeObserver
{
    self.currentTime = self.basePlayer.currentTime.value/self.basePlayerItem.currentTime.timescale;
    if ([self.delegate respondsToSelector:@selector(basePlayerViewTimeObserver:)]) {
        [self.delegate basePlayerViewTimeObserver:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(basePlayerViewReadyPlay:)]) {
        [self.delegate basePlayerViewReadyPlay:self];
    }
}

#pragma mark 以下是销毁以及销毁后再播放的相关方法
- (void)destoryAVPlayer
{
    if (self.basePlayerItem) {
        [self.basePlayerItem removeObserver:self forKeyPath:@"status"];
        [self.basePlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.basePlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [self.basePlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.basePlayerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
        [self.basePlayerItem removeObserver:self forKeyPath:@"presentationSize"];
    }
    [self.basePlayer replaceCurrentItemWithPlayerItem:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [(AVPlayerLayer *)self.layer setPlayer:nil];
    self.basePlayerItem =nil;
    self.basePlayer = nil;
    [self removeFromSuperview];
}

#pragma mark 准备播放
- (void)readyToPlay
{
    CMTime duration = self.basePlayerItem.duration;
    
    // 总帧数
    long long value =  duration.value;
    // 单位帧数
    NSInteger timescale = duration.timescale;
    // 总秒数
    _totalSeconds = duration.value/duration.timescale;
    
    NSLog(@"%lld, %zd, %f", value, timescale, _totalSeconds);
    
    __weak typeof(self) weakSelf = self;
    [self.basePlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        [weakSelf timeObserver];
    }];
}

#pragma mark 快进到指定秒数
- (void)seekToTheTimeValue:(float)value
{
    CMTime changedTime = CMTimeMakeWithSeconds(value, 1);
    
    //    WeakSelf
    [self.basePlayer pause];
    [self.basePlayer seekToTime:changedTime completionHandler:^(BOOL finished) {
        
    }];
}

- (void)dealloc
{
    [self destoryAVPlayer];
}

@end
