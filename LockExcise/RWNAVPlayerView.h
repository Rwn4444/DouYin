//
//  RWNAVPlayerView.h
//  AVPlayer
//
//  Created by kang liu on 2018/1/14.
//  Copyright © 2018年 ShenHua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface RWNAVPlayerView : UIView

@property(nonatomic,strong)AVPlayerLayer *playLayer;

@property(nonatomic,strong)AVPlayer *player;

@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UIView *topView;
///播放音乐
- (void)p_musicPlayerWithURL:(NSURL *)playerItemURL;
///0 不是 1 是
@property(nonatomic,copy)NSString *vip;





@end
