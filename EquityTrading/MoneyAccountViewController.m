//
//  MoneyAccountViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MoneyAccountViewController.h"
#import "AppDelegate.h"
#import "MyTransferDetailViewController.h"
#import "LoginViewController.h"



@interface MoneyAccountViewController ()
{
   
    UITableView *tableView;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    float addHight;
     UISegmentedControl  *segmented;
    
    NSString *isRefresh;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@end

@implementation MoneyAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) segmentAction:(UISegmentedControl *)Seg{
    
    
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %li",(long)Index);
    
    __weak typeof(self) weakSelf = self;
    
    if (Seg.selectedSegmentIndex == 0) {
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
    } else if(Seg.selectedSegmentIndex == 1){
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
         start = @"1";
        [self requestMyGqzcPaging];
        
        
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    start = @"1";
    limit = @"10";
    
    isRefresh = @"";
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"我的资产",@"我的投资产品",nil];
    segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    
    segmented.frame = CGRectMake(10, addHight + 54 , ScreenWidth - 20, 30);
    
    segmented.selectedSegmentIndex = 0;//设置默认选择项索引
    segmented.backgroundColor = [UIColor whiteColor];
    segmented.tintColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    
    segmented.multipleTouchEnabled = NO;
    segmented.segmentedControlStyle = UISegmentedControlStyleBezeled;
    
    [segmented addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmented];
    
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 50;
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44 + addHight + 50, ScreenWidth, scrollViewHeight)];
    //self.scrollView.tag = TSEGSCROLLVIEW;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*2, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 44 + addHight, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    //view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, scrollViewHeight)];
    //[self setApperanceForLabel:label1];
   
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth , 0, ScreenWidth,  scrollViewHeight)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[UIColor clearColor]];    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:tableView];
    [self setupHeader];
    [self setupFooter];
    
  
        //获取类别信息
        [self requestMethods];
        
       // [self requestMoney:start withSize:limit tag:kBusinessTagGetJRmyJrzcPaging];
    
  
 }

- (void)setupHeader
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            start = @"1";
            
            [self requestMyGqzcPaging];
            
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    // [refreshHeader beginRefreshing];
}



- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    
    
    if (hasMore == NO) {
        [self.refreshFooter endRefreshing];
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self requestMyGqzcPaging];
            [self.refreshFooter endRefreshing];
        });
    }
}


