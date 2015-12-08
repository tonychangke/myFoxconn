//
//  loginViewController.m
//  Login
//
//  Created by menuz on 14-2-23.
//  Copyright (c) 2014年 menuz's lab. All rights reserved.
//

#import "loginViewController.h"
#import "MBProgressHUD.h"
#import "comWithDB.h"
#import "loginAppDelegate.h"


@interface loginViewController()<MBProgressHUDDelegate,UIGestureRecognizerDelegate>
{
    bool hasLogin;
}
@end

@implementation loginViewController
{
    MBProgressHUD *HUD;
    UIAlertView *ErrorMess;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
    HUD.delegate = self;
	HUD.labelText = @"正在登录";
    
    // tap for dismissing keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    //Massagebox show when error loading.
    ErrorMess=[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    ErrorMess.delegate=self;
    
    //Get current path and then create data file named "database".
    self->hasLogin=FALSE;

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
    [HUD showWhileExecuting:@selector(loginWithUsername) onTarget:self withObject:nil animated:TRUE];
}


// Verifying.
-(void)loginWithUsername
{
//    loginAppDelegate *delegate=(loginAppDelegate *)[[UIApplication sharedApplication]delegate];
//    comWithDB *communicator=[comWithDB alloc];
//    if ([communicator logIn:self.usernameTF.text pwd:self.passwordTF.text]) {
//        delegate.userid=self.usernameTF.text;
//        delegate.passwd=self.passwordTF.text;
          [self  performSelectorOnMainThread:@selector(goToMainView) withObject:nil waitUntilDone:FALSE];
//    }
//    else [ErrorMess show];
}

//Login in successfully.
-(void) goToMainView {
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

@end
