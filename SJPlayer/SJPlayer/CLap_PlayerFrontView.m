//
//  CLap_PlayerFrontView.m
//  clap
//
//  Created by 沈骏 on 2017/6/29.
//  Copyright © 2017年 沈骏. All rights reserved.
//

#import "CLap_PlayerFrontView.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation CLap_PlayerFrontView

- (instancetype)initViewWithNavView:(UIView *)navView
                             VCView:(UIView *)vcView
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CLap_PlayerFrontView" owner:nil options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[CLap_PlayerFrontView class]]) {
            self = object;
        }
    }
    
    if (self) {
        self.superNavView = navView;
        self.superVCView = vcView;
        self.playerView.delegate = self;
//        self.controlBackView.layer.cornerRadius = 4.0;
        
        [self.activityView startAnimating];
        
        // 告诉app支持后台播放
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
//         开始接受远程控制
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//        [self resignFirstResponder];
//        [self updateLockedScreenMusic];

    }
    
    return self;
}

- (void)updateLockedScreenMusic
{
//    if (self.shopProduct == nil) {
//        return;
//    }
    // 1.播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 2.初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = @"益乐宝专辑";
    // 歌手
//    info[MPMediaItemPropertyArtist] = self.shopProduct.speaker;
    // 歌曲名称
//    info[MPMediaItemPropertyTitle] = self.shopProduct.product_name;
    // 设置图片
//    NSString *imageStr = [NSString stringWithFormat:@"%@%@", New_ClapImgIP, self.shopProduct.product_image];
    
//    NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageStr]] returningResponse:nil error:nil];
//    UIImage* image = [UIImage imageWithData:data];
    
//    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:image];
    
    // 设置持续时间（歌曲的总时间）
    info[MPMediaItemPropertyPlaybackDuration] = @(self.playerView.totalSeconds);
    // 设置当前播放进度
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.playerView.currentTime);
    
    // 3.切换播放信息
    center.nowPlayingInfo = info;
    
    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event
    
    // 4.开始监听远程控制事件
    // 4.1.成为第一响应者（必备条件）
    [self becomeFirstResponder];
    // 4.2.开始监控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//重写父类方法，接受外部事件的处理
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"remote");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) { // 得到事件类型
                
            case UIEventSubtypeRemoteControlTogglePlayPause: // 暂停 ios6
                [self.playerView pausePlay]; // 调用你所在项目的暂停按钮的响应方法 下面的也是如此
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:  // 上一首
                
//                [self lastMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack: // 下一首
//                [self nextMusic:nil];
                break;
                
            case UIEventSubtypeRemoteControlPlay: //播放
                [self.playerView startPlay];
                break;
                
            case UIEventSubtypeRemoteControlPause: // 暂停 ios7
                [self.playerView pausePlay];
                break;
                
            default:
                break;
        }
    }
}

+ (instancetype)playerFrontViewWithNavView:(UIView *)navView
                                    VCView:(UIView *)vcView
{
    return [[self alloc] initViewWithNavView:navView VCView:vcView];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupNotifications];
}

- (void)setupNotifications
{
    // 监听 设备方向
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

#pragma mark - Notification / delegate
/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation statusBarorientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarorientation == interfaceOrientation) {
        return;
    }
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"dd");
            //            [self toOrientation:UIInterfaceOrientationPortraitUpsideDown];
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"z");
            [self toOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"L");
            
            [self toOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"R");
            [self toOrientation:interfaceOrientation];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - private
- (void)toOrientation:(UIInterfaceOrientation)orientation
{
    static BOOL isfinish = YES;
    
    if (isfinish == NO) {
        return;
    }
    
    isfinish = NO;
    
    NSLog(@"kScreenHeight:%f,kScreenWidth:%f", kScreenHeight, kScreenWidth);
    CGFloat screenH = kScreenHeight > kScreenWidth ? kScreenHeight : kScreenWidth;
    CGFloat screenW = kScreenHeight > kScreenWidth ? kScreenWidth : kScreenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        [UIApplication sharedApplication].statusBarOrientation = orientation;
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            self.transform = [self getTransformRotationAngle];
            //            CGFloat scaleX = screenH/screenW;
            //            CGFloat scaleY = screenW/self.width;
            //            self.transform = CGAffineTransformScale(self.transform, scaleX, scaleY);
            //            self.center = self.superNavView.center;
            //            [self.superNavView addSubview:self];
            //            [self removeFromSuperview];
            
            [self.superNavView addSubview:self];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                //                make.edges.equalTo(self.superNavView);
                make.width.equalTo(@(screenH));
                make.height.equalTo(self.mas_width).multipliedBy(screenW/screenH);
                make.center.equalTo(self.superNavView);
            }];
        }
        else {
            
            [UIApplication sharedApplication].statusBarHidden = NO;
            self.transform = CGAffineTransformIdentity;
            //            self.y = 0;
            
            [self.superVCView addSubview:self];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.left.right.equalTo(@0);
                make.center.equalTo(self.superVCView);
                make.width.equalTo(@(screenW));
                make.height.equalTo(@(screenW*screenW/screenH));
            }];
            
        }
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        isfinish = YES;
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            //            _isFullScreen = NO;
            //            self.fullScreenBtn.selected = NO;
            self.isFull = YES;
            [self hidenControlView];
        }
        else {
            //            self.fullScreenBtn.selected = YES;
            self.isFull = NO;
            [self showControl];
        }
        self.fullScreenBtn.selected  = self.isFull;

        
    }];
}

