//
//  MoneyInfoViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-12.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MoneyInfoViewController.h"
#import "AppDelegate.h"
#define TSEGSCROLLVIEW 10005
@interface MoneyInfoViewController ()
{
    //当前
    UITableView *tableView;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    float addHight;
   
}

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation MoneyInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    start = @"0";
    limit = @"10";
   
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
   
    
   
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , addHight + 44, ScreenWidth,  ScreenHeight - 64)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[UIColor clearColor]];    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
    
   
    [self requestMyGqzcPaging];
    
    [self setupHeader];
    [self setupFooter];
    
   
    
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
    
    
    NSDictionary *parameters = @{@"ksrq":[self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:-1 withDay:0]],@"jsrq":[self dateToStringDate:[self getPriousorLaterDateFromDate:[NSDate date] withMonth:0 withDay:0]],@"rowcount":limit,@"rowindex":start};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERfundslist] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            [self recivedCategoryList:[responseObject objectForKey:@"object"]];
            
            
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


//处理品牌列表
- (void)recivedCategoryList:(NSMutableArray *)dataArray
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



#pragma mark - date change Metholds

- (NSString *)dateToStringDate:(NSDate *)Date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //HH:mm:ss zzz
    NSString *destDateString = [dateFormatter stringFromDate:Date];
    // destDateString = [destDateString substringToIndex:10];
    
    return destDateString;
}


- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[formatter dateFromString:dateString];
    
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date1 timeIntervalSinceReferenceDate] + 8*3600)];
    return newDate;
}






