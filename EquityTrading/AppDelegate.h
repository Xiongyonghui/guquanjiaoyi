//
//  AppDelegate.h
//  EquityTrading
//
//  Created by mac on 15/10/27.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareMyData.h"
#import "ConMethods.h"
#import "PublicMethod.h"
#import "AFNetworking.h"
#import "HttpMethods.h"
#import "OpenUDID.h"
#import "Base64XD.h"
#import "NetWork.h"
#import "SDRefresh.h"

@class CPVTabViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)CPVTabViewController *tabBarController;
@property (strong, nonatomic) NSMutableDictionary *loginUser;
@property (strong, nonatomic) NSString *loginStr;

@end

