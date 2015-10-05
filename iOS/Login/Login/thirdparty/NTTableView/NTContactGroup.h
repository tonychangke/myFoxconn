//
//  NTContactGroup.h
//  TableView
//
//  Created by MD101 on 14-10-9.
//  Copyright (c) 2014年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTContactGroup : NSObject

#pragma mark 组名称
@property (nonatomic ,copy) NSString * groupName;

#pragma mark 分组描述
@property (nonatomic ,copy) NSString * groupDetail;

#pragma mark 联系人
@property (nonatomic ,strong) NSMutableArray * contacts;


#pragma mark 构造函数
- (NTContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts;

#pragma mark 静态初始化
+ (NTContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts;

@end
