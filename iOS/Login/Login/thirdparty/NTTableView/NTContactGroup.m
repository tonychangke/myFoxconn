//
//  NTContactGroup.m
//  TableView
//
//  Created by MD101 on 14-10-9.
//  Copyright (c) 2014年 NT. All rights reserved.
//

#import "NTContactGroup.h"

@implementation NTContactGroup

-(NTContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts{

    if (self = [super init]) {
        self.groupName = name;
        self.groupDetail = detail;
        self.contacts = contacts;
    }
    
    return self;
}


+(NTContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts{

    NTContactGroup * contactGroup = [[NTContactGroup alloc]initWithName:name andDetail:detail andContacts:contacts];
    
    return contactGroup;

}

@end
