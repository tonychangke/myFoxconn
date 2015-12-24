//
//  registerViewController.m
//  Login
//
//  Created by localization on 15/9/21.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import "registerViewController.h"
#import "MBProgressHUD.h"

@interface registerViewController()<UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    bool hasLogin;
}
@end

@implementation registerViewController
{
    UIAlertView *Mess;
    MBProgressHUD *HUD;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"正在注册";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.passwordTF resignFirstResponder];
}

-(void)reg
{
    NSString *url = @"http://202.120.36.137:5000/register/";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    if ([self.ID.text length]==0)
    {
        NSLog(self.ID.text,nil);
        Mess=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        Mess.delegate=self;
        [Mess show];

    }
    else
    {
        if(![self.pwd.text isEqualToString:self.confirmPwd.text])
        {
           Mess=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
           Mess.delegate=self;
          [Mess show];
        }
        else
        {
            if(!([self.phoneNum.text length]==11))
            {
                Mess=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"手机号不正确" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                Mess.delegate=self;
                [Mess show];
            }
            else
            {
                NSDictionary *parameters = @{@"userid": self.ID.text,@"passwd":self.pwd.text,@"name":self.name.text,@"usertype":self.type.text,@"mobile":self.phoneNum.text,@"sexual":self.sex.text};

                [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (responseObject) {
                    NSLog(@"%@",responseObject);
                    NSString *tem = responseObject[@"flag"];
                        if ([tem isEqualToString:@"2"]) {
                            Mess=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"用户名已存在" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                            Mess.delegate=self;
                            [Mess show];
                        }
                        if ([tem isEqualToString:@"1"]) {
                            Mess=[[UIAlertView alloc] initWithTitle:@"注册成功" message:@"恭喜" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                            Mess.delegate=self;
                            [Mess show];
                        }
                        if ([tem isEqualToString:@"0"]) {
                            Mess=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"数据库失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                            Mess.delegate=self;
                            [Mess show];                        }
                }
                }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Login error:%@",error);
                    Mess=[[UIAlertView alloc] initWithTitle:@"注册失败" message:@"未知错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    Mess.delegate=self;
                    [Mess show];
                }];
            }
        }
    }
}
- (IBAction)sender:(id)sender {
    [HUD showWhileExecuting:@selector(reg) onTarget:self withObject:nil animated:true];
}

@end
