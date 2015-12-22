//
//  DetailViewController.m
//  GuizhouEquityTrading
//
//  Created by mac on 15/10/23.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "HMSegmentedControlLast.h"

@interface DetailViewController ()
{
    float addHight;
    UITextField *priceLab;
    UITextField *countLab;
    UILabel *buyLab;
    UILabel *moneyLab;
    int count;
    UIView *MyBackView;
    UITextField *putCodeText;
    UILabel *codeLab;
    NSDictionary *myDic;
    UIButton *jianBtn;
    
    
    UITextField *priceSellLab;
    UITextField *countSellLab;
    UILabel *buySellLab;
    UILabel *moneySellLab;
    int countSell;
    UIView *MyBackViewSell;
    UITextField *putCodeTextSell;
    UILabel *codeSellLab;
    NSDictionary *mySellDic;
    UIButton *jianBtnSell;
    
    
   
   
    
    UIWebView *webView1;
    UIWebView *webView2;
    
}

@property(nonatomic,strong)HMSegmentedControlLast *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;

@end

@implementation DetailViewController
@synthesize segmentedControl,scrollView,view2,view1;

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
    
    segmentedControl = [[HMSegmentedControlLast alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 30)];
    segmentedControl.font = [UIFont systemFontOfSize:15];
    segmentedControl.sectionTitles = @[@"股权买入",@"股权卖出",@"k线图",@"分时图"];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.selectedTextColor = [ConMethods colorWithHexString:@"c40000"];
    segmentedControl.selectionLocation =  HMSegmentedControlSelectionLocationDown;
    
    segmentedControl.type = HMSegmentedControlTypeText;
    
    
    segmentedControl.selectionIndicatorHeight = 2;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStrip;
    segmentedControl.selectionIndicatorColor = [ConMethods colorWithHexString:@"c40000"];
    
    [self.view addSubview:segmentedControl];
    
    
   
    
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 30;
    
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44 + addHight + 30, ScreenWidth, scrollViewHeight)];
    //self.scrollView.tag = TSEGSCROLLVIEW;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*4, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 44 + addHight, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    self.scrollView.backgroundColor = [ConMethods colorWithHexString:@"f3f3f3"];
    [self.view addSubview:self.scrollView];
    
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth*index, 44 + addHight, ScreenWidth, scrollViewHeight) animated:NO];
        if (index == 1) {
            if (!weakSelf.view2) {
                [weakSelf requestSeelData:weakSelf.gqdm];
            }
            
        } else if(index == 2){
            if (!webView1) {
                [self getWebView];
            }
        
        } else if (index == 3){
            if (!webView2) {
                [self getWebViewTime];
            }
        
        }
    }];
    
    
    [self requestData:_gqdm];
}


// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV
{
    
        CGFloat pageWidth = ScreenWidth;
        NSInteger page = scrollView.contentOffset.x / pageWidth ;
       segmentedControl.selectedSegmentIndex = page;
       
        if (page == 1) {
            if (!view2) {
                [self requestSeelData:_gqdm];
            }
            
        } else if(page == 2){
            if (!webView1) {
                [self getWebView];
            }
            
        } else if (page == 3){
            if (!webView2) {
                [self getWebViewTime];
        }
    }
}



-(void)getWebView{
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 30;
    
    webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, scrollViewHeight)];
    webView1.delegate = self;

    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/appcharts/kline?cpdm=%@",SERVERURL,_gqdm]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [webView1 loadRequest:request];

    [scrollView addSubview:webView1];
}

-(void)getWebViewTime{
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 30;
    
    webView2 = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth, scrollViewHeight)];
    webView2.delegate = self;
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/appcharts/kline?cpdm=%@",SERVERURL,_gqdm]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [webView2 loadRequest:request];
    
    [scrollView addSubview:webView2];
}



- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[HttpMethods Instance] activityIndicate:NO
                                  tipContent:@"加载成功"
                               MBProgressHUD:nil
                                      target:self.view
                             displayInterval:2];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[HttpMethods Instance] activityIndicate:NO
                                  tipContent:@"加载失败"
                               MBProgressHUD:nil
                                      target:self.view
                             displayInterval:2];
    
}


