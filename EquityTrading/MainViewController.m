//
//  MainViewController.m
//  GuizhouEquityTrading
//
//  Created by mac on 15/10/23.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "TransferDetailViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"


@interface MainViewController ()
{
    float addHight;
    UISegmentedControl  *segmented;
    UIScrollView *scroller;
    UIView *lineView;
    int btnCount;
    NSMutableArray *btnArray;
    NSMutableArray *btnArrayName;
    
    UITableView *table;
    UITableView *tablePast;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    
    NSString *startPast;
    NSString *startBakPast;
    NSString *limitPast;
    NSMutableArray *dataListPast;
    BOOL hasMorePast;
    UITableViewCell *moreCellPast;
    
    NSString *strCount;
    
    
    BOOL NoMoreCount;
    
    
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooterPast;



@end

@implementation MainViewController
@synthesize scrollView;


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self selectBtn];
    
}


//是否选定第一个按钮
-(void) selectBtn {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([delegate.loginStr isEqualToString:@"1"]) {
        segmented.selectedSegmentIndex = 0;
        /*
         __weak typeof(self) weakSelf = self;
         [weakSelf.scrollView scrollRectToVisible:CGRectMake(0 , 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
         */
        [self segmentAction:segmented];
            delegate.loginStr = @"";
    } else {
        if ( [strCount isEqualToString:@"1"]) {
            [self isLogin];
        }
    
    }

}


//判定是否登录
-(void)isLogin {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.loginUser.count > 0) {
        
        if ([[delegate.loginUser objectForKey:@"success"] boolValue]) {
            startPast = @"1";
            [self requestMyGqzcPaging];
        } else {
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }


}



-(void) segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %li",(long)Index);
    __weak typeof(self) weakSelf = self;
    
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (Seg.selectedSegmentIndex == 0) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        
        
    } else if(Seg.selectedSegmentIndex == 1){
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * Seg.selectedSegmentIndex, 0, ScreenWidth, ScreenHeight  - 64 - 49) animated:YES];
        strCount = @"1";
        [self isLogin];
        }
    
    
}


// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV
{
    
    if (scrollV == scrollView) {
        CGFloat pageWidth = ScreenWidth;
        NSInteger page = scrollView.contentOffset.x / pageWidth ;
        segmented.selectedSegmentIndex = page;
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if (page == 0) {
            
            
            
        } else if (page == 1){
            strCount = @"1";
          [self isLogin];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    strCount = @"";
    start = @"1";
    limit = @"10";
    startBak = @"";
    startPast = @"1";
    limitPast = @"10";
    startBakPast = @"";
    btnCount = 0;
    btnArray = [NSMutableArray array];
    dataList = [NSMutableArray array];
    
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
        
    }
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, addHight, ScreenWidth, 44)];
    baseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"股权买入",@"股权卖出",nil];
    
    segmented = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextColor,  [UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    segmented.selectedSegmentIndex = 0;//设置默认选择项索引
    segmented.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
    segmented.tintColor= [UIColor whiteColor];
    
    //[segmented setTintColor:[UIColor whiteColor]]; //设置segments的颜色
    //[segmented setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    segmented.frame = CGRectMake(20, 7, ScreenWidth - 40, 30);
    /*
     UISegmentedControlStylePlain,     // large plain
     UISegmentedControlStyleBordered,  // large bordered
     UISegmentedControlStyleBar,       // small button/nav bar style. tintable
     UISegmentedControlStyleBezeled
     // segmented.segmentedControlStyle = UISegmentedControlStyleBar;
     */
    segmented.multipleTouchEnabled = NO;
   
    [segmented addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    
    [baseView addSubview:segmented];
    [self.view addSubview:baseView];
    
//给segmentedControl添加scrollView的联动事件
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 49;
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44 + addHight, ScreenWidth, scrollViewHeight)];
    
    // self.scrollView.tag = TSEGSCROLLVIEW;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.scrollView.bounces = NO;
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*2, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 64, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    
//类别的设置
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    scroller.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    scroller.showsVerticalScrollIndicator = NO;
    scroller.showsHorizontalScrollIndicator = NO;
    scroller.contentOffset = CGPointMake(0, 0);
    
    [scroller scrollRectToVisible:CGRectMake(0, 0, ScreenWidth, 40) animated:NO];
    scroller.bounces = NO;
    [self.scrollView addSubview:scroller];
    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth,scrollViewHeight - 40)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:table];
    
    //添加tableView
    
    tablePast = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth,0, ScreenWidth, scrollViewHeight)];
    [tablePast setDelegate:self];
    [tablePast setDataSource:self];
    tablePast.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tablePast setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    tablePast.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:tablePast];
    
    [self requestMethods];
    
    [self setupHeader];
    [self setupFooter];
    
    [self setupHeaderPast];
    [self setupFooterPast];
    
}


