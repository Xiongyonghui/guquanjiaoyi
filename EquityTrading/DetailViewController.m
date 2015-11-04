//
//  DetailViewController.m
//  GuizhouEquityTrading
//
//  Created by mac on 15/10/23.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()
{
    float addHight;
    UITextField *priceLab;
    UITextField *countLab;
    UILabel *buyLab;
    UILabel *moneyLab;
    int count;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     count = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        
        addHight = 0;
    }
    [self requestData:_gqdm];
}


-(void)refreshUI:(NSDictionary *)_dic{
    //股权代码
    UILabel *codeLab = [[UILabel alloc] initWithFrame:CGRectMake(5,70, ScreenWidth/2 - 10, 35)];
    codeLab.font = [UIFont systemFontOfSize:15];
    [codeLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [codeLab setBackgroundColor:[UIColor whiteColor]];
    codeLab.layer.borderWidth = 1;
    codeLab.layer.borderColor = [UIColor greenColor].CGColor;
    // brandLabel.numberOfLines = 0;
    codeLab.text = [_dic objectForKey:@"FID_GQDM"];
    [self.view addSubview:codeLab];
    
    //名称
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(5,70 + 40, ScreenWidth/2 - 10, 35)];
    nameLab.font = [UIFont systemFontOfSize:15];
    [nameLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [nameLab setBackgroundColor:[UIColor whiteColor]];
    nameLab.layer.borderWidth = 1;
    nameLab.layer.borderColor = [UIColor greenColor].CGColor;
    // brandLabel.numberOfLines = 0;
    nameLab.text = [_dic objectForKey:@"FID_GQMC"];
    [self.view addSubview:nameLab];
    
    //委托价格
    priceLab = [[UITextField alloc] initWithFrame:CGRectMake(5,70 + 80, ScreenWidth/2 - 10, 35)];
    priceLab.font = [UIFont systemFontOfSize:15];
    [priceLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [priceLab setBackgroundColor:[UIColor whiteColor]];
    priceLab.placeholder = @"请输入价格";
    priceLab.layer.borderWidth = 1;
    priceLab.layer.borderColor = [UIColor greenColor].CGColor;
    priceLab.delegate = self;
    priceLab.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:priceLab];
    
    //委托数量
    countLab = [[UITextField alloc] initWithFrame:CGRectMake(5,70 + 120, ScreenWidth/2 - 10, 35)];
    countLab.font = [UIFont systemFontOfSize:15];
    [countLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [countLab setBackgroundColor:[UIColor whiteColor]];
    countLab.placeholder = @"请输入数量";
    countLab.layer.borderWidth = 1;
    countLab.layer.borderColor = [UIColor greenColor].CGColor;
    countLab.delegate = self;
     countLab.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:countLab];
    
    //可用资金
    moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(5,70 + 160, ScreenWidth/2 - 10, 35)];
    moneyLab.font = [UIFont systemFontOfSize:15];
    [moneyLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [moneyLab setBackgroundColor:[UIColor whiteColor]];
    moneyLab.layer.borderWidth = 1;
    moneyLab.layer.borderColor = [UIColor greenColor].CGColor;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    moneyLab.text = [delegate.userMoney objectForKey:@"FID_KYZJ"];
    [self.view addSubview:moneyLab];
    //可买数量
    buyLab = [[UILabel alloc] initWithFrame:CGRectMake(5,70 + 200, ScreenWidth/2 - 10, 35)];
    buyLab.font = [UIFont systemFontOfSize:15];
    [buyLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [buyLab setBackgroundColor:[UIColor whiteColor]];
    buyLab.layer.borderWidth = 1;
    buyLab.layer.borderColor = [UIColor greenColor].CGColor;
    // brandLabel.numberOfLines = 0;
    [self.view addSubview:buyLab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 310, 15, 15)];
    btn.tag = 1;
    [btn setImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(remberMethods:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *hasLab = [[UILabel alloc] initWithFrame:CGRectMake(25 , 310, 45, 15)];
    hasLab.text = @"我同意";
    hasLab.font = [UIFont systemFontOfSize:15];
    hasLab.textColor = [ConMethods colorWithHexString:@"333333"];
    [self.view addSubview:hasLab];
    
    
    UIButton *procoalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    procoalBtn.frame = CGRectMake(70, 310, 90, 15);
    [procoalBtn setTitle:@"《认购协议》" forState:UIControlStateNormal];
    [procoalBtn setTitleColor:[ConMethods colorWithHexString:@"087dcd"] forState:UIControlStateNormal];
    procoalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [procoalBtn addTarget:self action:@selector(pushVCProtocal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:procoalBtn];
    
    //支付按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(20,330, ScreenWidth/2 - 10 - 15, 35);
    sureBtn.backgroundColor = [ConMethods colorWithHexString:@"fe8103"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    
    [sureBtn setTitle:@"确认报价" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureMehtods:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureBtn];
    
    
    
    /******** 具体信息 **********/
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 70, ScreenWidth/2 - 5, 300)];
    backView.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    
    //全部
    UILabel *allLab = [[UILabel alloc] initWithFrame:CGRectMake(40,0 , (ScreenWidth/2 - 5) - 80, 25)];
    allLab.font = [UIFont systemFontOfSize:13];
    [allLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [allLab setBackgroundColor:[UIColor whiteColor]];
    allLab.textAlignment = NSTextAlignmentCenter;
    // brandLabel.numberOfLines = 0;
    allLab.text = @"金额";
    [backView addSubview:allLab];
    
    //数量
    
    UILabel *labcount = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 45,0 , 40, 25)];
    labcount.font = [UIFont systemFontOfSize:13];
    [labcount setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [labcount setBackgroundColor:[UIColor clearColor]];
    labcount.textAlignment = NSTextAlignmentCenter;
    // brandLabel.numberOfLines = 0;
    labcount.text = @"数量";
    [backView addSubview:labcount];
    
    /* 卖三到买三 */
    
    NSArray *arr = @[@"卖三",@"卖二",@"卖一",@"最新价",@"买一",@"买二",@"买三"];
    
    NSArray *countArr = @[[_dic objectForKey:@"FID_MCJG3"],[_dic objectForKey:@"FID_MCJG2"],[_dic objectForKey:@"FID_MCJG1"],[_dic objectForKey:@"FID_ZXJ"],[_dic objectForKey:@"FID_MRJG1"],[_dic objectForKey:@"FID_MRJG2"],[_dic objectForKey:@"FID_MRJG3"]];
    
     NSArray *countArrTip = @[[_dic objectForKey:@"FID_MCSL3"],[_dic objectForKey:@"FID_MCSL2"],[_dic objectForKey:@"FID_MCSL1"],@"--",[_dic objectForKey:@"FID_MRSL1"],[_dic objectForKey:@"FID_MRSL2"],[_dic objectForKey:@"FID_MRSL3"]];
    
    
    for (int i = 0; i < 7; i++) {
        
        UILabel *labcount = [[UILabel alloc] initWithFrame:CGRectMake(0,25 + 25*i , 40, 25)];
        labcount.font = [UIFont systemFontOfSize:13];
        [labcount setTextColor:[ConMethods colorWithHexString:@"333333"]];
        [labcount setBackgroundColor:[UIColor clearColor]];
        labcount.textAlignment = NSTextAlignmentCenter;
        // brandLabel.numberOfLines = 0;
        labcount.text = [arr objectAtIndex:i];
        [backView addSubview:labcount];
        
        
        UILabel *allLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 25*i + 25, (ScreenWidth/2 - 5) - 80, 25)];
        allLab.font = [UIFont systemFontOfSize:13];
        [allLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
        [allLab setBackgroundColor:[UIColor whiteColor]];
        allLab.textAlignment = NSTextAlignmentCenter;
        // brandLabel.numberOfLines = 0;
        allLab.text = [NSString stringWithFormat:@"%.2f",[[countArr objectAtIndex:i] doubleValue]];
        [backView addSubview:allLab];
        
        
        UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 45, 25*i + 25, 40, 25)];
        countL.font = [UIFont systemFontOfSize:13];
        [countL setTextColor:[ConMethods colorWithHexString:@"333333"]];
        [countL setBackgroundColor:[UIColor clearColor]];
        countL.textAlignment = NSTextAlignmentCenter;
        // brandLabel.numberOfLines = 0;
        countL.text = [countArrTip objectAtIndex:i];
        [backView addSubview:countL];
        
        
    }
    
    NSArray *arrtitle = @[@"最高成交(元)",@"最低成交(元)",@"总成交额(元)",@"总成交量(元)"];
    
    NSArray *arrVelual = @[[_dic objectForKey:@"FID_ZGBJ"],[_dic objectForKey:@"FID_ZDBJ"],[_dic objectForKey:@"FID_CJJE"],[_dic objectForKey:@"FID_CJSL"]];
    
    
    for (int i = 0; i < 4; i++) {
        
        UILabel *labcount = [[UILabel alloc] initWithFrame:CGRectMake(0,200 + 25*i , 80, 25)];
        labcount.font = [UIFont systemFontOfSize:13];
        [labcount setTextColor:[ConMethods colorWithHexString:@"333333"]];
        [labcount setBackgroundColor:[UIColor clearColor]];
        labcount.textAlignment = NSTextAlignmentCenter;
        // brandLabel.numberOfLines = 0;
        labcount.text = [arrtitle objectAtIndex:i];
        [backView addSubview:labcount];
        
        
        UILabel *allLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 25*i + 200, (ScreenWidth/2 - 5) - 80, 25)];
        allLab.font = [UIFont systemFontOfSize:13];
        [allLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
        [allLab setBackgroundColor:[UIColor whiteColor]];
        allLab.textAlignment = NSTextAlignmentCenter;
        // brandLabel.numberOfLines = 0;
        allLab.text = [NSString stringWithFormat:@"%.2f",[[arrVelual objectAtIndex:i] doubleValue]];
        [backView addSubview:allLab];
        
        
        
    }
    
    for ( int i = 0; i < 13; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*25, ScreenWidth/2 - 5, 1)];
        lineView.backgroundColor = [UIColor blackColor];
        [backView addSubview:lineView];
    }
    
    
    
    [self.view addSubview:backView];

    
    
    
    

}

