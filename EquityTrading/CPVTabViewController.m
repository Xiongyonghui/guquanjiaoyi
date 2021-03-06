//
//  CPVTabViewController.m
//  TABBarTest
//
//  Created by mac on 15/9/1.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "CPVTabViewController.h"

@interface CPVTabViewController ()

@end

@implementation CPVTabViewController

- (id)init {
    self = [super init];
    if (self) {
        
        if (_badgeValueImage == nil) {
            _badgeValueImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_warning.png"]];
            _badgeValueImage.hidden = YES;
            [self.tabBar addSubview:_badgeValueImage];
        }
        
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - OverRide Super Class
- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    
}

#pragma mark - Setter for Items Title

 - (void)setTabBarItemsTitle:(NSArray *)titles
 {
 for (int i = 0; i < self.tabBar.items.count && i < titles.count; ++i)
 {
 UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
     tabBarItem.title = [titles objectAtIndex:i];
 }
 }

#pragma mark - Setter for Items Image

 - (void)setTabBarItemsImage:(NSArray *)images
 {
 for (int i = 0; i < self.tabBar.items.count && i < images.count; ++i) {
     UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
 tabBarItem.image = [[images objectAtIndex:i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 }
 }

- (void)setTabBarBackgroundImage:(UIImage *)image
{
    self.tabBar.backgroundImage = image;
}


- (void)setItemSelectedImages:(NSArray *)selectedImages
{
    for (int i = 0; i < selectedImages.count; ++i) {
        UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:i];
        tabBarItem.selectedImage = [[selectedImages objectAtIndex:i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       
    }
}



- (void)showBadge
{
    NSInteger imageCount = self.tabBarController.viewControllers.count;
    CGFloat cellWidth = self.tabBar.frame.size.width / imageCount;
    CGFloat xOffest = self.tabBar.frame.size.width - cellWidth/2.0 + 8.0f;
    _badgeValueImage.frame = CGRectMake( xOffest, 8.0f, 8.0f, 8.0f);
    _badgeValueImage.hidden = NO;
    
}

- (void)hiddenBadge
{
    _badgeValueImage.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
