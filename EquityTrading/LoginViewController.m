//
//  LoginViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-9.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"
#import "MainViewController.h"
#import "MyViewController.h"
#import "MoreViewController.h"
#import "CPVTabViewController.h"


@interface LoginViewController ()
{
    float addHight;
}
@end

@implementation LoginViewController
@synthesize loginStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
  
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
    
    _logoView.frame = CGRectMake((ScreenWidth - 180)/2, 90 + addHight, 180, 85);
    
    
    _loginBtn.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
    _loginBtn.layer.cornerRadius = 4;
    _loginBtn.layer.masksToBounds = YES;
    
    
   // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
   // [self.navigationController setNavigationBarHidden:YES];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 265.5 +  addHight, ScreenWidth - 10, 0.5)];
     lineView.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
   [self.view addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 305.5 +  addHight, ScreenWidth - 10, 0.5)];
     lineView1.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, 345.5 + addHight, ScreenWidth - 10, 0.5)];
    lineView2.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
    [self.view addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 366 + 9.5 + addHight, ScreenWidth, 0.5)];
    lineView3.backgroundColor = [ConMethods  colorWithHexString:@"eeeeee"];
    //[self.view addSubview:lineView3];
    
    
//设置文本框
    _userName.clearButtonMode = UITextFieldViewModeAlways;
    _userName.text = @"";
    //设置密码
    self.password.secureTextEntry = YES;
   // self.password.keyboardType = UIKeyboardTypeNamePhonePad;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    _password.text = @"";
    //设置图形键盘
    
    self.code.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _code.clearButtonMode = UITextFieldViewModeWhileEditing;
    _code.text = @"";
    
    self.password.autocorrectionType = UITextAutocorrectionTypeNo;
    _userName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.code.autocorrectionType = UITextAutocorrectionTypeNo;
    //是否自动纠错
    
    _codeImgve.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestCategoryList)];
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [_codeImgve addGestureRecognizer:singleTap1];
    
    
    _codeImgve.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _codeImgve.layer.cornerRadius = 4;
    _codeImgve.layer.borderWidth = 1;
    _codeImgve.layer.masksToBounds = YES;
    
    
     [self requestCategoryList];
    
    [self readUserInfo]; 
}

#pragma mark - Request Methods

-(void)requestData{
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在登录..." MBProgressHUD:nil target:self.navigationController.view displayInterval:2.0];
    

    /*
     <AFURLRequestSerialization>`
     - `AFHTTPRequestSerializer`
     - `AFJSONRequestSerializer`
     - `AFPropertyListRequestSerializer`
     * `<AFURLResponseSerialization>`
     - `AFHTTPResponseSerializer`
     - `AFJSONResponseSerializer`
     - `AFXMLParserResponseSerializer`
     - `AFXMLDocumentResponseSerializer` _(Mac OS X)_
     - `AFPropertyListResponseSerializer`
     - `AFImageResponseSerializer`
     - `AFCompoundResponseSerializer`
     
     */
    NSString* openUDID = [OpenUDID value];
    
    Base64XD * passwordBase64 = [Base64XD encodeBase64String:self.password.text];
    NSLog(@"%@",passwordBase64.strBase64);
    
     NSDictionary *parameters = @{@"username": self.userName.text,@"password": passwordBase64.strBase64,@"captcha": _code.text, @"mac":openUDID};
    
    
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
     [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERLogin] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         if ([[responseObject objectForKey:@"success"] boolValue]){
             [self saveData];
              NSLog(@"JSON: %@", responseObject);
             [self.navigationController popToRootViewControllerAnimated:YES];
             
             [[HttpMethods Instance] activityIndicate:NO
                                           tipContent:@"登录成功"
                                        MBProgressHUD:nil
                                               target:self.navigationController.view
                                      displayInterval:2];
           
             AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             
             delegate.loginUser = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
             
         } else {
         
         
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:[responseObject objectForKey:@"msg"]
                                   MBProgressHUD:nil
                                          target:self.navigationController.view
                                 displayInterval:3];
        
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
             
         }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:notNetworkConnetTip
                                       MBProgressHUD:nil
                                              target:self.navigationController.view
                                     displayInterval:3];
        
        NSLog(@"Error: %@  %@", error ,operation.responseObject);
    }];
   



}






- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


#pragma mark-文本框代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 76 - (self.view.frame.size.height - 256.0);//键盘高度216
    //动画
    /*
     NSTimeInterval animationDuration = 0.3f;
     [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
     [UIView setAnimationDuration:animationDuration];
     */
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    // stutas = YES;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    // [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    //[[UIApplication sharedApplication]setStatusBarHidden:YES animated:YES];
    [UIView commitAnimations];

    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if (IOS_VERSION_7_OR_ABOVE) {
    //        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    //    }else{
    // [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
     self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    //    }
}




- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}



