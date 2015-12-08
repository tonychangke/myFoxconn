//
//  NTContact.m
//  TableView
//
//  Created by MD101 on 14-10-9.
//  Copyright (c) 2014年 NT. All rights reserved.
//

#import "NTContact.h"

@implementation NTContact

- (NTContact *)initWithName:(NSString *)Name andUserid:(NSString *)userid{

    if (self = [super init]) {
        self.Name = Name;
        self.userid = userid;
    }
    
    return self;
}

- (NSString *)getName{

    return [NSString stringWithFormat:@"%@",_Name];
    
}

+ (NTContact *)initWithName:(NSString *)Name andUserid:(NSString *)userid{

    NTContact * contact = [[NTContact alloc]initWithName:Name andUserid:userid];
    
    return contact;
}

@end
