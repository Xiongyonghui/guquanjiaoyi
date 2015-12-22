//
//  AppDelegate.m
//  EquityTrading
//
//  Created by mac on 15/10/27.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MyViewController.h"
#import "MoreViewController.h"
#import "CPVTabViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _loginUser = [NSMutableDictionary dictionary];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    [self initTabBarControllerUI];
    [_window makeKeyAndVisible];
    return YES;
}

-(void)initTabBarControllerUI{
    _tabBarController = [[CPVTabViewController alloc] init];
    
    MainViewController *fisrtVC = [[MainViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:fisrtVC];
    nav1.delegate = self;
    MyViewController *tranferVC = [[MyViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:tranferVC];
    nav3.delegate = self;
    MoreViewController *myVC = [[MoreViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:myVC];
    nav4.delegate = self;
     _tabBarController.viewControllers =[[NSArray alloc] initWithObjects:nav1,nav3,nav4, nil];
    
   // _tabBarController.viewControllers =[[NSArray alloc] initWithObjects:fisrtVC,proVC,myVC,tranferVC, nil];
    
    NSArray *tbNormalArray = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"]];
    [_tabBarController setTabBarItemsImage:tbNormalArray];
    
    NSArray *tbHighlightArray = @[[UIImage imageNamed:@"11"],[UIImage imageNamed:@"22"],[UIImage imageNamed:@"33"]];
    [_tabBarController setItemSelectedImages:tbHighlightArray];
    
    NSMutableArray *txtArr=[NSMutableArray arrayWithObjects:@"首页",@"我的资产",@"更多",nil];
    
    [self.tabBarController setTabBarItemsTitle:txtArr];
    self.tabBarController.delegate = (id <UITabBarControllerDelegate>)self;
    
    [_tabBarController.tabBar setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    //[_tabBarController.tabBar setTintColor:[ConMethods colorWithHexString:@"fe8103"]];
    [_tabBarController.tabBar setTintColor:[ConMethods colorWithHexString:@"c40000"]];
    
    self.window.rootViewController = _tabBarController;
}


#pragma mark - UINavigationController Delegate Methods
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.navigationBarHidden = YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
