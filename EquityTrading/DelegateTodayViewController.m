//
//  DelegateTodayViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-4-14.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "DelegateTodayViewController.h"
#import "AppDelegate.h"

#define TTABLEVIEW 10001
#define WAITTABLEVIEW 10006
#define SHIPTABLEVIEW 10009
#define TFINISHTABLEVIEW 10002
#define WAITTTR 10007
#define SHIPTTR 10008
#define TTR 10003
#define TFINISHTR 10004
#define TSEGSCROLLVIEW 10005

@interface DelegateTodayViewController (){
    NSString *start;
    NSString *finishStart;
    NSString *shipStart;
    NSString *waitStart;
    NSString *limit;
    NSMutableArray *dataList;
    NSMutableArray *finishDataList;
    NSMutableArray *waitDataList;
    NSMutableArray *shipDataList;
    BOOL hasMore;
    BOOL waitHasMore;
    BOOL finishHasMore;
    BOOL shipHasMore;
    UITableViewCell *moreCell;
    UITableViewCell *waitMoreCell;
    UITableViewCell *finishMoreCell;
    UITableViewCell *shipMoreCell;
    UIView *cellBackView;

    float addHight;
    NSString *bagFlag;
     UISegmentedControl  *segmented;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *waitTableView;
@property (strong, nonatomic) UITableView *shipTableView;
@property (strong, nonatomic) UITableView *finishTableView;


@end

@implementation DelegateTodayViewController


-(void) segmentAction:(UISegmentedControl *)Seg{
    
    
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %li",(long)Index);
    
    __weak typeof(self) weakSelf = self;
    
    if (Seg.selectedSegmentIndex == 0) {
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
    } else if(Seg.selectedSegmentIndex == 1){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth* Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }else if(Seg.selectedSegmentIndex == 2){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }else if(Seg.selectedSegmentIndex == 3){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth* Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV
{
    
    if (scrollV == _scrollView) {
        CGFloat pageWidth = ScreenWidth;
        NSInteger page = _scrollView.contentOffset.x / pageWidth ;
        segmented.selectedSegmentIndex = page;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    start = @"1";
    waitStart = @"1";
    shipStart = @"1";
    finishStart = @"1";
    limit = @"10";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
         statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"全部",@"已成交",@"已申报",@"已撤销",nil];
    
    segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmented.frame = CGRectMake(10, 54 + addHight, ScreenWidth - 20, 30);
 
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextColor,  [UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextShadowColor ,nil];
    
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    
    
    
    segmented.selectedSegmentIndex = 0;//设置默认选择项索引
    
    segmented.backgroundColor = [UIColor whiteColor];
    
    segmented.tintColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    
    segmented.multipleTouchEnabled = NO;
    
    segmented.segmentedControlStyle = UISegmentedControlStyleBezeled;
    
    
    
    [segmented addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    
    
    [self.view addSubview:segmented];
    
//温馨提示
    
    UIImageView *tip = [[UIImageView alloc] initWithFrame:CGRectMake(10, addHight + 44 + 50, 15, 15)];
    tip.image = [UIImage imageNamed:@"icon_nof"];
    
    [self.view addSubview:tip];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(30, addHight + 44 + 50, ScreenWidth - 40, 15)];
    tipLab.text = @"温馨提示认购产品不能撤单";
     tipLab.backgroundColor = [UIColor clearColor];
    tipLab.textColor = [ConMethods colorWithHexString:@"999999"];
    tipLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:tipLab];
    
    
    
    //给segmentedControl添加scrollView的联动事件
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 75;
   
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75 + 44 + addHight, ScreenWidth, scrollViewHeight)];
   
