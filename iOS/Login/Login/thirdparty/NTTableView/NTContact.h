//
//  NTContact.h
//  TableView
//
//  Created by MD101 on 14-10-9.
//  Copyright (c) 2014年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTContact : NSObject

//#pragma mark 姓
//@property (nonatomic ,copy) NSString * firstName;

#pragma mark 名
@property (nonatomic ,copy) NSString * Name;

#pragma mark 用户名
@property (nonatomic ,copy) NSString * userid;


#pragma mark 带参数的构造函数
- (NTContact *)initWithName:(NSString *)Name andUserid:(NSString *)userid;

#pragma mark 获取姓名
- (NSString *)getName;

#pragma mark 带参数的静态对象初始化方法
+ (NTContact *)initWithName:(NSString *)Name andUserid:(NSString *)userid;

@end
