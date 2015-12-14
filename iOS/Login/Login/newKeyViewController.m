//
//  newKeyViewController.m
//  Login
//
//  Created by localization on 15/9/22.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import "newKeyViewController.h"

@implementation newKeyViewController
-(void)viewDidLoad{
    self.oldKey=[[UITextField alloc] init];
    self.key=[[UITextField alloc] init];
    self.confirm=[[UITextField alloc] init];
}

- (IBAction)yes:(id)sender {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"back3tab"])
    {
        [segue.destinationViewController setSelectedIndex:2];
    }
}

@end
