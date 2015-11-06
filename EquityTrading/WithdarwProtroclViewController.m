//
//  WithdarwProtroclViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-3-23.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "WithdarwProtroclViewController.h"
#import "AppDelegate.h"

@interface WithdarwProtroclViewController ()

@end

@implementation WithdarwProtroclViewController

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
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
    //添加指示器及遮罩
   
     [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/zjgl/transAccount/fwxy",SERVERURL]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [_webView loadRequest:request];
       
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
     //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[HttpMethods Instance] activityIndicate:NO
                                  tipContent:@"加载完成"
                               MBProgressHUD:nil
                                      target:self.view
                             displayInterval:3];
    
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[HttpMethods Instance] activityIndicate:NO
                                  tipContent:@"加载失败"
                               MBProgressHUD:nil
                                      target:self.view
                             displayInterval:3];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (IBAction)back:(id)sender {
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _webView = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
    // webView 的缓存处理
    
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _webView = nil;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


@end
