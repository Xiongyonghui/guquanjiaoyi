//
//  InfoPersonlViewController.m
//  EquityTrading
//
//  Created by 熊永辉 on 16/1/6.
//  Copyright © 2016年 ApexSoft. All rights reserved.
//

#import "InfoPersonlViewController.h"
#import "AppDelegate.h"

@interface InfoPersonlViewController ()
{
    float addHight;
}
@end

@implementation InfoPersonlViewController

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
    
    [self getData];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _userName.text = [[delegate.loginUser objectForKey:@"object"] objectForKey:@"username"];
    _userId.text = [delegate.userInfoUpdate objectForKey:@"FID_ZJBH"];
    _phoneNum.text = [delegate.userInfoUpdate objectForKey:@"MOBILEPHONE"];
    _userNum.text = [delegate.userInfoUpdate objectForKey:@"KHH"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 39.5, ScreenWidth - 15, 0.5)];
    lineView.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
    [_backView addSubview:lineView];
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 79.5, ScreenWidth - 15, 0.5)];
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
    [_backView addSubview:lineView1];
    
    

}

-(void)getData {

    //获取银行卡信息
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERwdyhk] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]){
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
            [self reloadDataWith:[[responseObject objectForKey:@"object"] objectAtIndex:0]];
            
        } else {
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 12.5, 150, 20)];
            lab.text = @"你还没绑定银行卡";
            lab.textColor = [UIColor blackColor];
            lab.font = [UIFont systemFontOfSize:15];
            [_bankView addSubview:lab];
            
            
            
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

-(void)reloadDataWith:(NSDictionary *)dic {
    if ([[dic objectForKey:@"FID_YHZH"] length] > 0) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 12.5, 100, 20)];
        lab.text = [self bankNmae:[dic objectForKey:@"FID_YHDM"]];
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:15];
        [_bankView addSubview:lab];
        
       
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(115, 12.5, ScreenWidth - 115 - 15, 20)];
        lab1.text = [dic objectForKey:@"FID_YHZH"];
        lab1.textAlignment = NSTextAlignmentRight;
        lab1.textColor = [ConMethods colorWithHexString:@"666666"];
        lab1.font = [UIFont systemFontOfSize:15];
        [_bankView addSubview:lab1];
        
        
        
        
    } else {
    
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 12.5, 150, 20)];
        lab.text = @"你还没绑定银行卡";
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:15];
        [_bankView addSubview:lab];
    
    
    }

}


-(NSString *)bankNmae:(NSString *)str {

    NSString *vauleLabel;
    
    
    if ([str isEqualToString:@"JSYH"]) {
        vauleLabel = @"建设银行";
    }else if ([str isEqualToString:@"JGJS"]) {
        vauleLabel = @"建设银行";
    } else if ([str isEqualToString:@"XYYH"]) {
        
        vauleLabel = @"兴业银行";
        
    } else if ([str isEqualToString:@"ZGYH"]){
        
        vauleLabel = @"中国银行";
    } else if ([str isEqualToString:@"NYYH"]) {
        vauleLabel = @"农业银行";
        
    }else if ([str isEqualToString:@"JGNY"]) {
        vauleLabel = @"农业银行";
        
    } else if ([str isEqualToString:@"GSYH"]) {
        
        vauleLabel = @"工商银行";
    }else if ([str isEqualToString:@"JGGS"]) {
        
        vauleLabel = @"工商银行";
    }else if ([str isEqualToString:@"ZSYH"]) {
        vauleLabel = @"招商银行";
        
    }else if ([str isEqualToString:@"JGZS"]) {
        vauleLabel = @"招商银行";
        
    }else if ([str isEqualToString:@"GDYH"]) {
        vauleLabel = @"光大银行";
        
    }else if ([str isEqualToString:@"JGGD"]) {
        vauleLabel = @"光大银行";
        
    }else if ([str isEqualToString:@"GFYH"]) {
        vauleLabel = @"广发银行";
        
    }else if ([str isEqualToString:@"ZXYH"]) {
        vauleLabel = @"中信银行";
        
    } else if ([str isEqualToString:@"JTYH"]) {
        vauleLabel = @"交通银行";
        
    } else if ([str isEqualToString:@"PFYH"]) {
        vauleLabel = @"浦发银行";
        
    }
    


    return vauleLabel;
}




//请求数据方法
-(void)requestMethods {
   
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERindex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]){
          
            
            
            if ([[[responseObject objectForKey:@"object"] objectForKey:@"isBingingCard"] boolValue]) {
               
                [self getData];
            } else {
               
                
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
