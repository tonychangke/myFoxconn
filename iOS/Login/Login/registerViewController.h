//
//  registerViewController.h
//  Login
//
//  Created by localization on 15/9/21.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "comWithDB.h"
@interface registerViewController : UIViewController
- (IBAction)sender:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *ID;
@property (strong, nonatomic) IBOutlet UITextField *nick;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirm;
@property (strong, nonatomic) comWithDB *DB;
@end
