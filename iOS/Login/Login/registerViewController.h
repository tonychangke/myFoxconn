//
//  registerViewController.h
//  Login
//
//  Created by localization on 15/9/21.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface registerViewController : UIViewController
- (IBAction)sender:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *ID;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *sex;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *type;
@property (strong, nonatomic) IBOutlet UITextField *pwd;
@property (strong, nonatomic) IBOutlet UITextField *confirmPwd;

//@property (strong, nonatomic) comWithDB *DB;
@end