    self.scrollView.tag = TSEGSCROLLVIEW;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*4, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 75 + 44 + addHight, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
   
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, scrollViewHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTag:TTABLEVIEW];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
   
    [self.scrollView addSubview:self.tableView];
    
    //初始化已发货TableView
    
    self.finishTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, scrollViewHeight)];
    self.finishTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.finishTableView setTag:TFINISHTABLEVIEW];
    [self.finishTableView setDelegate:self];
    [self.finishTableView setDataSource:self];
    [self.finishTableView setBackgroundColor:[UIColor clearColor]];
    
    [self.scrollView addSubview:self.finishTableView];
    
    //初始化已发货TableView
    
    self.waitTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, scrollViewHeight)];
    self.waitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.waitTableView setTag:WAITTABLEVIEW];
    [self.waitTableView setDelegate:self];
    [self.waitTableView setDataSource:self];
    [self.waitTableView setBackgroundColor:[UIColor clearColor]];
    
   
    [self.scrollView addSubview:self.waitTableView];
    
    
    //初始化已发货TableView
    
    self.shipTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth, scrollViewHeight)];
    self.shipTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.shipTableView setTag:SHIPTABLEVIEW];
    [self.shipTableView setDelegate:self];
    [self.shipTableView setDataSource:self];
    [self.shipTableView setBackgroundColor:[UIColor clearColor]];
    //加入下拉刷新
    [self.scrollView addSubview:self.shipTableView];
    
    
    //全部 2.6.8
    [self requestMethods];
    //全部成交  6
    [self requestFinshMethods];
    // 已申报未成交  2
    [self requestWiatMethods];
    //全部撤单  8
    [self requestshipMethods];
    
}

//请求数据方法
-(void)requestMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    
    NSDictionary *parameters = @{@"sbjg":@"8,6,2"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryTodayEntrust] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
           
               dataList = [[responseObject objectForKey:@"object"] mutableCopy];
            [self.tableView reloadData];
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            //[self reloadDataWith:[[responseObject objectForKey:@"object"] objectAtIndex:0]];
        } else {
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    [[HttpMethods Instance] activityIndicate:NO
                                                  tipContent:[responseObject objectForKey:@"msg"]
                                               MBProgressHUD:nil
                                                      target:self.navigationController.view
                                             displayInterval:3];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
            } else {
                
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
            }
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}


-(void)requestFinshMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    
    NSDictionary *parameters = @{@"sbjg":@"6"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryTodayEntrust] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            finishDataList = [[responseObject objectForKey:@"object"] mutableCopy];
            [self.finishTableView reloadData];
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            //[self reloadDataWith:[[responseObject objectForKey:@"object"] objectAtIndex:0]];
        } else {
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    [[HttpMethods Instance] activityIndicate:NO
                                                  tipContent:[responseObject objectForKey:@"msg"]
                                               MBProgressHUD:nil
                                                      target:self.navigationController.view
                                             displayInterval:3];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
            } else {
                
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
            }
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}


-(void)requestWiatMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    
    NSDictionary *parameters = @{@"sbjg":@"2"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryTodayEntrust] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            waitDataList = [[responseObject objectForKey:@"object"] mutableCopy];
            [self.waitTableView reloadData];
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            //[self reloadDataWith:[[responseObject objectForKey:@"object"] objectAtIndex:0]];
        } else {
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    [[HttpMethods Instance] activityIndicate:NO
                                                  tipContent:[responseObject objectForKey:@"msg"]
                                               MBProgressHUD:nil
                                                      target:self.navigationController.view
                                             displayInterval:3];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
            } else {
                
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
            }
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}


-(void)requestshipMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    
    NSDictionary *parameters = @{@"sbjg":@"8"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryTodayEntrust] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            shipDataList = [[responseObject objectForKey:@"object"] mutableCopy];
            [self.shipTableView reloadData];
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            //[self reloadDataWith:[[responseObject objectForKey:@"object"] objectAtIndex:0]];
        } else {
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    [[HttpMethods Instance] activityIndicate:NO
                                                  tipContent:[responseObject objectForKey:@"msg"]
                                               MBProgressHUD:nil
                                                      target:self.navigationController.view
                                             displayInterval:3];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
            } else {
                
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
            }
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TTABLEVIEW) {
        if ([dataList count] == 0) {
            return 1;
        } else if (hasMore) {
            return [dataList count] + 1;
        } else {
            return [dataList count];
        }
    } else if(tableView.tag == WAITTABLEVIEW){
        if ([waitDataList count] == 0) {
            return 1;
        } else if (waitHasMore) {
            return [waitDataList count] + 1;
        } else {
            return [waitDataList count];
        }
    } else if(tableView.tag == SHIPTABLEVIEW){
        if ([shipDataList count] == 0) {
            return 1;
        } else if (shipHasMore) {
            return [shipDataList count] + 1;
        } else {
            return [shipDataList count];
        }
    } else {
        if ([finishDataList count] == 0) {
            return 1;
        } else if (finishHasMore) {
            return [finishDataList count] + 1;
        } else {
            return [finishDataList count];
        }
    }
    
}

