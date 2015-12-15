//
//  newTabBarViewController.m
//  Login
//
//  Created by 常柯 on 15/12/15.
//  Copyright © 2015年 menuz's lab. All rights reserved.
//

#import "newTabBarViewController.h"

@interface newTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation newTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MapViewController *mapView=[[MapViewController alloc]init];
    UINavigationController *mapNavigation=[[UINavigationController alloc]initWithRootViewController:mapView];
    ContactViewController *contactView=[[ContactViewController alloc]init];
    UINavigationController *contactNavigation=[[UINavigationController alloc]initWithRootViewController:contactView];
    settingViewController *settingView=[[settingViewController alloc]init];
    UINavigationController *settingNavigation=[[UINavigationController alloc]initWithRootViewController:settingView];
    
   // UITabBarController *tabBarController=[[UITabBarController alloc]init];
   // tabBarController.delegate=self;
    //tabBarController.viewControllers =[[NSArray alloc]initWithObjects:mapNavigation,contactNavigation,settingNavigation, nil];
    
    self.viewControllers=[[NSArray alloc]initWithObjects:mapNavigation,contactNavigation,settingNavigation, nil];
    UITabBar *tabBar=self.tabBar;
    UITabBarItem *MapItem=[tabBar.items objectAtIndex:0];
    UITabBarItem *ContactItem=[tabBar.items objectAtIndex:1];
    UITabBarItem *settingItem=[tabBar.items objectAtIndex:2];
    MapItem.title = @"地图";
    ContactItem.title = @"联系人";
    settingItem.title = @"设置";
    
    //self.window.rootViewController = tabBarController;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