//获取验证图形
- (void)requestCategoryList
{
   
    /*
     
     NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:kServerAddress]];
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
     [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsCookie];
     
     //设置cookie的代码如下：
     NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie];
     if([cookiesdata length]) {
     NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
     NSHTTPCookie *cookie;
     for (cookie in cookies) {
     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
     }
     }
     */
    //[self.codeImgve setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/captcha",SERVERURL]]];
    
    //NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/captcha",SERVERURL]]];
    
    
   //[self.codeImgve setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/captcha",SERVERURL]]];
    //[self.codeImgve setMultipleTouchEnabled:YES];
    //[self.codeImgve setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/captcha",SERVERURL]]];
    
    
    
    NSURLRequest *reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/captcha",SERVERURL]]];
   // [self.codeImgve  cancelImageRequestOperation];
   
    
    
    
    [ self.codeImgve setImageWithURLRequest:reqest placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        NSLog(@"JSON: %@  %@ %@", request,response,image);
        //self.codeImgve.image = nil;
       
       // self.codeImgve.image =  [UIImage  safeImageWithData:image];;
        
        [self.codeImgve setImage:image];
        
    
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
    
     NSLog(@"JSON: %@  %@ %@", request,response,error);
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even{
    [self.view endEditing:YES];
}




- (IBAction)push:(id)sender {
   // RegesterViewController *controller = [[RegesterViewController alloc] init];
   // controller.modalTransitionStyle = UIModalTransitionStyle;
    
   // [self presentViewController:controller animated:YES completion:nil];
    
    //[self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)loginBtn:(id)sender {
    
    
    
   
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.code resignFirstResponder];
    
    if ([self.userName.text isEqualToString:@""]) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入用户名"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
    } else if ([self.password.text isEqualToString:@""]){
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
    }else if ([self.code.text isEqualToString:@""]){
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入验证码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
    }  else {
        
        if (self.rember.selected == YES) {
            [self saveData];
            //[self.button2 setSelected:NO];
        }else {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [self removeUserInfo];
            [userDefault setBool:self.rember.selected forKey:@"isRemember"];
            [userDefault synchronize];
        }
        
        
        [self requestData];
        
    }
 
}


#pragma mark - rember passWord and username
- (IBAction)remberMetholdBtn:(id)sender {
    if (self.rember.selected == YES) {
        //设置按钮点击事件，是否保存用户信息，点击一次改变它的状态---selected,normal,同时在不同状态显示不同图片
        [self.rember setSelected:NO];
        [self.rember setImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
    }else {
        [self.rember setSelected:YES];
        [self.rember setImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateSelected];
    }

}

- (IBAction)foggoterPW:(id)sender {
    [self.view endEditing:YES];
   
   // ForgetPWDViewController *vc = [[ForgetPWDViewController alloc] init];
   // vc.hidesBottomBarWhenPushed = YES;
   // [self.navigationController pushViewController:vc animated:YES];
    
   // [self.view makeToast:@"该功能还未实现，请先到PC端操作"];
    
}

- (IBAction)quit:(id)sender {
    
    NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    //删除最后一个，也就是自己
    
    UIViewController *vc = [array objectAtIndex:array.count-2];
    if ([vc.nibName isEqualToString:@"MyViewController"]) {
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.tabBarController.selectedIndex = 0;
        delegate.loginStr = @"1";
        
        CPVTabViewController *osTabbarVC = delegate.tabBarController;
        UINavigationController *navVC = [osTabbarVC viewControllers][0];
        [navVC popViewControllerAnimated:NO];
         osTabbarVC.selectedViewController = navVC;
        
        
        
    } else {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.loginStr = @"1";
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
    
    
    // [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}


-(void)saveData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.userName.text forKey:@"name"];
    //[userDefault setObject:self.password.text forKey:@"password"];
    [userDefault setBool:self.rember.selected forKey:@"isRemember"];
    [userDefault synchronize];
    
}

-(void)readUserInfo {
    //读取用户信息，是否保存信息状态和登陆状态
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.userName.text = [userDefault objectForKey:@"name"];
   // self.password.text = [userDefault objectForKey:@"password"];
    BOOL isOpen = [userDefault boolForKey:@"isRemember"];
    
    [self.rember setSelected:isOpen];              //设置与退出时相同的状态
    [self.rember setImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
    [self.rember setImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateSelected];
}

-(void)removeUserInfo {
    //当不保存用户信息时，清除记录
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"name"];
   // [userDefault removeObjectForKey:@"password"];
    [userDefault removeObjectForKey:@"isRemember"];
}

-(void)dealloc {
    _code.delegate = nil;
    [_code removeFromSuperview];
    _code = nil;
    
    _userName.delegate = nil;
    [_userName removeFromSuperview];
    _userName = nil;
    
    
    _password.delegate = nil;
    [_password removeFromSuperview];
    _password = nil;
    
    [_loginBtn removeFromSuperview];
    _loginBtn = nil;
    
    [_logoView removeFromSuperview];
    _logoView = nil;
    loginStr = nil;

}



@end
