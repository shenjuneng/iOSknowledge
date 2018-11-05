//
//  CLap_VideoPlayerView.h
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLap_VideoPlayerView : UIView

@property (copy, nonatomic) NSString *urlStr;

+ (instancetype)CLap_VideoPlayerView;

@end

NS_ASSUME_NONNULL_END
