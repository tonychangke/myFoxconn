//
//  AddFriendViewController.m
//  Login
//
//  Created by 常柯 on 15/10/5.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AFNetworking.h"
#import "loginAppDelegate.h"

@interface AddFriendViewController ()<UIGestureRecognizerDelegate>


@end

@implementation AddFriendViewController
{
    UIAlertView *Mess;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
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

- (IBAction)addFriend:(id)sender {
    NSString *url = @"http://202.120.36.137:5000/add_friend_by_userid/";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    loginAppDelegate *delegate=(loginAppDelegate *)[[UIApplication sharedApplication]delegate];
    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSDictionary *parameters = @{@"userid": delegate.userid,@"friendid":self.friendid.text};
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=[operation responseString];
        NSLog(result,nil);
        if([result isEqualToString:@"0"]){
            Mess=[[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            Mess.delegate=self;
            [Mess show];
        }
        if([result isEqualToString:@"1"]){
            Mess=[[UIAlertView alloc]initWithTitle:@"提示" message:@"该用户不存在" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [Mess show];
        }
        if([result isEqualToString:@"2"]){
            Mess=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你们已经是好友了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [Mess show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Mess=[[UIAlertView alloc]initWithTitle:@"警告" message:@"未知错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [Mess show];
    }];
}
@end
