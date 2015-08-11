//
//  loginViewController.m
//  Login
//
//  Created by menuz on 14-2-23.
//  Copyright (c) 2014年 menuz's lab. All rights reserved.
//

#import "loginViewController.h"
#import "MBProgressHUD.h"

@interface loginViewController ()

@end

@implementation loginViewController {
        MBProgressHUD *HUD;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
    //	HUD.delegate = self;
	HUD.labelText = @"登录中...";
    
    
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // very important make delegate useful
    tap.delegate = self;
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self.passwordTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Login:(id)sender {
    // MBProgressHUD后台新建子线程执行任务
    [HUD showWhileExecuting:@selector(loginUser) onTarget:self withObject:nil animated:NO];
}

// 子线程中
-(void) loginUser {
    // 显示进度条
    sleep(3);
    
    // 返回主线程执行
    [self  performSelectorOnMainThread:@selector(goToMainView) withObject:nil waitUntilDone:FALSE];
}

// 服务器交互进行用户名，密码认证
-(BOOL)loginWithUsername:(NSString *)username Password:(NSString *)password {
    return true;
}

-(void) goToMainView {
        [self performSegueWithIdentifier:@"GoToMainViewSegue" sender:self];
}

@end
