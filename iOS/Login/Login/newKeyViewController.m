//
//  newKeyViewController.m
//  Login
//
//  Created by localization on 15/9/22.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import "newKeyViewController.h"
#import "loginAppDelegate.h"
@interface newKeyViewController()<UIGestureRecognizerDelegate>
{
    UIAlertView *mesg;
}

@end

@implementation newKeyViewController
-(void)viewDidLoad{
    self.oldKey=[[UITextField alloc] init];
    self.key=[[UITextField alloc] init];
    self.confirm=[[UITextField alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(void)checkInfo{
    loginAppDelegate *delegate=(loginAppDelegate *)[[UIApplication sharedApplication]delegate];
    if(![self.oldKey.text isEqualToString:delegate.userid])
    {
        mesg=[[UIAlertView alloc] initWithTitle:@"修改密码失败" message:@"原密码不正确" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        mesg.delegate=self;
        [mesg show];
    }
    else
    {
        if(![self.key.text isEqualToString:self.confirm.text])
        {
            mesg=[[UIAlertView alloc] initWithTitle:@"修改密码失败" message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            mesg.delegate=self;
            [mesg show];
        }
        else
        {
            if(self.key.text.length<=6)
            {
                mesg=[[UIAlertView alloc] initWithTitle:@"修改密码失败" message:@"密码不得少于6位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                mesg.delegate=self;
                [mesg show];
            }
            else
            {
                
            }
        }
    }
}

- (IBAction)yes:(id)sender {
    [self checkInfo];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"back2tab"])
    {
        [segue.destinationViewController setSelectedIndex:2];
    }
}

@end