-(void)requestMyGqzcPaging{
    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{@"pageIndex":start,@"pageSize":limit};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERmyGqzcPaging] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            [self recivedDataList:[responseObject objectForKey:@"object"]];
            
            
        } else {
            
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    
                    [[HttpMethods Instance] activityIndicate:NO
                                                  tipContent:[responseObject objectForKey:@"msg"]
                                               MBProgressHUD:nil
                                                      target:self.navigationController.view
                                             displayInterval:3];
                    
                    
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    LoginViewController *vc = [[LoginViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
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




//请求数据方法
-(void)requestMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryZjzh] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self reloadDataWith:[[responseObject objectForKey:@"object"] objectAtIndex:0]];
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
    if ([dataList count] == 0) {
        return 1;
    } else if (hasMore) {
        return [dataList count] + 1;
    } else {
        return [dataList count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    if ([dataList count] == 0) {
        if (YES) {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
            [backView setBackgroundColor:[ConMethods colorWithHexString:@"ececec"]];
            //图标
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
            [iconImageView setImage:[UIImage imageNamed:@"none_product_icon"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:15]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ConMethods colorWithHexString:@"404040"]];
            [tipLabel setText:@"亲，还未有投资产品"];
            tipLabel.backgroundColor = [UIColor clearColor];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
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
            return moreCell;
        } else {
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor clearColor]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 120)];
                [backView setBackgroundColor:[ConMethods colorWithHexString:@"fdfdfd"]];
               
                
                
                //品牌
                
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth - 20, 25)];
                brandLabel.font = [UIFont systemFontOfSize:15];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_CPMC"];
                [backView addSubview:brandLabel];
                
                
                UILabel *numYQH = [[UILabel alloc] init];
                numYQH.text = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GZLL"] floatValue]*100];
                numYQH.font = [UIFont systemFontOfSize:25];
                numYQH.textColor = [ConMethods colorWithHexString:@"fe8103"];
                CGSize titleSize = [numYQH.text sizeWithFont:numYQH.font constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
                numYQH.frame = CGRectMake(10, 35, titleSize.width, 25);
                [backView addSubview:numYQH];
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.width, 60 - 13, 15, 13)];
                lab.text = @"%";
                lab.textColor = [ConMethods colorWithHexString:@"fe8103"];
                lab.font = [UIFont systemFontOfSize:13];
                [backView addSubview:lab];
                
 //投资金额
                UILabel *labMoney = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 60, 14)];
                labMoney.text = @"投资金额";
                labMoney.textColor = [ConMethods colorWithHexString:@"999999"];
                labMoney.font = [UIFont systemFontOfSize:14];
                [backView addSubview:labMoney];
                
                
                UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 70, ScreenWidth/2 - 20, 14)];
                moneyLabel.font = [UIFont systemFontOfSize:14];
                [moneyLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [moneyLabel setBackgroundColor:[UIColor clearColor]];
                //moneyLabel.textAlignment = NSTextAlignmentRight;
               // moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[[self AddComma:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_TZJE"]] floatValue]];
                moneyLabel.text = [NSString stringWithFormat:@"%@元",[PublicMethod AddComma:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_TZJE"]]];
                [backView addSubview:moneyLabel];
                
                
                if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"sell"] isEqualToString:@"can"]) {
                    
                    if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_KMCSL"] integerValue] > 0 ) {
                        
                        if (![[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GQLB"] isEqualToString:@"Z9"]) {
                            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 90, 30, 80, 30)];
                            lab.backgroundColor = [ConMethods colorWithHexString:@"fe8103"];
                            lab.font = [UIFont systemFontOfSize:14];
                            //lab.layer.borderWidth = 1;
                            
                            lab.layer.masksToBounds = YES;
                            lab.layer.cornerRadius = 4;
                            lab.text = @"转让";
                            lab.textColor = [UIColor whiteColor];
                            lab.textAlignment = NSTextAlignmentCenter;
                            [backView addSubview:lab];
                            
                            
                        } else {
                        
                            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 30, 70, 30)];
                            lab.backgroundColor = [UIColor grayColor];
                            lab.font = [UIFont systemFontOfSize:14];
                            //lab.layer.borderWidth = 1;
                            lab.textColor = [UIColor whiteColor];
                            lab.layer.masksToBounds = YES;
                            
                            lab.layer.cornerRadius = 4;
                            lab.text = @"转让";
                            lab.textAlignment = NSTextAlignmentCenter;
                            [backView addSubview:lab];
                        }
                        
                    } else {
                    
                    
                    
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 90, 30, 80, 30)];
                    lab.backgroundColor = [ConMethods colorWithHexString:@"fe8103"];
                    lab.font = [UIFont systemFontOfSize:14];
                    //lab.layer.borderWidth = 1;
                    
                    lab.layer.masksToBounds = YES;
                    lab.layer.cornerRadius = 4;
                    lab.text = @"转让";
                    lab.textColor = [UIColor whiteColor];
                     lab.textAlignment = NSTextAlignmentCenter;
                    [backView addSubview:lab];
                    }
                } else {
                
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 30, 70, 30)];
                    lab.backgroundColor = [UIColor grayColor];
                    lab.font = [UIFont systemFontOfSize:14];
                    //lab.layer.borderWidth = 1;
                     lab.textColor = [UIColor whiteColor];
                    lab.layer.masksToBounds = YES;
                    
                    lab.layer.cornerRadius = 4;
                    lab.text = @"转让";
                    lab.textAlignment = NSTextAlignmentCenter;
                     [backView addSubview:lab];
                }
                
                
                
          //付息方式
                UILabel *moneyLabelTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 70, ScreenWidth/2 - 10, 14)];
                moneyLabelTip.font = [UIFont systemFontOfSize:14];
                [moneyLabelTip setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [moneyLabelTip setBackgroundColor:[UIColor clearColor]];
                moneyLabelTip.textAlignment = NSTextAlignmentRight;
                moneyLabelTip.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_JXFS"];
                [backView addSubview:moneyLabelTip];
                
                
                //到期日期
                
                UILabel *lab2Tip = [[UILabel alloc] initWithFrame:CGRectMake(10, 94, 60, 13)];
                //lab2Tip.textAlignment = NSTextAlignmentCenter;
                lab2Tip.textColor = [ConMethods colorWithHexString:@"999999"];
                lab2Tip.font = [UIFont systemFontOfSize:14];
                lab2Tip.text = @"到期日期";
                [backView addSubview:lab2Tip];
                
                
                UILabel *labRQ = [[UILabel alloc] initWithFrame:CGRectMake(70, 94, 99, 13)];
                labRQ.textAlignment = NSTextAlignmentCenter;
                labRQ.textColor = [ConMethods colorWithHexString:@"333333"];
                labRQ.font = [UIFont systemFontOfSize:13];
                
                //日期格式转化
                NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_DQRQ"]];
                // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                [strDate insertString:@"-" atIndex:4];
                [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                labRQ.text = [NSString stringWithFormat:@"%@",strDate];
                [backView addSubview:labRQ];

                
                
    //可转让日期
                UILabel *transferTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 95 - 60 - 5, 94, 70, 13)];
                transferTip.textAlignment = NSTextAlignmentCenter;
                transferTip.textColor = [ConMethods colorWithHexString:@"999999"];
                transferTip.font = [UIFont systemFontOfSize:13];
                transferTip.text = @"可转让日期";
                [backView addSubview:transferTip];
                
                
                UILabel *transferRQ = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 90, 94, 85, 13)];
                transferRQ.textAlignment = NSTextAlignmentCenter;
                transferRQ.textColor = [ConMethods colorWithHexString:@"333333"];
                transferRQ.font = [UIFont systemFontOfSize:14];
                
                //日期格式转化
                NSMutableString *strDateTip = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_CPCLRQ"]];
                // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                [strDateTip insertString:@"-" atIndex:4];
                [strDateTip insertString:@"-" atIndex:(strDate.length - 3)];
                transferRQ.text = [NSString stringWithFormat:@"%@",strDateTip];
                [backView addSubview:transferRQ];
                
                
                [cell.contentView addSubview:backView];
                
                
            }
        }
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"sell"] isEqualToString:@"can"]) {
        
             if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_KMCSL"] integerValue] > 0 ) {
                
                 if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_GQLB"] isEqualToString:@"Z9"] == NO) {
                 MyTransferDetailViewController *cv = [[MyTransferDetailViewController alloc] init];
                 
                 cv.gqdm = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQDM"];
                 cv.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:cv animated:YES];
                     
            }
                     
        }
    }
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == [dataList count]) {
        return 40;
    } else {
        return 130;
    }
    return 95;
}





