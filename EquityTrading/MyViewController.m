//
//  MyViewController.m
//  GuizhouEquityTrading
//
//  Created by mac on 15/10/23.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "MoneyAccountViewController.h"
#import "MoneyInfoViewController.h"
#import "DelegateTodayViewController.h"
#import "DayDealViewController.h"
#import "MonthlyTurnoverViewController.h"
#import "CenterViewController.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "InfoPersonlViewController.h"


@interface MyViewController ()
{
    UITableView *table;
    float addHight;
    NSArray *arrTitle;
    NSArray *arrImg;
    
    UILabel *total;
    UILabel * incomeLab;
    UILabel *accumulatedLab;
    UILabel *nameTitle;
    
}

@end

@implementation MyViewController

-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    [self getUIFirst];

}


-(void)getUIFirst {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.loginUser.count > 0) {
        if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES) {
            
           
            [self requestMethods];
            [self requestUpdateInfoMethods];
                
            
            
            nameTitle.text = [[delegate.loginUser objectForKey:@"object"] objectForKey:@"khxm"];
            
        } else {
            
            LoginViewController *VC = [[LoginViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
        }
        
    } else {
       
        LoginViewController *VC = [[LoginViewController alloc] init];
        
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    
}


//更新个人数据方法
-(void)requestUpdateInfoMethods {
   
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERupdateUserInfo] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
          
          
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.userInfoUpdate = [responseObject objectForKey:@"object"];
            
            
        } else {
            
            
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
            NSMutableArray *arr = [[responseObject objectForKey:@"object"] mutableCopy];
            [self reloadDataWith:[arr objectAtIndex:0]];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.userMoney = [arr objectAtIndex:0];
            
            
            
        } else {
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
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


-(void)reloadDataWith:(NSMutableDictionary *)arraydata {
    
    //总资产
    
    if ([[arraydata objectForKey:@"FID_ZZC"] isEqualToString:@""]||[[arraydata objectForKey:@"FID_ZZC"] isEqualToString:@"0"]) {
        total.text = @"0.00";
    } else {
        NSString *strZzc = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"FID_ZZC"] doubleValue]];
        
        NSRange range1 = [strZzc rangeOfString:@"."];//匹配得到的下标
        
        NSLog(@"rang:%@",NSStringFromRange(range1));
        
        //string = [string substringWithRange:range];//截取范围类的字符串
        
        
        
        NSString *string = [strZzc substringFromIndex:range1.location];
        
        NSString *str = [strZzc substringToIndex:range1.location];
        
        total.text = [NSString stringWithFormat:@"%@%@",[PublicMethod AddComma:str],string];
        
        
    }
    
    //incomeLab.text = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrZsz"] floatValue]];
    
    if ([[arraydata objectForKey:@"FID_KQZJ"] isEqualToString:@"0.0"]) {
        accumulatedLab.text = @"0.00";
    } else {
        
        NSString *strjrZsz = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"FID_KQZJ"] doubleValue]];
        NSRange range3 = [strjrZsz rangeOfString:@"."];//匹配得到的下标
        
        NSLog(@"rang:%@",NSStringFromRange(range3));
        
        //string = [string substringWithRange:range];//截取范围类的字符串
        
        
        
        NSString *string = [strjrZsz substringFromIndex:range3.location];
        
        NSString *str = [strjrZsz substringToIndex:range3.location];
        
        accumulatedLab.text = [NSString stringWithFormat:@"%@%@",[PublicMethod AddComma:str],string];
        
    }
    
    
    //累计收益
    /*
    //accumulatedLab.text = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"FID_DJJE"] floatValue]];
    // accumulatedLab.text =[NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"jrljzsy"] floatValue]];
    */
    if ([[arraydata objectForKey:@"FID_DJJE"] isEqualToString:@"0"]) {
        accumulatedLab.text = @"0.00";
    } else {
        
        NSString *strrljzsy = [NSString stringWithFormat:@"%.2f",[[arraydata objectForKey:@"FID_DJJE"] doubleValue]];
        
        NSRange range = [strrljzsy rangeOfString:@"."];//匹配得到的下标
        
        NSLog(@"rang:%@",NSStringFromRange(range));
        
        //string = [string substringWithRange:range];//截取范围类的字符串
        
        
        
        NSString *string1 = [strrljzsy substringFromIndex:range.location];
        
        NSString *str1 = [strrljzsy substringToIndex:range.location];
     
        incomeLab.text = [NSString stringWithFormat:@"%@%@",[PublicMethod AddComma:str1],string1];
        
    }
}


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

    
    arrTitle = @[@"我的资产",@"当日委托/撤单",@"当月成交记录",@"资金变动查询",@"账户中心"];
    arrImg = @[@"personal_icon_order",@"personal_icon_pocket",@"personal_icon_feedback",@"personal_icon_baicai",@"personal_icon_recommend"];
    
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight, ScreenWidth,ScreenHeight - 69)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    table.bounces = NO;
    
    [self.view addSubview:table];
}


