//
//  RWNAVPlayerView.m
//  AVPlayer
//
//  Created by kang liu on 2018/1/14.
//  Copyright © 2018年 ShenHua. All rights reserved.
//

#import "RWNAVPlayerView.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <Masonry.h>
#import "UIColor+hexStringToColor.h"

//#import "PlayListController.h"
static int count = 0;

///视频和音频 有一个开了 就把另一关闭
#define kclosePlayer       @"closePlayer"
///全屏通知
#define kFullScreen        @"kFullScreen"

@interface RWNAVPlayerView()

@property(nonatomic,strong)AVPlayerItem *item;

///播放按钮
@property (strong, nonatomic)UIButton *playBtn;
///盖了一个白色的按钮
@property (strong, nonatomic)UIButton *whiteplayBtn;

///快进15
@property(nonatomic,strong)UIButton *kuaijin;
///快退15
@property(nonatomic,strong)UIButton *kuaitui;

///时间
@property (strong, nonatomic)UILabel *timeLabel;

//用来现实视频的播放进度，并且通过它来控制视频的快进快退。
@property (strong, nonatomic)UISlider *avSlider;
///全屏按钮
@property (strong, nonatomic)UIButton *allScrenBtn;
@property (strong, nonatomic)UIButton *whiteFull;
///播放列表
@property (strong, nonatomic)UIButton *playlist;
@property (strong, nonatomic)UIButton *WhitePlaylist;

///用来判断当前视频是否准备好播放。
@property (assign, nonatomic)BOOL isReadToPlay;
@property (nonatomic,strong) id timeObserver;

@property (nonatomic,copy)NSString * totalTime;

//传进来的url
@property(nonatomic,strong) NSURL * videoUrl;

@end

@implementation RWNAVPlayerView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor grayColor];
        
        [self setupUI];
       
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeplayer) name:kclosePlayer object:nil];
        
    }
    return self;
    
}

//-(void)closeplayer{
//
//    [self.player play];
//    self.playBtn.selected=NO;
//    self.whiteplayBtn.selected=NO;
//
//}


-(void)setupUI{
    
    self.player = [[AVPlayer alloc] init];
    self.playLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    self.playLayer.frame =self.frame;
    [self.layer addSublayer:self.playLayer];
    
//    [self addSubview:self.topView];
//    [self.topView addSubview:self.kuaijin];
//    [self.topView addSubview:self.kuaitui];
    
//    [self addSubview:self.bottomView];
//    [self.bottomView addSubview:self.playBtn];
//    [self.bottomView addSubview:self.whiteplayBtn];
//    [self.bottomView addSubview:self.timeLabel];
//    [self.bottomView addSubview:self.avSlider];
//    [self.bottomView addSubview:self.allScrenBtn];
//    [self.bottomView addSubview:self.whiteFull];
//    [self.bottomView addSubview:self.playlist];
//    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenTopAndBottom)];
//    tap.numberOfTapsRequired = 1; // 单击
//    [self addGestureRecognizer:tap];
    
}

//-(void)hidenTopAndBottom{
//
//
//    [UIView animateWithDuration:0.5 animations:^{
//
//        if (self.bottomView.alpha == 0.0) {
//
//            self.bottomView.alpha = 1.0;
//            self.topView.alpha=1.0;
//
//        }else{
//
//            self.bottomView.alpha = 0.0;
//            self.topView.alpha=0.0;
//
//        }
//
//    } completion:^(BOOL finish){
//
//    }];
//
//
//}



//播放音频的方法
- (void)p_musicPlayerWithURL:(NSURL *)playerItemURL{
    
    self.videoUrl=playerItemURL;
    // 移除监听
    [self p_currentItemRemoveObserver];
    ///如果播放链接里有中文就放不了  所以得给它编码一下
    NSString *str = playerItemURL.absoluteString;
    if ([self hasChinese:str]) {
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURL *url =[NSURL URLWithString:str];
    // 创建要播放的资源
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:url];
    self.item=playerItem;
    // 播放当前资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    // 添加观察者
    [self p_currentItemAddObserver];
        
}


- (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}


