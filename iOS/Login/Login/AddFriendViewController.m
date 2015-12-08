//
//  AddFriendViewController.m
//  Login
//
//  Created by 常柯 on 15/10/5.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import "AddFriendViewController.h"
#import "comWithDB.h"

@interface AddFriendViewController ()
@property (strong, nonatomic) IBOutlet UITextField *friendid;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"back2tab"])
    {
        [segue.destinationViewController setSelectedIndex:1];
    }
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
