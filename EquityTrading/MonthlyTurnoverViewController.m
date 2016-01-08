//
//  MonthlyTurnoverViewController.m
//  EquityTrading
//
//  Created by mac on 15/11/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MonthlyTurnoverViewController.h"
#import "AppDelegate.h"

@interface MonthlyTurnoverViewController ()
{
    float addHight;
    UITableView *tableView;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
}
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation MonthlyTurnoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth,  ScreenHeight - 64)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[UIColor clearColor]];    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
    [self setupHeader];
    
    //获取类别信息
    [self requestMyGqzcPaging];
    
}

- (void)setupHeader
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:tableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self requestMyGqzcPaging];
            
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    // [refreshHeader beginRefreshing];
}


#pragma mark - date change Metholds

- (NSString *)dateToStringDate:(NSDate *)Date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //HH:mm:ss zzz
    NSString *destDateString = [dateFormatter stringFromDate:Date];
    // destDateString = [destDateString substringToIndex:10];
    
    return destDateString;
}


#pragma mark - date A months Ago
//给一个时间，给一个数，正数是以后n个月，负数是前n个月；
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month withDay:(int)day

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    [comps setMonth:month];
    [comps setDay:day];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}


-(void)requestMyGqzcPaging{
    
    
    NSDictionary *parameters = @{@"isTodayFlag":@"2",@"ksrq":[self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:-1 withDay:-1]],@"jsrq":[self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:0 withDay:-1]]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERtransactionPageData] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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


#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataList count] == 0) {
        return 1;
    }  else {
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
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
        [backView setBackgroundColor:[ConMethods colorWithHexString:@"ececec"]];
        //图标
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
        [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
        [backView addSubview:iconImageView];
        //提示
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
        [tipLabel setFont:[UIFont systemFontOfSize:15]];
        [tipLabel setTextAlignment:NSTextAlignmentCenter];
        [tipLabel setTextColor:[ConMethods colorWithHexString:@"404040"]];
        [tipLabel setText:@"没有任何记录哦~"];
        tipLabel.backgroundColor = [UIColor clearColor];
        [backView addSubview:tipLabel];
        [cell.contentView addSubview:backView];
        
    } else {
        
        cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 105)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
            //添加背景View
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 95)];
            [backView setBackgroundColor:[UIColor whiteColor]];
            backView.layer.cornerRadius = 2;
            backView.layer.masksToBounds = YES;
            
            //品牌
            UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth - 40, 15)];
            brandLabel.font = [UIFont systemFontOfSize:15];
            [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
            [brandLabel setBackgroundColor:[UIColor clearColor]];
            brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQMC"];
            [backView addSubview:brandLabel];
            
            //持有份额
            UILabel *fenLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, 52, 13)];
            fenLabTip.font = [UIFont systemFontOfSize:13];
            [fenLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
            
            fenLabTip.text = @"成交金额";
            [backView addSubview:fenLabTip];
            
            UILabel *fenLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 42, ScreenWidth/2 - 10 - 65, 13)];
            fenLabel.font = [UIFont systemFontOfSize:13];
            [fenLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
            fenLabel.text = [NSString stringWithFormat:@"%.2f元",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJJE"] doubleValue]];
            [backView addSubview:fenLabel];
            
            //最新价
            UILabel *newLabTip = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2 - 10, 43, 50, 13)];
            newLabTip.font = [UIFont systemFontOfSize:13];
            [newLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
            
            newLabTip.text = @"成交价";
            [backView addSubview:newLabTip];
            
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 55 - 10, 42, ScreenWidth/2 - 20 - 45, 13)];
            newLabel.font = [UIFont systemFontOfSize:13];
            [newLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
            newLabel.text = [NSString stringWithFormat:@"%.2f元",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJJG"] doubleValue]];
            [backView addSubview:newLabel];
            
            //成交数量
            UILabel *kuiLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 63, 52, 13)];
            kuiLabTip.font = [UIFont systemFontOfSize:13];
            [kuiLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
            
            kuiLabTip.text = @"成交数量";
            [backView addSubview:kuiLabTip];
            
            UILabel *kuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 62, ScreenWidth/2 - 75, 13)];
            kuiLabel.font = [UIFont systemFontOfSize:13];
            [kuiLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
            kuiLabel.text = [NSString stringWithFormat:@"%d股",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSL"] intValue]];
            [backView addSubview:kuiLabel];
            //成交日期
            
            UILabel *biliLabTip = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2 - 10, 63, 52, 13)];
            biliLabTip.font = [UIFont systemFontOfSize:13];
            [biliLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
            
            biliLabTip.text = @"成交日期";
            [backView addSubview:biliLabTip];
            
            UILabel *biliLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 10 + 55, 62, ScreenWidth/2 - 20 - 45, 13)];
            biliLabel.font = [UIFont systemFontOfSize:13];
            [biliLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
            
            
            biliLabel.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJSJ"]];
            [backView addSubview:biliLabel];
            [cell.contentView addSubview:backView];
        }
        // return cell;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == [dataList count]) {
        return 40;
    } else {
        return 105;
    }
    return 95;
}




#pragma mark - Recived Methods

//处理品牌列表
- (void)recivedDataList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
    
    if (dataList.count > 0) {
        [dataList removeAllObjects];
    }
    
    
    if(dataList){
        
        [dataList addObjectsFromArray:[dataArray mutableCopy]];
    } else {
        dataList = [dataArray mutableCopy];
    }
    
    
    [tableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
