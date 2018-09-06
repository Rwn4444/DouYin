//
//  HomeTableViewCell.h
//  LockExcise
//
//  Created by shenhua on 2018/9/4.
//  Copyright © 2018年 RWN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property(nonatomic,strong) NSURL * dataUrl;

//暂停
-(void)pause;
////开始
-(void)start;

+(instancetype)cellWithTableView:(UITableView *)tableView;



@end