-(void)refreshSellUI:(NSDictionary *)_dic{
    
    mySellDic = _dic;
    
    if (view2) {
        [view2 removeFromSuperview];
        view2 = nil;
    }
    
    view2 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight  - 64 - 30)];
    view2.backgroundColor = [UIColor clearColor];
    
    //股权代码
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(5,10, ScreenWidth/2 - 10, 35)];
    [codeView setBackgroundColor:[UIColor whiteColor]];
    codeView.layer.borderWidth = 1;
    codeView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    
    
    codeSellLab = [[UILabel alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    codeSellLab.font = [UIFont systemFontOfSize:14];
    [codeSellLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [codeSellLab setBackgroundColor:[UIColor clearColor]];
    codeSellLab.text = [_dic objectForKey:@"FID_GQDM"];
    [codeView addSubview:codeSellLab];
    
    UITapGestureRecognizer *singleTap1;
    
    singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    codeView.tag = 1002;
    [codeView addGestureRecognizer:singleTap1];
    
    
    [view2 addSubview:codeView];
    
    //名称
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 40, ScreenWidth/2 - 10, 35)];
    [nameView setBackgroundColor:[ConMethods colorWithHexString:@"e3e3e3"]];
    nameView.layer.borderWidth = 1;
    nameView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    nameLab.font = [UIFont systemFontOfSize:14];
    [nameLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [nameLab setBackgroundColor:[UIColor clearColor]];
    nameLab.text = [_dic objectForKey:@"FID_GQMC"];
    
    [nameView addSubview:nameLab];
    [view2 addSubview:nameView];
    
    //委托价格
    
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 80, ScreenWidth/2 - 10, 35)];
    [priceView setBackgroundColor:[UIColor whiteColor]];
    priceView.layer.borderWidth = 1;
    priceView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    
    jianBtnSell = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [jianBtnSell setTitle:@"-" forState:UIControlStateNormal];
    [jianBtnSell setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jianBtnSell.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
    jianBtnSell.tag = 10006;
    //jianBtn.enabled = NO;
    //[jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
    
    [jianBtnSell addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [priceView addSubview:jianBtnSell];
    
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 10 - 35, 0, 35, 35)];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
    
    
    addBtn.tag = 10007;
    [addBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [priceView addSubview:addBtn];
    
    
    priceSellLab = [[UITextField alloc] initWithFrame:CGRectMake(40,10, ScreenWidth/2 - 10 - 70, 15)];
    priceSellLab.font = [UIFont systemFontOfSize:14];
    [priceSellLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [priceSellLab setBackgroundColor:[UIColor clearColor]];
    priceSellLab.placeholder = @"请输入价格";
    
    priceSellLab.text = [NSString stringWithFormat:@"%.2f",[[_dic objectForKey:@"FID_ZXJ"] floatValue]];
    priceSellLab.delegate = self;
    priceSellLab.clearButtonMode = UITextFieldViewModeWhileEditing;
    [priceView addSubview:priceSellLab];
    [view2 addSubview:priceView];
    
    //委托数量
    
    UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 120, ScreenWidth/2 - 10, 35)];
    [countView setBackgroundColor:[UIColor whiteColor]];
    countView.layer.borderWidth = 1;
    countView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    
    countSellLab = [[UITextField alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    countSellLab.font = [UIFont systemFontOfSize:14];
    [countSellLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [countSellLab setBackgroundColor:[UIColor clearColor]];
    countSellLab.placeholder = @"请输入数量";
    countSellLab.delegate = self;
    countSellLab.clearButtonMode = UITextFieldViewModeWhileEditing;
    [countView addSubview:countSellLab];
    [view2 addSubview:countView];
    
    //可用资金
    
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 160, ScreenWidth/2 - 10, 35)];
    [moneyView setBackgroundColor:[ConMethods colorWithHexString:@"e3e3e3"]];
    moneyView.layer.borderWidth = 1;
    moneyView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    moneySellLab = [[UILabel alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    moneySellLab.font = [UIFont systemFontOfSize:14];
    [moneySellLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [moneySellLab setBackgroundColor:[UIColor clearColor]];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    moneySellLab.text = [delegate.userMoney objectForKey:@"FID_KYZJ"];
    [moneyView addSubview:moneySellLab];
    [view2 addSubview:moneyView];
    
    //可买数量
    
    UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 200, ScreenWidth/2 - 10, 35)];
    [buyView setBackgroundColor:[ConMethods colorWithHexString:@"e3e3e3"]];
    buyView.layer.borderWidth = 1;
    buyView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    buySellLab = [[UILabel alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    buySellLab.font = [UIFont systemFontOfSize:14];
    [buySellLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [buySellLab setBackgroundColor:[UIColor clearColor]];
    [buyView addSubview:buySellLab];
    [view2 addSubview:buyView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 310 - 60, 15, 15)];
    btn.tag = 2;
    [btn setImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(remberMethods:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:btn];
    
    UILabel *hasLab = [[UILabel alloc] initWithFrame:CGRectMake(25 , 310 - 60, 45, 15)];
    hasLab.text = @"我同意";
    hasLab.font = [UIFont systemFontOfSize:13];
    hasLab.textColor = [ConMethods colorWithHexString:@"333333"];
    [view2 addSubview:hasLab];
    
    
    UIButton *procoalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    procoalBtn.frame = CGRectMake(70, 310 - 60, 90, 15);
    [procoalBtn setTitle:@"《认购协议》" forState:UIControlStateNormal];
    [procoalBtn setTitleColor:[ConMethods colorWithHexString:@"087dcd"] forState:UIControlStateNormal];
    procoalBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [procoalBtn addTarget:self action:@selector(pushVCProtocal) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:procoalBtn];
    
    //支付按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10,330 - 60, ScreenWidth/2 - 20, 35);
    sureBtn.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    sureBtn.tag = 1001;
    [sureBtn setTitle:@"确认报价" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureMehtods:) forControlEvents:UIControlEventTouchUpInside];
    
    [view2 addSubview:sureBtn];
    
    
    
    /******** 具体信息 **********/
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 10, ScreenWidth/2 - 5, 300)];
    backView.backgroundColor = [ConMethods colorWithHexString:@"f3f3f3"];
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [ConMethods colorWithHexString:@"999999"].CGColor;
    
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
    
    for ( int i = 0; i < 12; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*25, ScreenWidth/2 - 5, 1)];
        lineView.backgroundColor = [ConMethods colorWithHexString:@"999999"];
        [backView addSubview:lineView];
    }
    [view2 addSubview:backView];
    [scrollView addSubview:view2];
    
    
    [self requestSellCount];
    
}


