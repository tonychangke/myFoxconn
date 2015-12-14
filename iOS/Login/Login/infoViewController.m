//
//  infoViewController.m
//  Login
//
//  Created by localization on 15/9/21.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "infoViewController.h"
#import "registerViewController.h"
#import "TBController.h"

@implementation infoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    ////self.name.text=registerViewController.nick;
    //self.phone.text=registerViewController.phone;
    //self.ID.text=registerViewController.;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"back2tab"])
    {
       [segue.destinationViewController setSelectedIndex:2];
    }
}


@end
