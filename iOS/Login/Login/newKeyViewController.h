//
//  newKeyViewController.h
//  Login
//
//  Created by localization on 15/9/22.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newKeyViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *oldKey;
@property (strong, nonatomic) IBOutlet UITextField *key;
@property (strong, nonatomic) IBOutlet UITextField *confirm;
- (IBAction)yes:(id)sender;



@end