-(void)refreshUI:(NSDictionary *)_dic{
    
    myDic = _dic;
    
    if (view1) {
        [view1 removeFromSuperview];
        view1 = nil;
    }
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight  - 64 - 30)];
    view1.backgroundColor = [UIColor clearColor];
    
    //股权代码
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(5,10, ScreenWidth/2 - 10, 35)];
    [codeView setBackgroundColor:[UIColor whiteColor]];
    codeView.layer.borderWidth = 1;
    codeView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    
    
    codeLab = [[UILabel alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    codeLab.font = [UIFont systemFontOfSize:14];
    [codeLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [codeLab setBackgroundColor:[UIColor clearColor]];
    codeLab.text = [_dic objectForKey:@"FID_GQDM"];
    [codeView addSubview:codeLab];
    
    UITapGestureRecognizer *singleTap1;
    
    singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    codeView.tag = 1001;
    [codeView addGestureRecognizer:singleTap1];
    
    
    [view1 addSubview:codeView];
    
    //名称
    
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 40, ScreenWidth/2 - 10, 35)];
    [nameView setBackgroundColor:[ConMethods colorWithHexString:@"e3e3e3"]];
    nameView.layer.borderWidth = 1;
    nameView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    nameLab.font = [UIFont systemFontOfSize:14];
    [nameLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [nameLab setBackgroundColor:[UIColor clearColor]];
    nameLab.text = [_dic objectForKey:@"FID_GQMC"];
    
    [nameView addSubview:nameLab];
    [view1 addSubview:nameView];
    
    //委托价格
    
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 80, ScreenWidth/2 - 10, 35)];
    [priceView setBackgroundColor:[UIColor whiteColor]];
    priceView.layer.borderWidth = 1;
    priceView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    
   jianBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [jianBtn setTitle:@"-" forState:UIControlStateNormal];
    [jianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    jianBtn.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
    jianBtn.tag = 10001;
    //jianBtn.enabled = NO;
    //[jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
    
    [jianBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [priceView addSubview:jianBtn];
    
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 10 - 35, 0, 35, 35)];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
    
    
    addBtn.tag = 10002;
    [addBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [priceView addSubview:addBtn];

    
    priceLab = [[UITextField alloc] initWithFrame:CGRectMake(40,10, ScreenWidth/2 - 10 - 70, 15)];
    priceLab.font = [UIFont systemFontOfSize:14];
    [priceLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [priceLab setBackgroundColor:[UIColor clearColor]];
    priceLab.placeholder = @"请输入价格";
    
    priceLab.text = [NSString stringWithFormat:@"%.2f",[[_dic objectForKey:@"FID_ZXJ"] floatValue]];
    priceLab.delegate = self;
    priceLab.clearButtonMode = UITextFieldViewModeWhileEditing;
    [priceView addSubview:priceLab];
    [view1 addSubview:priceView];
    
    //委托数量
    
    UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 120, ScreenWidth/2 - 10, 35)];
    [countView setBackgroundColor:[UIColor whiteColor]];
    countView.layer.borderWidth = 1;
    countView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    
    countLab = [[UITextField alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    countLab.font = [UIFont systemFontOfSize:14];
    [countLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [countLab setBackgroundColor:[UIColor clearColor]];
    countLab.placeholder = @"请输入数量";
    countLab.delegate = self;
     countLab.clearButtonMode = UITextFieldViewModeWhileEditing;
    [countView addSubview:countLab];
    [view1 addSubview:countView];
    
    //可用资金
    
    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 160, ScreenWidth/2 - 10, 35)];
    [moneyView setBackgroundColor:[ConMethods colorWithHexString:@"e3e3e3"]];
    moneyView.layer.borderWidth = 1;
    moneyView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    moneyLab.font = [UIFont systemFontOfSize:14];
    [moneyLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [moneyLab setBackgroundColor:[UIColor clearColor]];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    moneyLab.text = [delegate.userMoney objectForKey:@"FID_KYZJ"];
    [moneyView addSubview:moneyLab];
    [view1 addSubview:moneyView];
    
    //可买数量
    
    UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(5,10 + 200, ScreenWidth/2 - 10, 35)];
    [buyView setBackgroundColor:[ConMethods colorWithHexString:@"e3e3e3"]];
    buyView.layer.borderWidth = 1;
    buyView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    buyLab = [[UILabel alloc] initWithFrame:CGRectMake(5,5, ScreenWidth/2 - 20, 25)];
    buyLab.font = [UIFont systemFontOfSize:14];
    [buyLab setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [buyLab setBackgroundColor:[UIColor clearColor]];
    [buyView addSubview:buyLab];
    [view1 addSubview:buyView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 310 - 60, 15, 15)];
    btn.tag = 1;
    [btn setImage:[UIImage imageNamed:@"select_0"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(remberMethods:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];
    
    UILabel *hasLab = [[UILabel alloc] initWithFrame:CGRectMake(25 , 310 - 60, 45, 15)];
    hasLab.text = @"我同意";
    hasLab.font = [UIFont systemFontOfSize:13];
    hasLab.textColor = [ConMethods colorWithHexString:@"333333"];
    [view1 addSubview:hasLab];
    
    
    UIButton *procoalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    procoalBtn.frame = CGRectMake(70, 310 - 60, 90, 15);
    [procoalBtn setTitle:@"《认购协议》" forState:UIControlStateNormal];
    [procoalBtn setTitleColor:[ConMethods colorWithHexString:@"087dcd"] forState:UIControlStateNormal];
    procoalBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [procoalBtn addTarget:self action:@selector(pushVCProtocal) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:procoalBtn];
    
    //支付按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10,330 - 60, ScreenWidth/2 - 20, 35);
    sureBtn.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    sureBtn.tag = 1002;
    [sureBtn setTitle:@"确认报价" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sureBtn addTarget:self action:@selector(sureMehtods:) forControlEvents:UIControlEventTouchUpInside];
    
    [view1 addSubview:sureBtn];
    
    
    
    /******** 具体信息 **********/
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 10, ScreenWidth/2 - 5, 300)];
    backView.backgroundColor = [ConMethods colorWithHexString:@"f3f3f3"];
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [ConMethods colorWithHexString:@"999999"].CGColor;
    
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
    
    for ( int i = 0; i < 12; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i*25, ScreenWidth/2 - 5, 1)];
        lineView.backgroundColor = [ConMethods colorWithHexString:@"999999"];
        [backView addSubview:lineView];
    }
    [view1 addSubview:backView];
    [scrollView addSubview:view1];
    
    
    [self requestBuyCount];

 }


