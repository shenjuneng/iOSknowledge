//
//  CLap_VideoPlayerControlView.h
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/24.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJBasePlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLap_VideoPlayerControlView : UIView

@property (strong, nonatomic) SJBasePlayerView *basePlayerView;

/**
 播放器播放状态变化回调
 */
- (void)basePlayerTimeControlStatusChangedWithOldValue:(AVPlayerTimeControlStatus)oldValue
                                              newValue:(AVPlayerTimeControlStatus)newValue;

@end

NS_ASSUME_NONNULL_END
