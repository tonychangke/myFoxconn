//
//  loginViewController.m
//  Login
//
//  Created by menuz on 14-2-23.
//  Copyright (c) 2014年 menuz's lab. All rights reserved.
//

#import "loginViewController.h"
#import "MBProgressHUD.h"
#import "loginAppDelegate.h"
#import "AFNetworking.h"


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
    //ErrorMess=[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    //ErrorMess.delegate=self;
    
    //Get current path and then create data file named "database".
    self->hasLogin=FALSE;

}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.passwordTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Login:(id)sender {
    [HUD showWhileExecuting:@selector(logIn) onTarget:self withObject:nil animated:TRUE];
}

- (void ) logIn{
    NSString *url = @"http://202.120.36.137:5000/login/";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSDictionary *parameters = @{@"userid": self.usernameTF.text,@"passwd":self.passwordTF.text};
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"hi");
        NSString *result=[operation responseString];
        if([result isEqualToString:@"0"]){
            loginAppDelegate *delegate=(loginAppDelegate *)[[UIApplication sharedApplication]delegate];
            delegate.userid=self.usernameTF.text;
            delegate.passwd=self.passwordTF.text;
            [self goToMainView];
            
        }
        else {
            ErrorMess=[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            ErrorMess.delegate=self;
            [ErrorMess show];
      //  loginAppDelegate *delegate=(loginAppDelegate *)[[UIApplication sharedApplication]delegate];
       // delegate.userid=self.usernameTF.text;
       // delegate.passwd=self.passwordTF.text;
            [self goToMainView];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ErrorMess=[[UIAlertView alloc] initWithTitle:@"登录失败" message:@"未知服务器错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        ErrorMess.delegate=self;
       // NSLog(@"here");
        [self goToMainView];        //NSLog(@"Login error:%@",error);
    }];
}

//Login in successfully.
-(void) goToMainView {
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

@end