#pragma mark - 提交报价弹窗
-(void)callPhone:(UITouch *)touch {
    
    UIView *view = [touch view];
    if (view.tag == 1002) {
        
        
        if (MyBackViewSell) {
            [MyBackViewSell removeFromSuperview];
        }
        
        MyBackViewSell  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        MyBackViewSell.backgroundColor = [ConMethods colorWithHexString:@"bfbfbf" withApla:0.8];
        MyBackViewSell.layer.masksToBounds = YES;
        MyBackViewSell.layer.cornerRadius = 4;
        
        UIView *litleView = [[UIView alloc] initWithFrame:CGRectMake(20, (ScreenHeight - 200)/2, ScreenWidth - 40, 200)];
        litleView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
        
        
        UILabel *nameLabTip = [[UILabel alloc] init];
        nameLabTip.text = @"输入您所要查询的代码：";
        nameLabTip.textColor = [ConMethods colorWithHexString:@"333333"];
        nameLabTip.font = [UIFont systemFontOfSize:15];
        nameLabTip.frame = CGRectMake(20, 50, [PublicMethod getStringWidth:nameLabTip.text font:nameLabTip.font], 15);
        [litleView addSubview:nameLabTip];
        
        
        UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(20,80, ScreenWidth - 80, 35)];
        [buyView setBackgroundColor:[ConMethods colorWithHexString:@"e3e3e3"]];
        buyView.layer.borderWidth = 1;
        buyView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
        
        putCodeTextSell = [[UITextField alloc] initWithFrame:CGRectMake(10,10, ScreenWidth - 100, 15)];
        putCodeTextSell.font = [UIFont systemFontOfSize:14];
        [putCodeTextSell setTextColor:[ConMethods colorWithHexString:@"333333"]];
        [putCodeTextSell setBackgroundColor:[UIColor clearColor]];
        putCodeTextSell.placeholder = @"请输入价格";
        putCodeTextSell.delegate = self;
        putCodeTextSell.clearButtonMode = UITextFieldViewModeWhileEditing;
        [buyView addSubview:putCodeTextSell];
        [litleView addSubview:buyView];
        
        
        
        
        //确定 取消
        UIButton *commitB = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 - 95, 130, 80, 30)];
        commitB.layer.masksToBounds = YES;
        commitB.layer.cornerRadius = 4;
        commitB.backgroundColor = [ConMethods colorWithHexString:@"850301"];
        
        [commitB setTitle:@"确定" forState:UIControlStateNormal];
        [commitB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        commitB.titleLabel.font = [UIFont systemFontOfSize:15];
        commitB.tag = 10009;
        [commitB addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
        [litleView addSubview:commitB];
        
        
        
        UIButton *quitBtn = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 + 15, 130, 80, 30)];
        quitBtn.layer.masksToBounds = YES;
        quitBtn.layer.cornerRadius = 4;
        quitBtn.backgroundColor = [ConMethods colorWithHexString:@"aaaaaa"];
        
        [quitBtn setTitle:@"取消" forState:UIControlStateNormal];
        [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        quitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        quitBtn.tag = 10010;
        [quitBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
        [litleView addSubview:quitBtn];
        
        [MyBackViewSell addSubview:litleView];
        [self.view addSubview:MyBackViewSell];
    } else {
    
  
        if (MyBackView) {
            [MyBackView removeFromSuperview];
        }
        
        MyBackView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        MyBackView.backgroundColor = [ConMethods colorWithHexString:@"bfbfbf" withApla:0.8];
        MyBackView.layer.masksToBounds = YES;
        MyBackView.layer.cornerRadius = 4;
        
        UIView *litleView = [[UIView alloc] initWithFrame:CGRectMake(20, (ScreenHeight - 200)/2, ScreenWidth - 40, 200)];
        litleView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
        
        
        UILabel *nameLabTip = [[UILabel alloc] init];
        nameLabTip.text = @"输入您所要查询的代码：";
        nameLabTip.textColor = [ConMethods colorWithHexString:@"333333"];
        nameLabTip.font = [UIFont systemFontOfSize:15];
        nameLabTip.frame = CGRectMake(20, 50, [PublicMethod getStringWidth:nameLabTip.text font:nameLabTip.font], 15);
        [litleView addSubview:nameLabTip];
    
    
    UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(20,80, ScreenWidth - 80, 35)];
    [buyView setBackgroundColor:[ConMethods colorWithHexString:@"e3e3e3"]];
    buyView.layer.borderWidth = 1;
    buyView.layer.borderColor = [ConMethods colorWithHexString:@"c40000"].CGColor;
    
    putCodeText = [[UITextField alloc] initWithFrame:CGRectMake(10,10, ScreenWidth - 100, 15)];
    putCodeText.font = [UIFont systemFontOfSize:14];
    [putCodeText setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [putCodeText setBackgroundColor:[UIColor clearColor]];
    putCodeText.placeholder = @"请输入价格";
    putCodeText.delegate = self;
    putCodeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [buyView addSubview:putCodeText];
    [litleView addSubview:buyView];
    
    
        
        
        //确定 取消
        UIButton *commitB = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 - 95, 130, 80, 30)];
        commitB.layer.masksToBounds = YES;
        commitB.layer.cornerRadius = 4;
        commitB.backgroundColor = [ConMethods colorWithHexString:@"850301"];
        
        [commitB setTitle:@"确定" forState:UIControlStateNormal];
        [commitB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        commitB.titleLabel.font = [UIFont systemFontOfSize:15];
        commitB.tag = 10004;
        [commitB addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
        [litleView addSubview:commitB];
        
        
        
        UIButton *quitBtn = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 + 15, 130, 80, 30)];
        quitBtn.layer.masksToBounds = YES;
        quitBtn.layer.cornerRadius = 4;
        quitBtn.backgroundColor = [ConMethods colorWithHexString:@"aaaaaa"];
        
        [quitBtn setTitle:@"取消" forState:UIControlStateNormal];
        [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        quitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        quitBtn.tag = 10005;
        [quitBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
        [litleView addSubview:quitBtn];
        
        [MyBackView addSubview:litleView];
        [self.view addSubview:MyBackView];
    }

}

