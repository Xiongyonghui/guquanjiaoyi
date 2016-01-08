//
//  CenterViewController.m
//  EquityTrading
//
//  Created by mac on 15/11/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "CenterViewController.h"
#import "AppDelegate.h"
#import "ChangeLoginPWViewController.h"
#import "ChangerPassWordViewController.h"

@interface CenterViewController ()
{
    float addHight;
    UITableView *table;
    NSArray *arrTitle;
}
@end

@implementation CenterViewController

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

   // arrTitle = @[@"手机认证",@"登录密码",@"交易密码"];
    arrTitle = @[@"手机认证",@"交易密码"];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth,ScreenHeight - 64)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    table.bounces = NO;
    
    [self.view addSubview:table];
    
    
}

#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RepairCellIdentifier];
    }
    
    cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row];
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}



- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    if (indexPath.row == 1) {
       
        ChangeLoginPWViewController *vc = [[ChangeLoginPWViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else 
     */
     if(indexPath.row == 1){
        ChangerPassWordViewController *vc = [[ChangerPassWordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