- (IBAction)remberMethods:(UIButton *)sender {
    
        count++;
        
        if (count % 2 == 0) {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
            
            
        } else {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateNormal];
            
        }
    
    
}

-(void)pushVCProtocal{
    
    //ProductProcoalViewController *vc = [[ProductProcoalViewController alloc] init];
   // vc.str = [self.dic objectForKey:@"GQDM"];
   // vc.hidesBottomBarWhenPushed = YES;
   // [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (IBAction)sureMehtods:(id)sender {
    [self.view endEditing:YES];
    if ([priceLab.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"价格不能为空"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];

    }else if (count % 2 == 0) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请阅读并同意认购协议"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
      
        
    }else if ([countLab.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"购买数量不能为空"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        
    }else if ([countLab.text floatValue] > [buyLab.text floatValue]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"购买数量不能高于可买数量"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        
    } else {

        [self requestDataSubmit:_gqdm];
    }
}

-(void) requestDataSubmit:(NSString *)str {
    
    
    NSDictionary *parameters = @{@"gqdm":str,@"wtlb":@"1",@"wtjg":priceLab.text,@"wtsl":countLab.text,@"ydh":@"0"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERequityTradeSubmit] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [self.navigationController popViewControllerAnimated:YES];
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.navigationController.view
                                     displayInterval:3];
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






#pragma mark-文本框代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 76 - (self.view.frame.size.height - 256.0);//键盘高度216
    //动画
   
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if (textField == priceLab) {
        if ([priceLab.text isEqualToString:@""]||priceLab == nil) {
            [[HttpMethods Instance] activityIndicate:NO
             
                                          tipContent:@"请输入价格"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];;
        } else {
            [self requestBuyCount:_gqdm];
        }
    }
    
}

//获取可买数量
-(void) requestBuyCount:(NSString *)str {
    
    //买入1，卖出2
    NSDictionary *parameters = @{@"gqdm":str,@"wtlb":@"1",@"wtjg":priceLab.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryKmmsl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
             buyLab.text = [[responseObject objectForKey:@"object"] objectForKey:@"FID_WTSL"];
           
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
           
            
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





-(void) requestData:(NSString *)str {
    
   
    NSDictionary *parameters = @{@"gqdm":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryGqhq] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
             [self refreshUI:[responseObject objectForKey:@"object"]];
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
           
            
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