-(void)summitBtnMethods:(UIButton *)btn {
    if (btn.tag == 10005) {
        [MyBackView removeFromSuperview];
        MyBackView = nil;
    } else if(btn.tag == 10004){
        if ([putCodeText.text isEqualToString:@""]) {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请输入所要查询的代码"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
        } else {
        
        [self requestData:putCodeText.text];
        }
    } else if(btn.tag == 10001) {
        
        float xiaoshu = [priceLab.text floatValue] - [[myDic objectForKey:@"FID_JYJS"] floatValue];
        
        if (xiaoshu > 0) {
            if (xiaoshu - [[myDic objectForKey:@"FID_JYJS"] floatValue] > 0) {
               priceLab.text = [NSString stringWithFormat:@"%.2f",xiaoshu];
            } else {
             priceLab.text = [NSString stringWithFormat:@"%.2f",xiaoshu];
                btn.backgroundColor = [ConMethods colorWithHexString:@"9a9a9a"];
                btn.enabled = NO;
            }
        } else {
            btn.backgroundColor = [ConMethods colorWithHexString:@"9a9a9a"];
            btn.enabled = NO;
        
        }
        [self requestBuyCount];
    }else if(btn.tag == 10002){
     priceLab.text = [NSString stringWithFormat:@"%.2f",[priceLab.text floatValue] + [[myDic objectForKey:@"FID_JYJS"] floatValue]];
        if (!jianBtn.enabled) {
            jianBtn.enabled = YES;
            jianBtn.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
        }
   
    } else if (btn.tag == 10006){
        float xiaoshu = [priceSellLab.text floatValue] - [[mySellDic objectForKey:@"FID_JYJS"] floatValue];
        
        if (xiaoshu > 0) {
            if (xiaoshu - [[mySellDic objectForKey:@"FID_JYJS"] floatValue] > 0) {
                priceSellLab.text = [NSString stringWithFormat:@"%.2f",xiaoshu];
            } else {
                priceSellLab.text = [NSString stringWithFormat:@"%.2f",xiaoshu];
                btn.backgroundColor = [ConMethods colorWithHexString:@"9a9a9a"];
                btn.enabled = NO;
            }
        } else {
            btn.backgroundColor = [ConMethods colorWithHexString:@"9a9a9a"];
            btn.enabled = NO;
            
        }
        [self requestSellCount];
        
    
    } else if (btn.tag == 10007){
        priceSellLab.text = [NSString stringWithFormat:@"%.2f",[priceSellLab.text floatValue] + [[mySellDic objectForKey:@"FID_JYJS"] floatValue]];
        if (!jianBtnSell.enabled) {
            jianBtnSell.enabled = YES;
            jianBtnSell.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
        }
    
    }
}