#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scllView {
    //水平滑动的时候就会调用
    if (scllView == _scrollView) {
        CGFloat pageWidth = ScreenWidth;
        NSInteger page = _scrollView.contentOffset.x / pageWidth ;
         segmented.selectedSegmentIndex = page;
        if (page == 1) {
            start = @"1";
            [self requestMyGqzcPaging];
        }
    }
}

-(void)reloadDataWith:(NSMutableDictionary *)arraydata {
    NSArray *titleTip = @[@"总资产(元)",@"股权市值(元)",@"可取资金(元)",@"冻结资金(元)",@"昨日收益(元)",@"累计总收益(元)",@"累计待收益(元)"];
    NSArray *charTip = @[[arraydata objectForKey:@"FID_ZZC"],[arraydata objectForKey:@"FID_KYZJ"],[arraydata objectForKey:@"FID_KQZJ"],[arraydata objectForKey:@"FID_DJJE"],[arraydata objectForKey:@"FID_ZXSZ"],[arraydata objectForKey:@"FID_OFSS_JZ"],[arraydata objectForKey:@"FID_QTZC"]];
    
    for (int i = 0; i < 7;i++) {
        //int hight = addHight + 44 + 50;
        UIView *view;
        if (i < 4) {
            view =  [[UIView alloc] initWithFrame:CGRectMake(0, 40*i, ScreenWidth , 40)];
            
        } else {
            view =  [[UIView alloc] initWithFrame:CGRectMake(0, 40*i + 10, ScreenWidth , 40)];
        }
        view.backgroundColor = [UIColor whiteColor];
       // view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
       // view.layer.borderWidth = 1;
        
       // view.layer.masksToBounds = YES;
        
       // view.layer.cornerRadius = 4;
        
        if (i == 3 ||i == 6) {
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,39.5, ScreenWidth, 0.5)];
            lineView1.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
            [view addSubview:lineView1];
            
        } else {
            if (i == 0 ) {
                UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 0.5)];
                lineView1.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
                [view addSubview:lineView1];
                
                UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10,39.5, ScreenWidth - 10, 0.5)];
                lineView2.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
                [view addSubview:lineView2];
                
            } else {
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10,39.5, ScreenWidth - 10, 0.5)];
            lineView1.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
            [view addSubview:lineView1];
            }
        }
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 , 12.5, 160, 15)];
        lab.text = [titleTip objectAtIndex:i];
        lab.font = [UIFont systemFontOfSize:14];
        
        // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
        
        lab.textColor = [ConMethods colorWithHexString:@"999999"];
        
        lab.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lab];
        
        
        UILabel *labReal = [[UILabel alloc] initWithFrame:CGRectMake(170 , 12.5, ScreenWidth - 170 -10, 15)];
        
        if ([[charTip objectAtIndex:i] doubleValue] > 0) {
            
            NSString *strNum = [NSString stringWithFormat:@"%.2f",[[charTip objectAtIndex:i] doubleValue]];
            
            NSRange range1 = [strNum rangeOfString:@"."];//匹配得到的下标
            
            NSLog(@"rang:%@",NSStringFromRange(range1));
            
            //string = [string substringWithRange:range];//截取范围类的字符串
            
            NSString *string = [strNum substringFromIndex:range1.location];
            
            NSString *str = [strNum substringToIndex:range1.location];
            
            labReal.text = [NSString stringWithFormat:@"%@%@",[PublicMethod AddComma:str],string];
            
        } else {
            
            if (-[[charTip objectAtIndex:i] doubleValue] > 0) {
             
                NSString *strNum = [NSString stringWithFormat:@"%.2f",-[[charTip objectAtIndex:i] doubleValue]];
                
                NSRange range1 = [strNum rangeOfString:@"."];//匹配得到的下标
                
                NSLog(@"rang:%@",NSStringFromRange(range1));
                
                //string = [string substringWithRange:range];//截取范围类的字符串
                
                NSString *string = [strNum substringFromIndex:range1.location];
                
                NSString *str = [strNum substringToIndex:range1.location];
                
                labReal.text = [NSString stringWithFormat:@"-%@%@",[PublicMethod AddComma:str],string];
                
                
            } else {
            
             labReal.text =[NSString stringWithFormat:@"%.2f", [[charTip objectAtIndex:i] doubleValue]];
            }
            
        }
        
        
        
        labReal.font = [UIFont systemFontOfSize:14];
        if (i == 0) {
            labReal.textColor = [ConMethods colorWithHexString:@"fe8103"];
        } else {
        labReal.textColor = [ConMethods colorWithHexString:@"333333"];
        }
        labReal.textAlignment = NSTextAlignmentRight;
        [view addSubview:labReal];
        
        [self.scrollView addSubview:view];
    }
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10 , 300, ScreenWidth - 20, 13)];
    lab.text = @"昨日收益包含昨日到账和未到账收益";
    lab.font = [UIFont systemFontOfSize:13];
    
    // lab.textColor = [ColorUtil colorWithHexString:@"333333"];
    
    lab.textColor = [ConMethods colorWithHexString:@"999999"];
    
    lab.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:lab];
    
    
    //充值
    UIButton *tixianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tixianBtn.frame = CGRectMake(ScreenWidth/4 + 5, 64 + 96 + 80, 70, 30);
    tixianBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    tixianBtn.layer.borderWidth = 1;
    
    tixianBtn.layer.masksToBounds = YES;
    
    tixianBtn.layer.cornerRadius = 15;
    
    [tixianBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    [tixianBtn setTitle:@"充值" forState:UIControlStateNormal];
    //tixianBtn.titleLabel.text = @"充值";
    [tixianBtn addTarget:self action:@selector(moneyMethods:) forControlEvents:UIControlEventTouchUpInside];
    tixianBtn.tag = 1000000;
    tixianBtn.titleLabel.font = [UIFont systemFontOfSize:15];
   // [self.scrollView addSubview:tixianBtn];
    
    //提现
    
    UIButton *chongzhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chongzhiBtn.frame = CGRectMake(ScreenWidth/2 + 5, 64 + 96 + 80, 70, 30);
    chongzhiBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    chongzhiBtn.layer.borderWidth = 1;
    
    chongzhiBtn.layer.masksToBounds = YES;
    
    chongzhiBtn.layer.cornerRadius = 15;
    
    [chongzhiBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    [chongzhiBtn setTitle:@"提现" forState:UIControlStateNormal];
    //chongzhiBtn.titleLabel.text = @"提现";
    
    [chongzhiBtn addTarget:self action:@selector(moneyMethods:) forControlEvents:UIControlEventTouchUpInside];
    chongzhiBtn.tag = 1000001;
    
    chongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
   // [self.scrollView addSubview:chongzhiBtn];
    
}




#pragma mark - Recived Methods
//处理品牌列表
/*
- (void)recivedDataList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    if ([dataList count] > 0) {
        for (NSDictionary *object in dataArray) {
            [dataList addObject:object];
        }
    } else {
        dataList = dataArray;
    }
    if ([dataArray count] < 10) {
        hasMore = NO;
    } else {
        hasMore = YES;
        start = [NSString stringWithFormat:@"%d", [start intValue] + 1];
    }
    [tableView reloadData];
    [_slimeView endRefresh];
}
*/


//处理品牌列表
- (void)recivedDataList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
    if ([start isEqualToString:@"1"]) {
        if (dataList.count > 0) {
            [dataList removeAllObjects];
        }
        
    }
    
    if(dataList){
        
        [dataList addObjectsFromArray:[dataArray mutableCopy]];
    } else {
        dataList = [dataArray mutableCopy];
    }
    
    [tableView reloadData];
    
    if ([dataArray count] < 10) {
        hasMore = NO;
    } else {
        hasMore = YES;
        start = [NSString stringWithFormat:@"%d", [start intValue] + 1];
    }
    
    if (hasMore) {
        if (!_refreshFooter) {
            [self setupFooter];
        }
    } else {
        [_refreshFooter removeFromSuperview];
    }
    
    [tableView reloadData];
    
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
