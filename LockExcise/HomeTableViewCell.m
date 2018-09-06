//
//  HomeTableViewCell.m
//  LockExcise
//
//  Created by shenhua on 2018/9/4.
//  Copyright © 2018年 RWN. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "RWNAVPlayerView.h"
#import <Masonry.h>
#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface HomeTableViewCell()

@property(nonatomic,strong) RWNAVPlayerView * player;

@property(nonatomic,strong) UIImageView * downImageView;

@property(nonatomic,strong) CAReplicatorLayer  * repLayer;

@end

@implementation HomeTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString * identifier =  NSStringFromClass([self class]);
    HomeTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor=[UIColor blackColor];
        [self.contentView addSubview:self.player];
        [self.contentView addSubview:self.downImageView];
        
        
        

    }
    return self;
}


-(RWNAVPlayerView *)player{
    
    if (!_player) {
        
        _player=[[RWNAVPlayerView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_player];
        [_player mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.bottom.mas_equalTo(0);
            
        }];
        
    }
    return _player;
    
}


-(UIImageView *)downImageView{
    
    if (!_downImageView) {
        _downImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _downImageView.layer.cornerRadius=30;
        _downImageView.layer.masksToBounds=YES;
        _downImageView.image=[UIImage imageNamed:@"WechatIMG7"];
//        _downImageView.layer.backgroundColor=[UIColor yellowColor].CGColor;
        [self.contentView addSubview:_downImageView];
        [_downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.mas_equalTo(60);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-20);
            
        }];
        
    }
    return _downImageView;
}

-(void)setDataUrl:(NSURL *)dataUrl{
    
    _dataUrl=dataUrl;
    [self.player p_musicPlayerWithURL:dataUrl];
    
}

//暂停
-(void)pause{
    
    [self.player.player pause];
    [self.repLayer removeFromSuperlayer];
    self.repLayer=nil;
}

//开始
-(void)start{
    
    [self.player.player play];
    [self.contentView.layer addSublayer:self.repLayer];
    [self.contentView bringSubviewToFront:self.downImageView];

    
}

-(CAReplicatorLayer *)repLayer{
    
    if (!_repLayer) {
        
        CALayer *layer = [CALayer layer];
        layer.bounds=CGRectMake(0, 0, 24, 30);
        layer.position=self.downImageView.layer.position;
        [layer setContents:(id)[UIImage imageNamed:@"music"].CGImage];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position";
        CGMutablePathRef curvedPath = CGPathCreateMutable();
        
        CGPathMoveToPoint(curvedPath, NULL, KScreenWidth-50, KScreenHeight-5);
        CGPathAddQuadCurveToPoint(curvedPath, NULL, KScreenWidth-150, KScreenHeight-50, KScreenWidth-120, KScreenHeight-100);
        animation.path=curvedPath;
        CGPathRelease(curvedPath);
        
        CABasicAnimation *basic =[CABasicAnimation animation];
        basic.keyPath=@"transform.scale";
        basic.fromValue=@0.2;
        basic.toValue=@0.6;
        
        CAAnimationGroup *group =[CAAnimationGroup animation];
        group.repeatCount=MAXFLOAT;
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeForwards;
        group.duration = 3.0f;
        group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group.animations =@[animation,basic];
        [layer addAnimation:group forKey:nil];
        
        CAReplicatorLayer  * repLayer = [CAReplicatorLayer  layer];
        repLayer.frame=self.contentView.bounds;
        repLayer.instanceCount=4;
        repLayer.instanceDelay=1.0;
        [repLayer addSublayer:layer];
        [self.player.layer addSublayer:repLayer];
        _repLayer=repLayer;
        
    }
    return _repLayer;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
