//
//  settingViewController.m
//  Login
//
//  Created by 常柯 on 15/10/30.
//  Copyright © 2015年 menuz's lab. All rights reserved.
//

#import "settingViewController.h"
#import "loginAppDelegate.h"

@interface settingViewController ()

@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    loginAppDelegate *delegate=(loginAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.username.text=delegate.userid;
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
