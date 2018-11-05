//
//  CLap_VideoPlayerControlView.m
//  SJPlayer
//
//  Created by 沈骏 on 2018/10/24.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "CLap_VideoPlayerControlView.h"

@interface CLap_VideoPlayerControlView()

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;

@property (weak, nonatomic) IBOutlet UIProgressView *playProgress;

@property (weak, nonatomic) IBOutlet UIProgressView *bufferProgress;

@end

@implementation CLap_VideoPlayerControlView

#pragma mark - 父视图回调方法
- (void)basePlayerTimeControlStatusChangedWithOldValue:(AVPlayerTimeControlStatus)oldValue
                                              newValue:(AVPlayerTimeControlStatus)newValue {
    self.playBtn.enabled = YES;
    if (newValue == AVPlayerTimeControlStatusPlaying) {
        [self.playBtn setSelected:YES];
    } else {
        [self.playBtn setSelected:NO];
    }
}


#pragma mark - action
- (IBAction)clickPlayBtn:(UIButton *)sender {
    sender.enabled = NO;
    if (sender.selected == YES) {
        [self.basePlayerView basePlayerPause];
    } else {
        [self.basePlayerView basePlayerPlay];
    }
}


@end