-(UIView *)topView{
    
    if (!_topView) {
        
        _topView=[UIView new];
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(15);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
            
        }];
        
    }
    return _topView;
}

-(UIButton *)kuaijin{
    
    
    if (!_kuaijin) {
        _kuaijin = [UIButton  new];
        [_kuaijin addTarget:self action:@selector(kuaijinClick:) forControlEvents:UIControlEventTouchUpInside];
        [_kuaijin setTitle:@"快进" forState:UIControlStateNormal];
        _kuaijin.titleLabel.font=[UIFont systemFontOfSize:11];
        [_kuaijin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_kuaijin setImage:[UIImage imageNamed:@"shipin_kuaijin"] forState:UIControlStateNormal];
        _kuaijin.tag=200;
        [self.topView addSubview:_kuaijin];
        [_kuaijin mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(40);
            
        }];
    }
    return _kuaijin;
    
}


-(UIButton *)kuaitui{
    
    if (!_kuaitui) {
        _kuaitui = [UIButton  new];
        [_kuaitui addTarget:self action:@selector(kuaijinClick:) forControlEvents:UIControlEventTouchUpInside];
        [_kuaitui setTitle:@"快退" forState:UIControlStateNormal];
        _kuaitui.titleLabel.font=[UIFont systemFontOfSize:11];
        [_kuaitui setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_kuaitui setImage:[UIImage imageNamed:@"shipin_kuaitui"] forState:UIControlStateNormal];
        _kuaitui.tag=201;
        [self.topView addSubview:_kuaitui];
        [_kuaitui mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self.kuaijin.mas_left).mas_offset(-7);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(40);
            
        }];
    }
    return _kuaitui;
    
}

-(void)kuaijinClick:(UIButton*)sender{
    
    float time = self.avSlider.value;
    
    if (sender.tag==200) {
        
        time += 15;
        
    }else{
        
        time -= 15;

    }
    
    [self.player seekToTime:CMTimeMakeWithSeconds(time , self.item.currentTime.timescale )];
    
    
}

-(UIView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView=[UIView new];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(40);
            
        }];
        
    }
    return _bottomView;
    
}


-(UIButton *)playBtn{
    
    if (!_playBtn) {
        _playBtn = [UIButton  new];
        [_playBtn setImage:[UIImage imageNamed:@"shipin_zanting"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"shipin_bofang"] forState:UIControlStateSelected];
        [self.bottomView addSubview:_playBtn];
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(14);
            
        }];
    }
    return _playBtn;
    
}

-(UIButton *)whiteplayBtn{
    
    if (!_whiteplayBtn) {
        
        _whiteplayBtn=[UIButton new];
        [_whiteplayBtn addTarget:self action:@selector(playActionClick:) forControlEvents:UIControlEventTouchUpInside];
        _whiteplayBtn.backgroundColor=[UIColor yellowColor];
        [self.bottomView addSubview:_whiteplayBtn];
        [_whiteplayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.left.mas_equalTo(0);
            make.width.mas_equalTo(40);
            
        }];
        
    }
    return _whiteplayBtn;
    
}




-(UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel=[UILabel new];
        _timeLabel.textColor=[UIColor hexStringToColor:@"#FFFFFF"];
        _timeLabel.font=[UIFont systemFontOfSize:12];
        _timeLabel.text=@"00:00/00:00";
        [self.bottomView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.left.mas_equalTo(self.playBtn.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.playBtn.mas_centerY);
            
        }];
        
    }
    return _timeLabel;
}


- (UISlider *)avSlider{
    
    if (!_avSlider) {
        
        _avSlider = [UISlider new];
        [_avSlider addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _avSlider.minimumValue=0.0;
        _avSlider.value = 0.0;//指定初始值
        [_avSlider setThumbImage:[UIImage imageNamed:@"yinyue_dian"] forState:UIControlStateNormal];
        _avSlider.minimumTrackTintColor=[UIColor hexStringToColor:@"#683201"];
        _avSlider.maximumTrackTintColor=[UIColor hexStringToColor:@"#D8D8D8"];
        [self.bottomView addSubview:_avSlider];
        [_avSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.timeLabel.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.playBtn.mas_centerY);
            make.right.mas_equalTo(self.allScrenBtn.mas_left).mas_offset(-10);
            
        }];
        
    }
    return _avSlider;
}