- (NSString *)AddComma:(NSString *)string{//添加逗号
    
    NSString *str=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    
    int numl=(int)[str length];
    NSLog(@"%d",numl);
    
    if (numl>3&&numl<7) {
        return [NSString stringWithFormat:@"%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else if (numl>6){
        return [NSString stringWithFormat:@"%@,%@,%@",
                [str substringWithRange:NSMakeRange(0,numl-6)],
                [str substringWithRange:NSMakeRange(numl-6,3)],
                [str substringWithRange:NSMakeRange(numl-3,3)]];
    }else{
        return str;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    if (tbleView.tag == TTABLEVIEW) {
        if ([dataList count] == 0) {
            if (YES) {
                
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tbleView.frame.size.height)];
                [cellBackView setBackgroundColor:[ConMethods colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 57, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ConMethods colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有记录哦~"];
                [cellBackView addSubview:tipLabel];
                [cell.contentView addSubview:cellBackView];
            }
        } else {
            
            if ([indexPath row] == [dataList count]) {
                moreCell = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
                moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [moreCell setBackgroundColor:[UIColor clearColor]];
                moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [moreCell.contentView addSubview:toastLabel];
               // return moreCell;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    UIView *backView;
                    
                    if ([indexPath row] == 0) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                    } else {
                    
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                       backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 120)];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
                    //添加背景View
                    
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 14)];
                    brandLabel.font = [UIFont systemFontOfSize:14];
                    [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQMC"];
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, 60, 14)];
                    delegateLabel.font = [UIFont systemFontOfSize:14];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                   // delegateLabel.textAlignment = NSTextAlignmentRight;
                    delegateLabel.text = @"申请类型";
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 31, ScreenWidth - 120 - 70, 14)];
                    yuqiLabel.font = [UIFont systemFontOfSize:14];
                    [yuqiLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    yuqiLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_LBMC"];
                    [backView addSubview:yuqiLabel];
                    //申报结果
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 60, 14)];
                    yuqiLabelTip.font = [UIFont systemFontOfSize:14];
                    [yuqiLabelTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"申报结果";
                    [backView addSubview:yuqiLabelTip];
                    
                    UILabel *shenbaoTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 52, ScreenWidth - 120 - 70, 14)];
                    shenbaoTip.font = [UIFont systemFontOfSize:14];
                    [shenbaoTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    shenbaoTip.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_JGSM"];
                    [backView addSubview:shenbaoTip];
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 73, 60, 14)];
                    giveLabel.font = [UIFont systemFontOfSize:14];
                    [giveLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    //giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"成交金额";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:14];
                    [giveLabelTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSL"] doubleValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    giveLabelTip.frame = CGRectMake(70, 73, titleSize1.width, 14);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 73, 14, 14)];
                    flagLabel1.font = [UIFont systemFontOfSize:14];
                    [flagLabel1 setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    //flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    

                    
                    
                    //委托金额
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 14)];
                    valueLabel.font = [UIFont systemFontOfSize:14];
                    [valueLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                   // valueLabel.textAlignment = NSTextAlignmentRight;
                    valueLabel.text = @"委托金额";
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont systemFontOfSize:14];
                    [valueLabelTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                    
                    
                    
                    NSString *abc; 
                      abc = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] integerValue]];
                    /*
                    if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]) {
                         abc = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] integerValue]];
                    } else  {
                    
                        abc = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] doubleValue]];
                    }
                    */
                   
                    
                    NSRange range1 = [abc rangeOfString:@"."];//匹配得到的下标
                    
                    NSLog(@"rang:%@",NSStringFromRange(range1));
                    
                    //string = [string substringWithRange:range];//截取范围类的字符串
                    
                    
                    
                    NSString *string = [abc substringFromIndex:range1.location];
                    
                    NSString *str = [abc substringToIndex:range1.location];
                    
                    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    
                    
                    
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    valueLabelTip.frame = CGRectMake(70, 94, titleSize.width, 14);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 94, 14, 14)];
                    flagLabel.font = [UIFont systemFontOfSize:14];
                    [flagLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    
                   
                    
                    if ((![[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]&&[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_SBJG"] isEqualToString:@"2"]) || (![[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]&&[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_SBJG"] isEqualToString:@"5"])) {
                        //投资按钮
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(ScreenWidth - 20 - 80, 50, 80, 30);
                        button.tag = [indexPath row];
                        button.backgroundColor = [UIColor orangeColor];
                        [button setTitle:@"撤单" forState:UIControlStateNormal];
                        button.layer.cornerRadius = 3;
                        button.titleLabel.font = [UIFont systemFontOfSize:15];
                        [button addTarget:self action:@selector(touziBtn:) forControlEvents:UIControlEventTouchUpInside];
                        button.backgroundColor = [ConMethods colorWithHexString:@"087dcd"];
                        button.layer.cornerRadius = 4;
                        button.layer.masksToBounds = YES;
                       
                         [backView addSubview:button];
                    }
                    
                   
                    
                    
                    [cell.contentView addSubview:backView];
                }
            }
        }
        return cell;
    } else if (tbleView.tag == TFINISHTABLEVIEW) {
        if ([finishDataList count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tbleView.frame.size.height)];
                [cellBackView setBackgroundColor:[ConMethods colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 57, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ConMethods colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有成交记录哦~"];
                [cellBackView addSubview:tipLabel];
                [cell.contentView addSubview:cellBackView];
            }
        } else {
            if ([indexPath row] == [finishDataList count]) {
                finishMoreCell = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
                finishMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [finishMoreCell setBackgroundColor:[UIColor clearColor]];
                finishMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [finishMoreCell.contentView addSubview:toastLabel];
                return finishMoreCell;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    
                    UIView *backView;
                    
                    if ([indexPath row] == 0) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                    } else {
                        
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                         backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 120)];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
                    //添加背景View
                   
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 14)];
                    brandLabel.font = [UIFont systemFontOfSize:14];
                    [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQMC"];
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, 60, 14)];
                    delegateLabel.font = [UIFont systemFontOfSize:14];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    // delegateLabel.textAlignment = NSTextAlignmentRight;
                    delegateLabel.text = @"申请类型";
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 31, ScreenWidth - 120 - 70, 14)];
                    yuqiLabel.font = [UIFont systemFontOfSize:14];
                    [yuqiLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    yuqiLabel.text = [[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_LBMC"];
                    [backView addSubview:yuqiLabel];
                    //申报结果
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 60, 14)];
                    yuqiLabelTip.font = [UIFont systemFontOfSize:14];
                    [yuqiLabelTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"申报结果";
                    [backView addSubview:yuqiLabelTip];
                    
                    UILabel *shenbaoTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 52, ScreenWidth - 120 - 70, 14)];
                    shenbaoTip.font = [UIFont systemFontOfSize:14];
                    [shenbaoTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    shenbaoTip.text = [[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_JGSM"];
                    [backView addSubview:shenbaoTip];
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 73, 60, 14)];
                    giveLabel.font = [UIFont systemFontOfSize:14];
                    [giveLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    //giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"成交金额";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:14];
                    [giveLabelTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    
                    
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSL"] doubleValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    giveLabelTip.frame = CGRectMake(70, 73, titleSize1.width, 14);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 73, 14, 14)];
                    flagLabel1.font = [UIFont systemFontOfSize:14];
                    [flagLabel1 setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    //flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    
                    
                    
                    
                    //委托金额
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 14)];
                    valueLabel.font = [UIFont systemFontOfSize:14];
                    [valueLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    // valueLabel.textAlignment = NSTextAlignmentRight;
                    valueLabel.text = @"委托金额";
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont systemFontOfSize:14];
                    [valueLabelTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                    NSString *abc  = [NSString stringWithFormat:@"%.2f",[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] doubleValue]];
                    /*
                    NSString *abc;
                    
                    if ([[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]) {
                        abc = [NSString stringWithFormat:@"%.2f",[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] integerValue]];
                    } else  {
                        
                        abc = [NSString stringWithFormat:@"%.2f",[[[finishDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] doubleValue]];
                    }
                    */

                    
                    
                    NSRange range1 = [abc rangeOfString:@"."];//匹配得到的下标
                    
                    NSLog(@"rang:%@",NSStringFromRange(range1));
                    
                    //string = [string substringWithRange:range];//截取范围类的字符串
                    
                    
                    
                    NSString *string = [abc substringFromIndex:range1.location];
                    
                    NSString *str = [abc substringToIndex:range1.location];
                    
                    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    
                    
                    
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    valueLabelTip.frame = CGRectMake(70, 94, titleSize.width, 14);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 94, 14, 14)];
                    flagLabel.font = [UIFont systemFontOfSize:14];
                    [flagLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    [cell.contentView addSubview:backView];
                }
            }
        }
        return cell;
    } else if (tbleView.tag == WAITTABLEVIEW) {
        if ([waitDataList count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tbleView.frame.size.height)];
                [cellBackView setBackgroundColor:[ConMethods colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 57, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ConMethods colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有申报记录哦~"];
                [cellBackView addSubview:tipLabel];
                [cell.contentView addSubview:cellBackView];
            }
        } else {
            if ([indexPath row] == [waitDataList count]) {
                waitMoreCell = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
                waitMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [waitMoreCell setBackgroundColor:[UIColor clearColor]];
                waitMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [waitMoreCell.contentView addSubview:toastLabel];
                return waitMoreCell;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    
                    UIView *backView;
                    
                    if ([indexPath row] == 0) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                    } else {
                        
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 120)];
                    }
                    
                    
                   // cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
                    //添加背景View
                   // UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 120)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 14)];
                    brandLabel.font = [UIFont systemFontOfSize:14];
                    [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQMC"];
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, 60, 14)];
                    delegateLabel.font = [UIFont systemFontOfSize:14];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    // delegateLabel.textAlignment = NSTextAlignmentRight;
                    delegateLabel.text = @"申请类型";
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 31, ScreenWidth - 120 - 70, 14)];
                    yuqiLabel.font = [UIFont systemFontOfSize:14];
                    [yuqiLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    yuqiLabel.text = [[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_LBMC"];
                    [backView addSubview:yuqiLabel];
                    //申报结果
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 60, 14)];
                    yuqiLabelTip.font = [UIFont systemFontOfSize:14];
                    [yuqiLabelTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"申报结果";
                    [backView addSubview:yuqiLabelTip];
                    
                    UILabel *shenbaoTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 52, ScreenWidth - 120 - 70, 14)];
                    shenbaoTip.font = [UIFont systemFontOfSize:14];
                    [shenbaoTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    shenbaoTip.text = [[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_JGSM"];
                    [backView addSubview:shenbaoTip];
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 73, 60, 14)];
                    giveLabel.font = [UIFont systemFontOfSize:14];
                    [giveLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    //giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"成交金额";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:14];
                    [giveLabelTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSL"] doubleValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    giveLabelTip.frame = CGRectMake(70, 73, titleSize1.width, 14);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 73, 14, 14)];
                    flagLabel1.font = [UIFont systemFontOfSize:14];
                    [flagLabel1 setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    //flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    
                    
                    
                    
                    //委托金额
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 14)];
                    valueLabel.font = [UIFont systemFontOfSize:14];
                    [valueLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    // valueLabel.textAlignment = NSTextAlignmentRight;
                    valueLabel.text = @"委托金额";
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont systemFontOfSize:14];
                    [valueLabelTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                    NSString *abc  = [NSString stringWithFormat:@"%.2f",[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] doubleValue]];
                    /*
                    NSString *abc;
                    
                    if ([[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]) {
                        abc = [NSString stringWithFormat:@"%.2f",[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] integerValue]];
                    } else  {
                        
                        abc = [NSString stringWithFormat:@"%.2f",[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] doubleValue]];
                    }
                    */

                    
                    NSRange range1 = [abc rangeOfString:@"."];//匹配得到的下标
                    
                    NSLog(@"rang:%@",NSStringFromRange(range1));
                    
                    //string = [string substringWithRange:range];//截取范围类的字符串
                    
                    
                    
                    NSString *string = [abc substringFromIndex:range1.location];
                    
                    NSString *str = [abc substringToIndex:range1.location];
                    
                    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    
                    
                    
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    valueLabelTip.frame = CGRectMake(70, 94, titleSize.width, 14);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 94, 14, 14)];
                    flagLabel.font = [UIFont systemFontOfSize:14];
                    [flagLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    
                    
                    
                    if ((![[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]&&[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_SBJG"] isEqualToString:@"2"]) || (![[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]&&[[[waitDataList objectAtIndex:indexPath.row] objectForKey:@"FID_SBJG"] isEqualToString:@"5"])) {
                        //投资按钮
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(ScreenWidth - 20 - 80, 50, 80, 30);
                        button.tag = [indexPath row];
                        button.backgroundColor = [UIColor orangeColor];
                        [button setTitle:@"撤单" forState:UIControlStateNormal];
                        button.layer.cornerRadius = 3;
                        button.titleLabel.font = [UIFont systemFontOfSize:15];
                        [button addTarget:self action:@selector(touziBtn1:) forControlEvents:UIControlEventTouchUpInside];
                        button.backgroundColor = [ConMethods colorWithHexString:@"087dcd"];
                        button.layer.cornerRadius = 4;
                        button.layer.masksToBounds = YES;
                        
                        [backView addSubview:button];
                    }
                    
                    
                    
                    
                    [cell.contentView addSubview:backView];
                }
            }
        }
        return cell;
    } else if (tbleView.tag == SHIPTABLEVIEW) {
        if ([shipDataList count] == 0) {
            if (YES) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tbleView.frame.size.height)];
                [cellBackView setBackgroundColor:[ConMethods colorWithHexString:@"ececec"]];
                //图标
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 57, 57, 57)];
                [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
                [cellBackView addSubview:iconImageView];
                //提示
                UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
                [tipLabel setFont:[UIFont systemFontOfSize:15]];
                [tipLabel setTextAlignment:NSTextAlignmentCenter];
                [tipLabel setTextColor:[ConMethods colorWithHexString:@"404040"]];
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"您还没有撤销记录哦~"];
                [cellBackView addSubview:tipLabel];
                [cell.contentView addSubview:cellBackView];
            }
        } else {
            if ([indexPath row] == [shipDataList count]) {
                shipMoreCell = [tbleView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
                
                shipMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
                [shipMoreCell setBackgroundColor:[UIColor clearColor]];
                shipMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
                [toastLabel setFont:[UIFont systemFontOfSize:12]];
                toastLabel.backgroundColor = [UIColor clearColor];
                [toastLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                toastLabel.numberOfLines = 0;
                toastLabel.text = @"更多...";
                toastLabel.textAlignment = NSTextAlignmentCenter;
                [shipMoreCell.contentView addSubview:toastLabel];
                return shipMoreCell;
            } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    
                    UIView *backView;
                    
                    if ([indexPath row] == 0) {
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
                    } else {
                        
                        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 120)];
                    }
                    
                   // cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
                    //添加背景View
                   // UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 120)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 10 - 30, 14)];
                    brandLabel.font = [UIFont systemFontOfSize:14];
                    [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    brandLabel.text = [[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQMC"];
                    [backView addSubview:brandLabel];
                    //认购发行
                    
                    UILabel *delegateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 31, 60, 14)];
                    delegateLabel.font = [UIFont systemFontOfSize:14];
                    //[delegateLabel setTextColor:[UIColor redColor]];
                    [delegateLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    // delegateLabel.textAlignment = NSTextAlignmentRight;
                    delegateLabel.text = @"申请类型";
                    [backView addSubview:delegateLabel];
                    
                    
                    UILabel *yuqiLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 31, ScreenWidth - 120 - 70, 14)];
                    yuqiLabel.font = [UIFont systemFontOfSize:14];
                    [yuqiLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    yuqiLabel.text = [[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_LBMC"];
                    [backView addSubview:yuqiLabel];
                    //申报结果
                    UILabel *yuqiLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 52, 60, 14)];
                    yuqiLabelTip.font = [UIFont systemFontOfSize:14];
                    [yuqiLabelTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    
                    yuqiLabelTip.text = @"申报结果";
                    [backView addSubview:yuqiLabelTip];
                    
                    UILabel *shenbaoTip = [[UILabel alloc] initWithFrame:CGRectMake(70, 52, ScreenWidth - 120 - 70, 14)];
                    shenbaoTip.font = [UIFont systemFontOfSize:14];
                    [shenbaoTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    shenbaoTip.text = [[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_JGSM"];
                    [backView addSubview:shenbaoTip];
                    
                    //转让价格
                    UILabel *giveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 73, 60, 14)];
                    giveLabel.font = [UIFont systemFontOfSize:14];
                    [giveLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    //giveLabel.textAlignment = NSTextAlignmentRight;
                    giveLabel.text = @"成交金额";
                    [backView addSubview:giveLabel];
                    
                    UILabel *giveLabelTip = [[UILabel alloc] init];
                    giveLabelTip.font = [UIFont systemFontOfSize:14];
                    [giveLabelTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    giveLabelTip.textAlignment = NSTextAlignmentLeft;
                    giveLabelTip.text = [NSString stringWithFormat:@"%.2f",[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSL"] doubleValue]];
                    // [backView addSubview:giveLabelTip];
                    
                    
                    CGSize titleSize1 = [giveLabelTip.text sizeWithFont:giveLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    giveLabelTip.frame = CGRectMake(70, 73, titleSize1.width, 14);
                    // WithFrame:CGRectMake(170, 67, 60, 13)
                    
                    [backView addSubview:giveLabelTip];
                    
                    
                    UILabel *flagLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(giveLabelTip.frame.size.width + giveLabelTip.frame.origin.x, 73, 14, 14)];
                    flagLabel1.font = [UIFont systemFontOfSize:14];
                    [flagLabel1 setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    //flagLabel1.textAlignment = NSTextAlignmentLeft;
                    flagLabel1.text = @"元";
                    [backView addSubview:flagLabel1];
                    
                    
                    
                    
                    //委托金额
                    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 14)];
                    valueLabel.font = [UIFont systemFontOfSize:14];
                    [valueLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    // valueLabel.textAlignment = NSTextAlignmentRight;
                    valueLabel.text = @"委托金额";
                    [backView addSubview:valueLabel];
                    
                    
                    UILabel *valueLabelTip = [[UILabel alloc] init];
                    valueLabelTip.font = [UIFont systemFontOfSize:14];
                    [valueLabelTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    valueLabelTip.textAlignment = NSTextAlignmentLeft;
                    NSString *abc  = [NSString stringWithFormat:@"%.2f",[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] doubleValue]];
                    /*
                    NSString *abc;
                    
                    if ([[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTLB"] isEqualToString:@"15"]) {
                        abc = [NSString stringWithFormat:@"%.2f",[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJG"] doubleValue]*[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSL"] integerValue]];
                    } else  {
                        
                        abc = [NSString stringWithFormat:@"%.2f",[[[shipDataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTJE"] doubleValue]];
                    }
                    */

                    
                    
                    NSRange range1 = [abc rangeOfString:@"."];//匹配得到的下标
                    
                    NSLog(@"rang:%@",NSStringFromRange(range1));
                    
                    //string = [string substringWithRange:range];//截取范围类的字符串
                    
                    
                    
                    NSString *string = [abc substringFromIndex:range1.location];
                    
                    NSString *str = [abc substringToIndex:range1.location];
                    
                    valueLabelTip.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    
                    
                    
                    // 1.获取宽度，获取字符串不折行单行显示时所需要的长度
                    
                    CGSize titleSize = [valueLabelTip.text sizeWithFont:valueLabelTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
                    valueLabelTip.frame = CGRectMake(70, 94, titleSize.width, 14);
                    // WithFrame:CGRectMake(170, 44, 60, 13)
                    
                    [backView addSubview:valueLabelTip];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(valueLabelTip.frame.size.width + valueLabelTip.frame.origin.x, 94, 14, 14)];
                    flagLabel.font = [UIFont systemFontOfSize:14];
                    [flagLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                     [cell.contentView addSubview:backView];
                }
            }
        }
        return cell;
    }
    
    return nil;
}

#pragma mark - Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSInteger row = [indexPath row];
    if (tableView.tag == TTABLEVIEW) {
        if ([dataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [dataList count]) {
                return 40;
            } else {
                if ([indexPath row] == 0) {
                    return 120;
                } else {
                    
                    return 130;
                }

            }
        }
    } else if (tableView.tag == TFINISHTABLEVIEW) {
        if ([finishDataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [finishDataList count]) {
                return 40;
            } else {
                if ([indexPath row] == 0) {
                    return 120;
                } else {
                    
                    return 130;
                }

            }
        }
    } else if (tableView.tag == WAITTABLEVIEW) {
        if ([waitDataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [waitDataList count]) {
                return 40;
            } else {
                if ([indexPath row] == 0) {
                     return 120;
                } else {
                
                return 130;
                }
            }
        }
    } else if (tableView.tag == SHIPTABLEVIEW) {
        if ([shipDataList count] == 0) {
            return tableView.frame.size.height;
        } else {
            if ([indexPath row] == [shipDataList count]) {
                return 40;
            } else {
                if ([indexPath row] == 0) {
                    return 120;
                } else {
                    
                    return 130;
                }

            }
        }
    }
    
    
    return 95 ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        if ([bagFlag isEqualToString:@"1"]) {
            [self requestSelselectMethods:[[dataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTH"] withwtfs:[[dataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTFS"]];
        } else if ([bagFlag isEqualToString:@"2"]){
        [self requestSelselectMethods:[[waitDataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTH"] withwtfs:[[waitDataList objectAtIndex:alertView.tag] objectForKey:@"FID_WTFS"]];
        
        }
        
    }
}





-(void)touziBtn:(UIButton *)btn{
    
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:@"撤单" message:@"是否要进行撤单操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = btn.tag;
    
    [outAlert show];
    
    bagFlag = @"1";
    
    
}

-(void)touziBtn1:(UIButton *)btn{
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:@"撤单" message:@"是否要进行撤单操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = btn.tag;
    
    [outAlert show];
    
    bagFlag = @"2";
    
}


//撤单操作
//请求数据方法
-(void)requestSelselectMethods:(NSString *)str withwtfs:(NSString *)_wtfs {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"wth":str,@"wtfs":_wtfs};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERentrustWithdraw] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            if (dataList.count > 0) {
                [dataList removeAllObjects];
            }
            
            if (waitDataList.count > 0) {
                [waitDataList removeAllObjects];
            }
            
            [self requestMethods];
            
            [self requestWiatMethods];
            
        } else {
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    [[HttpMethods Instance] activityIndicate:NO
                                                  tipContent:[responseObject objectForKey:@"msg"]
                                               MBProgressHUD:nil
                                                      target:self.navigationController.view
                                             displayInterval:3];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
            } else {
                
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
            }
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}




- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
   
   [self.navigationController popViewControllerAnimated:YES];
}
@end
