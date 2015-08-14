//
//  NTContact.h
//  TableView
//
//  Created by MD101 on 14-10-9.
//  Copyright (c) 2014年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTContact : NSObject

#pragma mark 姓
@property (nonatomic ,copy) NSString * firstName;

#pragma mark 名
@property (nonatomic ,copy) NSString * lastName;

#pragma mark 手机号码
@property (nonatomic ,copy) NSString * mobileNumber;


#pragma mark 带参数的构造函数
- (NTContact *)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andMobileNumber:(NSString *)mobileNumber;

#pragma mark 获取姓名
- (NSString *)getName;

#pragma mark 带参数的静态对象初始化方法
+ (NTContact *)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andMobileNumber:(NSString *)mobileNumber;

@end