- (void)setupHeader
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
   
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:table];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (btnArrayName.count == 0||btnArrayName == nil) {
                [self requestMethods];
            } else {
            start = @"1";
            [self requestData:[[btnArrayName objectAtIndex:btnCount] objectForKey:@"FID_GQLB"]];
            }
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    // [refreshHeader beginRefreshing];
}

 
 
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:table];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    
  
    if (hasMore == NO) {
        [self.refreshFooter endRefreshing];
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
           [self requestData:[[btnArrayName objectAtIndex:btnCount] objectForKey:@"FID_GQLB"]];
            [self.refreshFooter endRefreshing];
        });
    }
}


- (void)setupHeaderPast
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:tablePast];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            startPast = @"1";
            [self requestMyGqzcPaging];
            
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    // [refreshHeader beginRefreshing];
}



- (void)setupFooterPast
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:tablePast];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefreshPast)];
    _refreshFooterPast = refreshFooter;
}


- (void)footerRefreshPast
{
    
    
    if (hasMorePast == NO) {
        [self.refreshFooterPast endRefreshing];
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self requestMyGqzcPaging];
            
            [self.refreshFooterPast endRefreshing];
        });
    }
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == table) {
        if ([dataList count] == 0) {
            return 1;
        }  else {
            return [dataList count];
        }
    } else {
        
        if ([dataListPast count] == 0) {
            return 1;
        }  else {
            return [dataListPast count];
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    if (tbleView == table) {
        
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
                tipLabel.backgroundColor = [UIColor clearColor];
                [tipLabel setText:@"没有任何商品哦~"];
                [backView addSubview:tipLabel];
                [cell.contentView addSubview:backView];
            
        } else {
           
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 125)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 115)];
                    [backView setBackgroundColor:[UIColor whiteColor]];
                    backView.layer.cornerRadius = 2;
                    backView.layer.masksToBounds = YES;
                    
                    //品牌
                    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, ScreenWidth - 40, 15)];
                    brandLabel.font = [UIFont systemFontOfSize:15];
                    [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                    // brandLabel.numberOfLines = 0;
                    brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQMC"];
                    [backView addSubview:brandLabel];
                    
//最新价
                    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , 43, 42, 14)];
                    dayLabel.text = @"最新价";
                    dayLabel.font = [UIFont systemFontOfSize:14];
                    dayLabel.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:dayLabel];
                    
                    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 43, ScreenWidth/2 - 10 - 55, 14)];
                    dateLabel.text = [NSString stringWithFormat:@"%.2f元",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_ZXJ"] doubleValue]];
                    dateLabel.font = [UIFont systemFontOfSize:14];
                    dateLabel.textColor = [ConMethods colorWithHexString:@"333333"];

                    [backView addSubview:dateLabel];

                    
                    
                    
//最高价
                    UILabel *dayLabelMore = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 43, 42, 14)];
                    dayLabelMore.text = @"最高价";
                    dayLabelMore.font = [UIFont systemFontOfSize:14];
                    dayLabelMore.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:dayLabelMore];
                    
                    UILabel *dateLabelMore = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2  + 45, 43, ScreenWidth/2 - 55, 14)];
                    dateLabelMore.text = [NSString stringWithFormat:@"%.2f元",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_ZGJ"] doubleValue]];
                    dateLabelMore.font = [UIFont systemFontOfSize:14];
                    dateLabelMore.textColor = [ConMethods colorWithHexString:@"333333"];
                    
                    [backView addSubview:dateLabelMore];
                    
                    
//昨收盘
                    UILabel *dayLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 63, 42, 14)];
                    dayLab.text = @"昨收盘";
                    dayLab.font = [UIFont systemFontOfSize:14];
                    dayLab.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:dayLab];
                    
                    
                    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 63, ScreenWidth/2 - 55 , 14)];
                    moneyLabel.text = [NSString stringWithFormat:@"%@元",[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_ZSP"]];
                    moneyLabel.font = [UIFont systemFontOfSize:14];
                    moneyLabel.textColor = [ConMethods colorWithHexString:@"333333"];
                    // moneyLabel.textAlignment = NSTextAlignmentCenter;
                    [backView addSubview:moneyLabel];

 //成交金额
                    UILabel *dayLabelM = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 63, 56, 14)];
                    dayLabelM.text = @"成交金额";
                    dayLabelM.font = [UIFont systemFontOfSize:14];
                    dayLabelM.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:dayLabelM];
                    
                    UILabel *dateLabelM = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 65,63, ScreenWidth/2  - 75, 14)];
                    dateLabelM.text = [NSString stringWithFormat:@"%.2f元",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CJJE"] doubleValue]];
                    dateLabelM.font = [UIFont systemFontOfSize:14];
                    dateLabelM.textColor = [ConMethods colorWithHexString:@"333333"];
                    
                    [backView addSubview:dateLabelM];
                    
 //代码
                    UILabel *codeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 83, 42, 14)];
                    codeLab.text = @"代   码";
                    codeLab.font = [UIFont systemFontOfSize:14];
                    codeLab.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:codeLab];
                    
                    
                    UILabel *moneyLabCode = [[UILabel alloc] initWithFrame:CGRectMake(55, 83, ScreenWidth/2 - 65 , 14)];
                    moneyLabCode.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQDM"]];
                    moneyLabCode.font = [UIFont systemFontOfSize:14];
                    moneyLabCode.textColor = [ConMethods colorWithHexString:@"333333"];
                    // moneyLabel.textAlignment = NSTextAlignmentCenter;
                    [backView addSubview:moneyLabCode];
                    
 //交易模式
                    UILabel *modelLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 83, 56, 14)];
                    modelLab.text = @"交易模式";
                    modelLab.font = [UIFont systemFontOfSize:14];
                    modelLab.textColor = [ConMethods colorWithHexString:@"999999"];
                    [backView addSubview:modelLab];
                    
                    
                    UILabel *moneyLabModel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2 + 60, 83, ScreenWidth/2 - 70 , 14)];
                    moneyLabModel.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_CPID"]];
                    moneyLabModel.font = [UIFont systemFontOfSize:14];
                    moneyLabModel.textColor = [ConMethods colorWithHexString:@"333333"];
                    // moneyLabel.textAlignment = NSTextAlignmentCenter;
                    [backView addSubview:moneyLabModel];
                    
                    [cell.contentView addSubview:backView];
                }
            
           // return cell;
        }
        return cell;
        
    } else if (tablePast == tbleView){
        if ([dataListPast count] == 0) {
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
                [tipLabel setText:@"没有任何商品哦~"];
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
                    brandLabel.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_GQMC"];
                    [backView addSubview:brandLabel];
                    
//持有份额
                    UILabel *fenLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, 52, 13)];
                    fenLabTip.font = [UIFont systemFontOfSize:13];
                    [fenLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    
                    fenLabTip.text = @"持有份额";
                    [backView addSubview:fenLabTip];
                   
                    UILabel *fenLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 42, ScreenWidth/2 - 10 - 65, 13)];
                    fenLabel.font = [UIFont systemFontOfSize:13];
                    [fenLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    fenLabel.text = [NSString stringWithFormat:@"%ld",[[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_JCCL"] integerValue]];
                    [backView addSubview:fenLabel];

//最新价
                    UILabel *newLabTip = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2 - 10, 43, 50, 13)];
                    newLabTip.font = [UIFont systemFontOfSize:13];
                    [newLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    
                    newLabTip.text = @"最新价";
                    [backView addSubview:newLabTip];
                    
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 55 - 10, 42, ScreenWidth/2 - 20 - 45, 13)];
                    newLabel.font = [UIFont systemFontOfSize:13];
                    [newLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    newLabel.text = [NSString stringWithFormat:@"%@元",[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_ZXJ"]];
                    [backView addSubview:newLabel];
                    
//累计盈亏
                    UILabel *kuiLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 63, 52, 13)];
                    kuiLabTip.font = [UIFont systemFontOfSize:13];
                    [kuiLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    
                    kuiLabTip.text = @"累计盈亏";
                    [backView addSubview:kuiLabTip];
                    
                    UILabel *kuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 62, ScreenWidth/2 - 75, 13)];
                    kuiLabel.font = [UIFont systemFontOfSize:13];
                    [kuiLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    kuiLabel.text = [NSString stringWithFormat:@"%@元",[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_LJYK"] ];
                    [backView addSubview:kuiLabel];
//盈亏比例
                    /*
                    UILabel *biliLabTip = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2 - 10, 63, 52, 13)];
                    biliLabTip.font = [UIFont systemFontOfSize:13];
                    [biliLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                    
                    biliLabTip.text = @"盈亏比例";
                    [backView addSubview:biliLabTip];
                    
                    UILabel *biliLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 10 + 55, 62, ScreenWidth/2 - 20 - 45, 13)];
                    biliLabel.font = [UIFont systemFontOfSize:13];
                    [biliLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    
                    float bili = [[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_LJYK"] floatValue]/[[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_TZJE"] floatValue]*100;
                    
                    
                    biliLabel.text = [NSString stringWithFormat:@"%.2f%@",bili,@"%"];
                    [backView addSubview:biliLabel];
                     */
                    [cell.contentView addSubview:backView];
                }
           
        }
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == table) {
        if ([indexPath row] == [dataList count]) {
            return 50;
        } else {
            return 125;
        }
        
    } else if (tableView == tablePast){
        if ([indexPath row] == [dataListPast count]) {
            return 50;
        } else {
            return 105;
        }
    }
    
    return 95;
}

- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.loginUser.count > 0) {
        
        if ([[delegate.loginUser objectForKey:@"success"] boolValue]) {
            if (tbleView == table) {
                
                [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                
                DetailViewController *cv = [[DetailViewController alloc] init];
                //cv.title = [[dataList objectAtIndex:indexPath.row] objectForKey:@"cpmc"];
                cv.gqdm = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_GQDM"];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
                
            }else if (tbleView == tablePast){
                [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                
                TransferDetailViewController *cv = [[TransferDetailViewController alloc] init];
                //cv.title = [[dataList objectAtIndex:indexPath.row] objectForKey:@"cpmc"];
                cv.gqdm = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FID_GQDM"];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
                
            }

        } else {
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        LoginViewController *vc = [[LoginViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}




//请求数据方法
-(void)requestMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
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
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERQueryGqlb] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            if (btnArrayName.count > 0) {
                [btnArrayName removeAllObjects];
            }
            btnArrayName = [responseObject objectForKey:@"object"];
            [self addButClass:[responseObject objectForKey:@"object"]];
            
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

//添加类别按钮
-(void)addButClass:(NSMutableArray *)arr {

    lineView = [[UIView alloc] init];
    lineView.backgroundColor = [ConMethods colorWithHexString:@"c40000"];
    
    if (arr.count <= 3) {
        
        
        for (int i = 0; i < arr.count ; i++){
            float offset = i*ScreenWidth/arr.count;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offset + (ScreenWidth/arr.count - 80)/2, 0, 80, 40)];
            [button setTitle:[[arr objectAtIndex:i] objectForKey:@"FID_GQLBMC"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            
            if (i == btnCount) {
                [button setTitleColor:[ConMethods colorWithHexString:@"c40000"] forState:UIControlStateNormal];
                lineView.frame = CGRectMake(0, 39, button.frame.size.width, 1);
                [button addSubview:lineView];
                
            } else {
                
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            button.tag = i;
            [button addTarget:self action:@selector(taggleMethodsLess:) forControlEvents:UIControlEventTouchUpInside];
            
           
            scroller.contentSize = CGSizeMake(ScreenWidth, 40);
            [btnArray addObject:button];
            [scroller addSubview:button];
        }
        
        [self requestData:[[arr objectAtIndex:0] objectForKey:@"FID_GQLB"]];
    } else {
    

     for (int i = 0; i < arr.count ; i++){
         float offset = i*80;
         UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offset, 0, 80, 40)];
         [button setTitle:[[arr objectAtIndex:i] objectForKey:@"FID_GQLBMC"] forState:UIControlStateNormal];
         button.titleLabel.font = [UIFont systemFontOfSize:15];
         
         if (i == btnCount) {
             [button setTitleColor:[ConMethods colorWithHexString:@"c40000"] forState:UIControlStateNormal];
             lineView.frame = CGRectMake(0, 39, button.frame.size.width, 1);
             [button addSubview:lineView];
             
         } else {
         
         [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         }
         
         button.tag = i;
         [button addTarget:self action:@selector(taggleMethods:) forControlEvents:UIControlEventTouchUpInside];
         
         if (offset + 80 > ScreenWidth) {
             scroller.contentSize = CGSizeMake(offset + 80, 40);
         } else {
             scroller.contentSize = CGSizeMake(ScreenWidth, 40);
         }
         [btnArray addObject:button];
         [scroller addSubview:button];
     }
    
     [self requestData:[[arr objectAtIndex:0] objectForKey:@"FID_GQLB"]];
    }
}


-(void)requestMyGqzcPaging{
    NSLog(@"start = %@",startPast);
    
    NSDictionary *parameters = @{@"pageIndex":startPast,@"pageSize":limitPast};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
     [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERmyGqzcPaging] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedmyGqzcPagingList:[responseObject objectForKey:@"object"]];
            
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




-(void) requestData:(NSString *)str {

    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{@"pageNo":start,@"pageSize":limit,@"gqlb":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
     [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqueryEquityMarket] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
           
            [self recivedCategoryList:[responseObject objectForKey:@"object"]];

        } else {
            
            NSMutableArray *arr = [NSMutableArray array];
            [self recivedCategoryList:arr];
            
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


//处理品牌列表
- (void)recivedmyGqzcPagingList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
    if ([startPast isEqualToString:@"1"]) {
        if (dataListPast.count > 0) {
            [dataListPast removeAllObjects];
        }
        
    }
    
    if(dataListPast){
        
        [dataListPast addObjectsFromArray:[dataArray mutableCopy]];
    } else {
        dataListPast = [dataArray mutableCopy];
    }
    
    [tablePast reloadData];
    
    if ([dataArray count] < 10) {
        hasMorePast = NO;
    } else {
        hasMorePast = YES;
        startPast = [NSString stringWithFormat:@"%d", [startPast intValue] + 1];
    }
    
    if (hasMorePast) {
        if (!_refreshFooterPast) {
            [self setupFooterPast];
        }
    } else {
        [_refreshFooterPast removeFromSuperview];
    }
    
    [tablePast reloadData];
    
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
    
    [table reloadData];
   
}


-(void)taggleMethodsLess:(UIButton *)btn {
    
    UIButton *button = [btnArray objectAtIndex:btnCount];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCount = (int)btn.tag;
    [btn setTitleColor:[ConMethods colorWithHexString:@"c40000"] forState:UIControlStateNormal];
    lineView.frame = CGRectMake(0, 39, btn.frame.size.width, 1);
    [btn addSubview:lineView];
    
    if (dataList.count > 0) {
        [dataList removeAllObjects];
    }
    
    start = @"1";
    
    [self requestData:[[btnArrayName objectAtIndex:btnCount] objectForKey:@"FID_GQLB"]];
}



-(void)taggleMethods:(UIButton *)btn {

    UIButton *button = [btnArray objectAtIndex:btnCount];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCount = (int)btn.tag;
    [btn setTitleColor:[ConMethods colorWithHexString:@"c40000"] forState:UIControlStateNormal];
    lineView.frame = CGRectMake(0, 39, btn.frame.size.width, 1);
    [btn addSubview:lineView];
    
    float desiredX = btnCount*80 + 40 - ScreenWidth/2;
    
    
    if (desiredX < 0) {
        desiredX = 0;
    } else {
    
        float lenth = btnArray.count*80 - btnCount*80 - 80;
        
        if( lenth <= ScreenWidth/2){
             desiredX = btnArray.count*80 - ScreenWidth;
            }
    }
    
    if (ScreenWidth < btnArray.count*80 + 80) {
        [scroller setContentOffset:CGPointMake(desiredX , 0) animated:YES];
        
    }
    
    if (dataList.count > 0) {
        [dataList removeAllObjects];
    }
    
    start = @"1";
    
    [self requestData:[[btnArrayName objectAtIndex:btnCount] objectForKey:@"FID_GQLB"]];
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

-(void)dealloc {
    //[self.refreshHeader removeFromSuperview];
    [self.refreshFooter removeFromSuperview];
    
   // [self.refreshHeaderPast removeFromSuperview];
    [self.refreshFooterPast removeFromSuperview];
    
}

- (IBAction)push:(id)sender {
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
