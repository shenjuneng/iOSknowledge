//
//  SJBasePlayerView.h
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SJBasePlayerViewDelegate <NSObject>
/**
 播放器状态变化回调
 */
- (void)basePlayerStatusChangedWithOldValue:(AVPlayerStatus)oldValue
                                   newValue:(AVPlayerStatus)newValue;

/**
 播放器播放状态变化回调
 */
- (void)basePlayerTimeControlStatusChangedWithOldValue:(AVPlayerTimeControlStatus)oldValue
                                              newValue:(AVPlayerTimeControlStatus)newValue;

@end

@interface SJBasePlayerView : UIView

@property (weak, nonatomic) id<SJBasePlayerViewDelegate> delegate;

/**
 初始化方法

 @param urlStr 播放地址
 @param needPlay 是否加载成功就立即播放
 */
- (instancetype)initWithUrlStr:(NSString *)urlStr
                      delegate:(id)delegate
              playeAfterLoaded:(BOOL)needPlay;

- (void)basePlayerPlay;

- (void)basePlayerPause;

- (void)basePlayerStop;

@end

NS_ASSUME_NONNULL_END
