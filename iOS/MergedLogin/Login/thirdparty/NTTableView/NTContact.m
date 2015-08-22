//
//  NTContact.m
//  TableView
//
//  Created by MD101 on 14-10-9.
//  Copyright (c) 2014年 NT. All rights reserved.
//

#import "NTContact.h"

@implementation NTContact

- (NTContact *)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andMobileNumber:(NSString *)mobileNumber{

    if (self = [super init]) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.mobileNumber = mobileNumber;
    }
    
    return self;
}

- (NSString *)getName{

    return [NSString stringWithFormat:@"%@  %@",_firstName,_lastName];
    
}

+ (NTContact *)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andMobileNumber:(NSString *)mobileNumber{

    NTContact * contact = [[NTContact alloc]initWithFirstName:firstName andLastName:lastName andMobileNumber:mobileNumber];
    
    return contact;
}

@end