-(UIButton *)allScrenBtn{
    
    if (!_allScrenBtn) {
        _allScrenBtn = [UIButton  new];
        [_allScrenBtn setImage:[UIImage imageNamed:@"shipin_fangda"] forState:UIControlStateNormal];
        [_allScrenBtn setImage:[UIImage imageNamed:@"suoxiao"] forState:UIControlStateSelected];
        [self.bottomView addSubview:_allScrenBtn];
        [_allScrenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self.playlist.mas_left).mas_offset(-15);
            make.centerY.mas_equalTo(self.playBtn.mas_centerY);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
            
        }];
    }
    return _allScrenBtn;
    
}

-(UIButton *)whiteFull{
    
    if (!_whiteFull) {
        _whiteFull = [UIButton  new];
        [_whiteFull addTarget:self action:@selector(quanping:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_whiteFull];
        [_whiteFull mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.avSlider.mas_right);
            make.right.mas_equalTo(self.WhitePlaylist.mas_left);
            
        }];
    }
    return _whiteFull;
    
    
}

-(UIButton *)playlist{
    
    if (!_playlist) {
        
        _playlist = [UIButton  new];
        [_playlist setImage:[UIImage imageNamed:@"shipin_liebiao"] forState:UIControlStateNormal];
        [_playlist addTarget:self action:@selector(pushToPlayList) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_playlist];
        [_playlist mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.playBtn.mas_centerY);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
            
        }];
        
    }
    return _playlist;
    
}

-(UIButton *)WhitePlaylist{
    
    if (!_WhitePlaylist) {
        _WhitePlaylist=[UIButton new];
        [_WhitePlaylist addTarget:self action:@selector(pushToPlayList) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_WhitePlaylist];
        [self.bottomView bringSubviewToFront:_WhitePlaylist];
        [_WhitePlaylist mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(40);
            
        }];
        
    }
    return _WhitePlaylist;
}


-(void)pushToPlayList{
    
//    if (![NSString getDefaultToken]) {
//
//        LoginViewController *vc = [[LoginViewController alloc]init];
//        [self.cyl_tabBarController.selectedViewController presentViewController:vc animated:YES completion:nil];
//        return;
//
//    }
    
    
    if (self.whiteFull.selected) {
        
        self.whiteFull.selected=NO;
        self.allScrenBtn.selected = !self.allScrenBtn.selected;
        [[NSNotificationCenter defaultCenter] postNotificationName:kFullScreen object:self.whiteFull];

    }
    
//    PlayListController *vc = [PlayListController new];
//    [(UINavigationController *)self.cyl_tabBarController.selectedViewController pushViewController:vc animated:YES];
    
}


-(void)quanping:(UIButton *)sender{
   
    sender.selected=!sender.selected;
    
    self.allScrenBtn.selected = !self.allScrenBtn.selected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFullScreen object:sender];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
//    if (self.whiteFull.selected) {
//
//        self.playLayer.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//
//    }else{
    
        self.playLayer.frame=self.frame;

//    }
    
    
//    [self.kuaijin layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:3];
    
//    [self.kuaitui layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:3];
    
    
}


- (void)playbackFinished:(NSNotification *)notifi {
    

    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
        [self.player play];
//        self.playBtn.selected=NO;
//        self.whiteplayBtn.selected=NO;
//        self.timeLabel.text = [NSString stringWithFormat:@"00:00/%@",_totalTime];
//        self.avSlider.value=0.0;
//        count=0;
//
//        if (self.bottomView.alpha==0) {
//            self.bottomView.alpha=1;
//            self.topView.alpha=1;
//        }
        
    }];
    
    
//    [self p_musicPlayerWithURL:self.videoUrl];
//    [self.player play];
    /*
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
        self.playBtn.selected=NO;
        self.whiteplayBtn.selected=NO;
        self.timeLabel.text = [NSString stringWithFormat:@"00:00/%@",_totalTime];
        self.avSlider.value=0.0;
        count=0;
        
        if (self.bottomView.alpha==0) {
            self.bottomView.alpha=1;
            self.topView.alpha=1;
        }
        
    }];
    
    ///播放完 让全屏变成小屏
    if (self.whiteFull.selected) {
        
        self.whiteFull.selected=NO;
        self.allScrenBtn.selected =NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kFullScreen object:self.whiteFull];
        
    }
    */
    
}


