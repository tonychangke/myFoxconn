//
//  drawLineView.h
//  Login
//
//  Created by 常柯 on 15/10/20.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface drawLineView : UIView
@property  (strong, nonatomic)NSMutableArray *points;
@property CGPoint  initPoint;
@property int length;
@end
