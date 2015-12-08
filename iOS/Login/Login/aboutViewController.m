//
//  aboutViewController.m
//  Login
//
//  Created by localization on 15/10/23.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import "aboutViewController.h"

@implementation aboutViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"back4tab"])
    {
        [segue.destinationViewController setSelectedIndex:2];
    }
}

@end
