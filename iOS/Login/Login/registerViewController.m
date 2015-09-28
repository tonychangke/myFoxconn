//
//  registerViewController.m
//  Login
//
//  Created by localization on 15/9/21.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import "registerViewController.h"


@implementation registerViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ID=[[UITextField alloc] init];
    self.nick=[[UITextField alloc] init];
    self.phone=[[UITextField alloc] init];
    self.password=[[UITextField alloc] init];
    self.confirm=[[UITextField alloc] init];

    
    
    
}

//- (IBAction)sender:(id)sender {
//    comWithDB * DB = [[comWithDB alloc ]init];
//    [DB reg:self.ID,pwd:self.password,nm:self.nick,utp:1,mbl:self.phone,sx:'m'];
//}

@end
