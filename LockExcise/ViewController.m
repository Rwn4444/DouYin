//
//  ViewController.m
//  LockExcise
//
//  Created by shenhua on 2018/9/4.
//  Copyright © 2018年 RWN. All rights reserved.
//

#import "ViewController.h"
#import "HomeTableViewCell.h"

#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * homeTable;

@property(nonatomic,strong) NSMutableArray* dataArray;

@property(nonatomic,assign) CGFloat  lastcontentOffsetY;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addUI];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self scrollViewDidEndDecelerating:self.homeTable];

}



-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
}

-(void)addUI{
    
    self.lastcontentOffsetY = -2.0;
    if (@available(iOS 11.0, *)) {
        self.homeTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view addSubview:self.homeTable];
    
}


#pragma mark ---UITableViewDelegate UITableViewDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%s",__func__);
    HomeTableViewCell *cell =[HomeTableViewCell cellWithTableView:tableView];
    if (self.dataArray.count>indexPath.row) {
        NSString *name =self.dataArray[indexPath.row];
        cell.dataUrl=[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:name ofType:@"mp4"]];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%s",__func__);
    
}


-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableViewCell *homeCell = (HomeTableViewCell *)cell;
    [homeCell pause];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [UIScreen mainScreen].bounds.size.height;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"scrollViewDidScroll:--------%f",scrollView.contentOffset.y);
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidEndDecelerating:----------%f",scrollView.contentOffset.y);
    if (self.lastcontentOffsetY != scrollView.contentOffset.y) {
        
        self.lastcontentOffsetY = scrollView.contentOffset.y;
        
        NSInteger row = self.lastcontentOffsetY/KScreenHeight * 1.0;
        NSIndexPath * path =[NSIndexPath indexPathForRow:row inSection:0];
        HomeTableViewCell *cell =[self.homeTable  cellForRowAtIndexPath:path];
        [cell start];
        
    }
    
}

#pragma mark --lazy init--
-(UITableView *)homeTable{
    
    if (!_homeTable) {
        
        _homeTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.pagingEnabled=YES;
        _homeTable.showsVerticalScrollIndicator=NO;
        _homeTable.showsHorizontalScrollIndicator=NO;
        _homeTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        _homeTable.estimatedRowHeight = 0;
        _homeTable.estimatedSectionHeaderHeight = 0;
        _homeTable.estimatedSectionFooterHeight = 0;
        [self.view addSubview:_homeTable];
        
    }
    return _homeTable;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
        for (int i=1; i<5; i++) {
            [_dataArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _dataArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