/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle
{
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

/**
 *  秒数转字符串
 *
 *  @param second 秒数
 *
 *  @return 时间字符串
 */
- (NSString *)convertTime:(CGFloat)second{
//    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    
//    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
//    
//    //    NSInteger interval = [zone secondsFromGMTForDate:d];
//    //
//    //    d = [d  dateByAddingTimeInterval: -interval];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    //    [formatter setDateFormat:@"HH:mm:ss"];
//    if (second/3600 >= 1) {
//        [formatter setDateFormat:@"HH:mm:ss"];
//    } else {
//        [formatter setDateFormat:@"mm:ss"];
//    }
//    NSString *showtimeNew = [formatter stringFromDate:d];
//    return showtimeNew;
    
    NSInteger hour = (int)second/3600;
    NSInteger minute = (int)second%3600/60;
    NSInteger seconds = (int)second%3600%60;
    return  [NSString stringWithFormat:@"%zd:%02zd:%02zd", hour, minute, seconds];
}

- (void)resetSubViews
{
    [self.activityView stopAnimating];
    [self.playBtn setSelected:NO];
    self.bufferProgress.progress = 0.0;
    self.playProgress.progress = 0.0;
    self.currentTimeLB.text = @"0:00:00";
    self.totalTimeLB.text = @"0:00:00";
    [self toOrientation:UIInterfaceOrientationPortrait];
}

- (void)showChangeTimeLB
{
    self.changeTimeLB.hidden = NO;
//    self.changeTimeLB.alpha = 1.0;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.changeTimeView.alpha = 1.0;
//    } completion:^(BOOL finished) {
//    }];
}

- (void)hiddenChangeTimeLB
{
    self.changeTimeLB.hidden = YES;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.changeTimeLB.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        self.changeTimeLB.hidden = YES;
//    }];
}

- (void)showControl
{
    [UIView animateWithDuration:0.3 animations:^{
        self.controlBackView.alpha = 1.0;
        
        
    } completion:^(BOOL finished) {
        self.hidenControl = NO;
        [UIApplication sharedApplication].statusBarHidden = NO;
    }];
}

- (void)hidenControlView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.controlBackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidenControl = YES;
        if (self.isFull) {
            [UIApplication sharedApplication].statusBarHidden = YES;
        }
    }];
}

#pragma mark - action
- (IBAction)clickPlayBtn:(UIButton *)sender {
    
    if (self.playerView.isPlaying == NO) {
        sender.selected = YES;
        [self.activityView startAnimating];
        [self.playerView startPlay];
    }
    else {
        sender.selected = NO;
        [self.playerView pausePlay];
    }
}

- (IBAction)GestToFullScreen:(UIPinchGestureRecognizer *)sender {
    
    NSLog(@"%f, %zd", sender.scale, sender.state);
    if (sender.scale > 1.5 && self.isFull == NO) {
        // 全屏
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }
    else if (sender.scale < 0.5 && self.isFull == YES) {
        // 缩小
        [self toOrientation:UIInterfaceOrientationPortrait];
    }
}

- (IBAction)panGesture:(UIPanGestureRecognizer *)panGes {
    
    if (self.playerView.basePlayerItem.status != AVPlayerStatusReadyToPlay) {
        return;
    }
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        [self showChangeTimeLB];
        [self.playerView pausePlay];
    }
    else if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint p = [panGes translationInView:self];
        self.changeTimeLB.text = [NSString stringWithFormat:@"%.0fs", p.x];
    }
    else if (panGes.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [panGes translationInView:self];
        [self.playerView seekToTheTimeValue:self.playerView.currentTime + p.x];
        [self.playerView startPlay];
        
        [self hiddenChangeTimeLB];
    }
    
}

- (IBAction)panShowControl:(UITapGestureRecognizer *)sender {
    if (self.hidenControl == NO) {
        [self hidenControlView];
    }
    else {
        [self showControl];
    }
}

- (IBAction)clickFullScreen:(UIButton *)sender {
    if (self.isFull == NO) {
//        sender.selected  = YES;
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }
    else {
//        sender.selected = NO;
        [self toOrientation:UIInterfaceOrientationPortrait];
    }
}


#pragma mark - public
- (void)destroySelf
{
//    [self.playerView destoryAVPlayer];
    [self.playerView stopPlay];
    
    [self resetSubViews];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - CLap_BasePlayerViewDelegate
- (void)basePlayerViewAutoPlay:(CLap_BasePlayerView *)basePlayerView
{
    [self.playBtn setSelected:YES];
}

- (void)basePlayerViewReadyPlay:(CLap_BasePlayerView *)basePlayerView
{
//    [self.playBtn setSelected:YES];
    [self.activityView stopAnimating];
}

- (void)basePlayerViewTimeObserver:(CLap_BasePlayerView *)basePlayerView
{
    NSString *totalTime = [self convertTime:basePlayerView.totalSeconds];
    NSString *currentTime = [self convertTime:basePlayerView.currentTime];
    
    self.currentTimeLB.text = currentTime;
    self.totalTimeLB.text = totalTime;
    self.playProgress.progress = basePlayerView.currentTime/basePlayerView.totalSeconds;
    
    self.bufferProgress.progress = basePlayerView.bufferTime/basePlayerView.totalSeconds;
    
//    [self.playBtn setSelected:YES];
    
    [self updateLockedScreenMusic];
}

// 结束播放
- (void)basePlayerViewEndPlay:(CLap_BasePlayerView *)basePlayerView
{
    [self resetSubViews];
}

@end