- (void)p_currentItemRemoveObserver {
    
    
    if (self.item) {
        
        [self.player.currentItem removeObserver:self  forKeyPath:@"status"];
        
    }
    
    //    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.player removeTimeObserver:self.timeObserver];
}

- (void)p_currentItemAddObserver {
    
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
    
    //监控缓冲加载情况属性
    //    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    
    //监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    /*
    //监控时间进度
    typeof(self) weakSelf=self;
    self.timeObserver = [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CMTime playerDuration = self.player.currentItem.duration;
        if (CMTIME_IS_INVALID(playerDuration)){
            self.avSlider.minimumValue = 0.0;
            return;
        }
       
        if (self.player.rate==1.0) {
            
            self.playBtn.selected=YES;
            self.whiteplayBtn.selected=YES;
            
        }else{
            
            self.playBtn.selected=NO;
            self.whiteplayBtn.selected=NO;

        }
        
        
        
        double duration = CMTimeGetSeconds(playerDuration);

        if (isfinite(duration)){
            
            float minValue = [self.avSlider minimumValue];
            float maxValue = [self.avSlider maximumValue];
            double time = CMTimeGetSeconds([self.player currentTime]);
            
        
            NSString *timestr =[NSString stringWithFormat:@"%@/%@",[self convertTime:time],[self convertTime:duration]];
            float value=(maxValue - minValue) * time / duration + minValue;
            
            ///不是vip只能看15分钟
            if ([self.vip isEqualToString:@"0"]) {
                
                int vipTime = 15*60;
                if (maxValue>vipTime) {
                    
                    maxValue=vipTime;
                    timestr=@"15:00";
                    
                }
                [self.avSlider setMaximumValue:maxValue];
                
                if (value >= vipTime) {
                    
                    [self playbackFinished:nil];
                    
                }
                
            }
            
            _timeLabel.text =timestr;
            [self.avSlider setValue:value];
            
            ///5秒后隐藏
            if (time >= 5.0 && count == 0) {
                
                count=1;
                self.bottomView.alpha = 0.0;
                self.topView.alpha=0.0;
                
            }

        }
        
    }];
     */
   
}


-(void)touchUpInside:(UISlider*)slider{
    
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value ,self.item.currentTime.timescale)];

}


#pragma mark  --播放点击事件--
- (void)playActionClick:(UIButton*)sender{

    if ( self.isReadToPlay) {
        
        self.playBtn.selected=!self.playBtn.selected;
        
        sender.selected = !sender.selected;
        
        if (sender.selected) {
            
           
            
            [self.player play];
            
        }else{
            
            [self.player pause];
            
        }
        
        
    }else{
        
//        MyLog(@"视频正在加载中");
        
    }
    
}





- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
//                NSLog(@"item 有误");
                self.isReadToPlay = NO;
                break;
            case AVPlayerItemStatusReadyToPlay:
//                NSLog(@"准好播放了");
                self.isReadToPlay = YES;
                /*
                if (CMTimeGetSeconds(self.player.currentItem.duration)) {
                    self.avSlider.maximumValue = CMTimeGetSeconds(self.player.currentItem.duration);
                }
                
                CMTime duration = self.item.duration;// 获取视频总长度
                CGFloat totalSecond = duration.value / duration.timescale;// 转换成秒
                _totalTime = [self convertTime:totalSecond];// 转换成播放时间
                self.timeLabel.text = [NSString stringWithFormat:@"00:00/%@",_totalTime];
                */
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
                break;
            default:
                break;
        }
    }
    
    
    
}

- (NSString *)convertTime:(CGFloat)second{
    
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    if (second<0) {
        showtimeNew=@"00:00";
    }
    
    return showtimeNew;
    
}


-(void)dealloc{
    
//    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kclosePlayer object:nil];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