-(void)getMoneyMethods:(UIButton *)btn {

    if (btn.tag == 1001) {
        
        [self requestMethods:@"1"];
        
        
    } else {
    
        [self requestMethods:@"2"];
        
    }

}


//请求数据方法
-(void)requestMethods:(NSString *)str {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERindex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
           
            if ([[[responseObject objectForKey:@"object"] objectForKey:@"isBingingCard"] boolValue]) {
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:@"加载完成"
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
                
                if ([str isEqualToString:@"1"]) {
                    RechargeViewController *vc = [[RechargeViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } else {
                    WithdrawViewController *vc = [[WithdrawViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                
                
                }
                
            } else {
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:@"请先到PC端绑定银行卡"
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
            
            }
            
            
        } else {
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    if (section == 0) {
         count = 3;
    } else if (section == 1) {
        count = 2;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RepairCellIdentifier];
    }
    
    if (indexPath.section == 0) {
       cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[arrImg objectAtIndex:indexPath.row]];
    } else {
    cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row + 3];
    cell.imageView.image = [UIImage imageNamed:[arrImg objectAtIndex:indexPath.row + 3]];
    
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    float count;
    if (section == 0) {
        count = 160;
    } else {
        count = 10;
    }
    return count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
        view.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
       
        nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, ScreenWidth - 100, 17)];
        nameTitle.text = @"我的账户";
        nameTitle.backgroundColor = [UIColor clearColor];
        nameTitle.textAlignment = NSTextAlignmentCenter;
        nameTitle.textColor = [UIColor whiteColor];
        nameTitle.font = [UIFont systemFontOfSize:17];
        [view addSubview:nameTitle];
        
        
        UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        userBtn.frame = CGRectMake(ScreenWidth - 70, 11, 60, 22);
        // [userBtn setBackgroundImage:[UIImage imageNamed:@"my_info"] forState:UIControlStateNormal];
        [userBtn setTitle:@"账户信息" forState:UIControlStateNormal];
        [userBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        userBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [userBtn addTarget:self action:@selector(pushToUserInfoVC) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:userBtn];
        
        
        
        
        
        
        
        
        UILabel *totalTip = [[UILabel alloc] initWithFrame:CGRectMake(20,40 + 10, (ScreenWidth - 20)/2, 14)];
        totalTip.font = [UIFont systemFontOfSize:13];
        //totalTip.textAlignment = NSTextAlignmentCenter;
        totalTip.backgroundColor = [UIColor clearColor];
        totalTip.textColor = [UIColor whiteColor];
        totalTip.text = @"我的总资产(元)";
        [view addSubview:totalTip];
        
        //总资产
        total = [[UILabel alloc] initWithFrame:CGRectMake(10,40 +  32, ScreenWidth - 20, 30)];
        total.textAlignment = NSTextAlignmentCenter;
        total.font = [UIFont boldSystemFontOfSize:30];
        total.backgroundColor = [UIColor clearColor];
        total.textColor = [UIColor whiteColor];
        total.text = @"0.0";
        [view addSubview:total];
        
        UIImageView *tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(10,40 +  79, ScreenWidth - 20, 1)];
        tipImg.image = [UIImage imageNamed:@"hen_line_icon"];
        [view addSubview:tipImg];
        
        
        //今日收益
        accumulatedLab = [[UILabel alloc] initWithFrame:CGRectMake(20,110 + 28, (ScreenWidth - 20)/2, 14)];
        // accumulatedLab.textAlignment = NSTextAlignmentCenter;
        accumulatedLab.font = [UIFont systemFontOfSize:14];
        accumulatedLab.textColor = [UIColor whiteColor];
        accumulatedLab.backgroundColor = [UIColor clearColor];
        accumulatedLab.text = @"0.0";
        [view addSubview:accumulatedLab];
        
        UIImageView *backLineView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 9.5, 1, 30)];
        backLineView.image = [UIImage imageNamed:@"shu_line_icon"];
        [view addSubview:backLineView];
        
        
        
        UILabel *incomeTip = [[UILabel alloc] initWithFrame:CGRectMake(20,110 + 7, (ScreenWidth - 40)/2, 14)];
        incomeTip.font = [UIFont systemFontOfSize:14];
        //incomeTip.textAlignment = NSTextAlignmentCenter;
        incomeTip.textColor = [UIColor whiteColor];
        incomeTip.backgroundColor = [UIColor clearColor];
        incomeTip.text = @"可取资金(元)";
        [view addSubview:incomeTip];
        
        //累计收益
        incomeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 20,110 +  28, (ScreenWidth - 20)/2, 14)];
        //incomeLab.textAlignment = NSTextAlignmentCenter;
        incomeLab.font = [UIFont systemFontOfSize:14];
        incomeLab.textColor = [UIColor whiteColor];
        incomeLab.backgroundColor = [UIColor clearColor];
        incomeLab.text = @"0.0";
        [view addSubview:incomeLab];
        
        UILabel *foodTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 20,110 + 7, (ScreenWidth - 40)/2, 14)];
        foodTip.font = [UIFont systemFontOfSize:14];
        // foodTip.textAlignment = NSTextAlignmentCenter;
        foodTip.textColor = [UIColor whiteColor];
        foodTip.backgroundColor = [UIColor clearColor];
        foodTip.text = @"冻结金额(元)";
        [view addSubview:foodTip];
        
        /*
        //提现
        UIButton *tixianBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        tixianBtn.frame = CGRectMake(ScreenWidth/2,150, ScreenWidth/2, 40);
        
        UIImageView *tipTX = [[UIImageView alloc] initWithFrame:CGRectMake(20,3, 30, 30)];
        tipTX.image = [UIImage imageNamed:@"我的账户_03-02(1)"];
        [tixianBtn addSubview:tipTX];
        
        UILabel *tipTXLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 35, 25/2, 30, 15)];
        tipTXLabel.font = [UIFont systemFontOfSize:15];
        //tipLabel.textAlignment = NSTextAlignmentRight;
        // tipTXLabel.textColor = [UIColor whiteColor];
        tipTXLabel.backgroundColor = [UIColor clearColor];
        tipTXLabel.text =  @"提现";
        [tixianBtn addSubview:tipTXLabel];
        [tixianBtn setBackgroundImage:[UIImage imageNamed:@"head_bg"] forState:UIControlStateNormal];
        tixianBtn.tag = 1001;
        [tixianBtn addTarget:self action:@selector(getMoneyMethods:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:tixianBtn];
        
        
        
        //充值
        UIButton *chongzhiBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        chongzhiBtn.frame = CGRectMake(0,150, ScreenWidth/2, 40);
        UIImageView *tipCZ = [[UIImageView alloc] initWithFrame:CGRectMake(20,4, 30, 30)];
        tipCZ.image = [UIImage imageNamed:@"我的账户_03(2)"];
        [chongzhiBtn addSubview:tipCZ];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 1, 12.5, 1, 15)];
        img.image = [UIImage imageNamed:@"line_iocn"];
        [chongzhiBtn addSubview:img];
        
        UILabel *tipCZLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 35, 25/2, 30, 15)];
        tipCZLabel.font = [UIFont systemFontOfSize:15];
        //tipLabel.textAlignment = NSTextAlignmentRight;
        //tipCZLabel.textColor = [UIColor whiteColor];
        tipCZLabel.text =  @"充值";
        tipCZLabel.backgroundColor = [UIColor clearColor];
        [chongzhiBtn addSubview:tipCZLabel];
        [chongzhiBtn setBackgroundImage:[UIImage imageNamed:@"head_bg"] forState:UIControlStateNormal];
        chongzhiBtn.tag = 1002;
        [chongzhiBtn addTarget:self action:@selector(getMoneyMethods:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:chongzhiBtn];
        */
    }
    return view;

}


-(void)pushToUserInfoVC{
    
    
    InfoPersonlViewController *vc = [[InfoPersonlViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}





- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
      
        if (indexPath.row == 0) {
            MoneyAccountViewController *vc = [[MoneyAccountViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 1){
            DelegateTodayViewController *vc = [[DelegateTodayViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if (indexPath.row == 2) {
            
            MonthlyTurnoverViewController *vc = [[MonthlyTurnoverViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
           
            
        }
    } else if (indexPath.section == 1){
        if (indexPath.row == 0){
            
            MoneyInfoViewController *vc = [[MoneyInfoViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
           
        }else if (indexPath.row == 1){
            CenterViewController *vc = [[CenterViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        } else {
            DayDealViewController *vc = [[DayDealViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }

    }
    
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
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



@end
