//
//  MyTransferDetailViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-26.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MyTransferDetailViewController.h"
#import "AppDelegate.h"


@interface MyTransferDetailViewController ()
{
    NSMutableDictionary *firstDic;
    UIView *changeView;
    UITextField *sureText;
    UILabel *wantMoneyLab;
    UITextField *transferText;
    float addHight;
    UILabel *labStarLab;
   UIScrollView *scrollView;
    
    //基准价
    UILabel *jzjPriceLab;
    //上限
    UILabel *sxPriceLab;
    //下限
    UILabel *xxPriceLab;
    //损失
    UILabel *missPriceLab;
    //标价
    UILabel *markPriceLab;
    
    float _defauleBadgeNumber;
    float _lastNumber;
    UIButton *jianBtn;
    UIButton *addBtn;
    UIButton *jianBtnPast;
    UIButton *addBtnPast;
    
}

@end

@implementation MyTransferDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        firstDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth, ScreenHeight - 44 - addHight)];
    
    [self.view addSubview:scrollView];
    
    
    
    
    
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
   // AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   // delegate.isON = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