- (IBAction)remberMethods:(UIButton *)sender {
    
    
    if (sender.tag == 1) {
        
        count++;
        
        if (count % 2 == 0) {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
            
            
        } else {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateNormal];
            
        }
        
    } else {
    
        countSell++;
        
        if (countSell % 2 == 0) {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_0.png"] forState:UIControlStateNormal];
            
            
        } else {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"select_1.png"] forState:UIControlStateNormal];
            
        }
    
    }
}

-(void)pushVCProtocal{
    
    //ProductProcoalViewController *vc = [[ProductProcoalViewController alloc] init];
   // vc.str = [self.dic objectForKey:@"GQDM"];
   // vc.hidesBottomBarWhenPushed = YES;
   // [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (IBAction)sureMehtods:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (sender.tag == 1001) {
        
        if ([priceSellLab.text isEqualToString:@""]) {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"价格不能为空"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
        }else if (countSell % 2 == 0) {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请阅读并同意认购协议"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
        }else if ([countSellLab.text isEqualToString:@""]) {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"购买数量不能为空"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
        }else if ([countSellLab.text floatValue] > [buySellLab.text floatValue]) {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"购买数量不能高于可买数量"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
        } else {
            
            [self requestDataSellSubmit:codeSellLab.text];
        }
    } else {
    
    
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

        [self requestDataSubmit:codeLab.text];
    }
    }
}