#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tabView numberOfRowsInSection:(NSInteger)section
{
    
        if ([dataList count] == 0) {
            return 1;
        } else if (hasMore) {
            return [dataList count] + 1;
        } else {
            return [dataList count];
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
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    if (tbleView == tableView) {
        
        if ([dataList count] == 0) {
            
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
            [backView setBackgroundColor:[ConMethods colorWithHexString:@"ececec"]];
            //图标
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
            [iconImageView setImage:[UIImage imageNamed:@"none_charger_icon"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:15]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ConMethods colorWithHexString:@"404040"]];
            tipLabel.backgroundColor = [UIColor clearColor];
            [tipLabel setText:@"您还没有相关记录哦~"];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
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
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor clearColor]];
                    //添加背景View
                    
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 100)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    //业务类别
                    UILabel *classLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,65 , 15)];
                    
                    
                        classLabTip.text = @"资金变动";
                   
                    
                    classLabTip.font = [UIFont systemFontOfSize:15];
                    classLabTip.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:classLabTip];
                    
                    
                    //发生余额(元)
                    UILabel *remainLab = [[UILabel alloc] init];
                   // NSString *adc;
                    
                    if (![[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_SRJE"] floatValue] <= 0) {
                        remainLab.textColor = [ConMethods colorWithHexString:@"fe8103"];
                        remainLab.text = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_SRJE"]  floatValue]];
                        
                    } else{
                        remainLab.text = [NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_FCJE"]  floatValue]];
                        remainLab.textColor = [ConMethods colorWithHexString:@"047f47"];
                    }

                    
                    /*
                    NSRange range1 = [adc rangeOfString:@"."];//匹配得到的下标
                    
                    NSString *string = [adc substringFromIndex:range1.location];
                    
                    NSString *str = [adc substringToIndex:range1.location];
                    
                    remainLab.text = [NSString stringWithFormat:@"%@%@",[self AddComma:str],string];
                    */
                    remainLab.font = [UIFont systemFontOfSize:15];
                    
                    
                    
                    CGSize titleSize = [remainLab.text sizeWithFont:remainLab.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
                    remainLab.frame = CGRectMake(75, 10,titleSize.width, 15);
                    [backView addSubview:remainLab];
                    
                    
                    UILabel *flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(remainLab.frame.size.width + remainLab.frame.origin.x, 10, 15, 15)];
                    flagLabel.font = [UIFont systemFontOfSize:15];
                    [flagLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    flagLabel.textAlignment = NSTextAlignmentLeft;
                    flagLabel.text = @"元";
                    [backView addSubview:flagLabel];
                    
                    
                    //资金余额(元)
                    
                    UILabel *reLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10 , 32,65 , 15)];
                    reLabTip.text = @"资金余额";
                    reLabTip.font = [UIFont systemFontOfSize:15];
                    reLabTip.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:reLabTip];
                    
                    
                    
                    UILabel *reLab = [[UILabel alloc] initWithFrame:CGRectMake( 75, 32,ScreenWidth - 75 , 15)];
                    /*
                    if ([[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] floatValue] > 0) {
                        
                        
                        NSRange range = [[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] rangeOfString:@"."];//匹配得到的下标
                        
                        NSLog(@"rang:%@",NSStringFromRange(range));
                        
                        //string = [string substringWithRange:range];//截取范围类的字符串
                        
                        
                        
                        NSString *string1 = [[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] substringFromIndex:range.location];
                        
                        NSString *str1 = [[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] substringToIndex:range.location];
                        
                        reLab.text = [NSString stringWithFormat:@"%@%@元",[self AddComma:str1],string1];
                        
                    } else {
                        reLab.text = @"0.00元";
                    }
                    */
                    
                    reLab.text =[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_BCZJYE"] doubleValue]];
                    reLab.font = [UIFont systemFontOfSize:15];
                    reLab.textColor = [ConMethods colorWithHexString:@"333333"];
                    [backView addSubview:reLab];
                    
                    // 处理结果
                    UILabel *endLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 54,65 , 15)];
                    endLabTip.text = @"处理摘要";
                    endLabTip.font = [UIFont systemFontOfSize:15];
                    endLabTip.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:endLabTip];
                    
                    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 54,ScreenWidth - 85 , 15)];
                    endLab.text =[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_ZY"];
                    endLab.font = [UIFont systemFontOfSize:13];
                    endLab.textColor = [ConMethods colorWithHexString:@"333333"];
                    [backView addSubview:endLab];
                    
                    
                    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 76,ScreenWidth - 20 , 14)];
                    //日期格式转化
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_RQ"]];
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                    [strDate insertString:@"-" atIndex:4];
                    [strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    dateLab.text = [NSString stringWithFormat:@"%@  %@",strDate,[[dataList objectAtIndex:[indexPath row]] objectForKey:@"FID_FSSJ"]];
                    dateLab.font = [UIFont systemFontOfSize:14];
                    dateLab.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:dateLab];
                    
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 1)];
                    [subView setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
                    if ([indexPath row] != 0) {
                        [backView addSubview:subView];
                    }
                    
                    
                    [cell.contentView addSubview:backView];
                    
                }
            }
        }
        return cell;
    }
    return nil;
}

-(NSString *)getClassMethod:(NSString *)str {
    NSString *string;
    if ([str isEqualToString:@"1"]) {
        string = @"入金";
    } else if ([str isEqualToString:@"2"]){
        string = @"出金";
    } else if ([str isEqualToString:@"4"]){
        string = @"查询";
    } else if ([str isEqualToString:@"8"]){
        string = @" 开户";
    }else if ([str isEqualToString:@"16"]){
        string = @"销户";
    }
    return string;
}

-(NSString *)getEndMethod:(NSString *)str {
    NSString *string;
    if ([str isEqualToString:@"0"]) {
        string = @"待处理";
    } else if ([str isEqualToString:@"1"]){
        string = @"正在处理";
    } else if ([str isEqualToString:@"-812"]){
        string = @"交易状态查询返回结果为处理中";
    } else if ([str isEqualToString:@"111"]){
        string = @" 交易成功";
    }
    return string;
    
}




-(CGFloat)tableView:(UITableView *)tabView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tabView == tableView) {
        if ([indexPath row] == [dataList count]) {
            return 40;
        } else {
            return 100;
        }
        
    } 
    return 95;
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
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    
   [self.navigationController popViewControllerAnimated:YES];
}
@end
