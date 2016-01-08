//
//  InfoPersonlViewController.h
//  EquityTrading
//
//  Created by 熊永辉 on 16/1/6.
//  Copyright © 2016年 ApexSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPersonlViewController : UIViewController
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *userNum;
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