-(void) requestDataSellSubmit:(NSString *)str {
    
    
    NSDictionary *parameters = @{@"gqdm":str,@"wtlb":@"2",@"wtjg":priceSellLab.text,@"wtsl":countSellLab.text,@"ydh":@"0"};
    
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
            [self requestBuyCount];
        }
    }
    
}


//获取可买数量
-(void) requestSellCount{
    
    //买入1，卖出2
    NSDictionary *parameters = @{@"gqdm":codeSellLab.text,@"wtlb":@"2",@"wtjg":priceSellLab.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryKmmsl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            buySellLab.text = [[responseObject objectForKey:@"object"] objectForKey:@"FID_WTSL"];
            
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

//获取可买数量
-(void) requestBuyCount{
   
    //买入1，卖出2
    NSDictionary *parameters = @{@"gqdm":codeLab.text,@"wtlb":@"1",@"wtjg":priceLab.text};
    
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


-(void) requestSeelData:(NSString *)str {
    
    
    NSDictionary *parameters = @{@"gqdm":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryGqhq] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            if (MyBackViewSell) {
                [MyBackViewSell removeFromSuperview];
                MyBackViewSell = nil;
            }
            
            
            [self refreshSellUI:[responseObject objectForKey:@"object"]];
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
            
            if (MyBackView) {
                [MyBackView removeFromSuperview];
                MyBackView = nil;
            }
            
            
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
