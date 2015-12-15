//
//  comWithDB.h
//  Login
//
//  Created by 常柯 on 15/9/21.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface comWithDB : NSObject

-(void)nothing;
- (BOOL) logIn:(NSString *)userid pwd:(NSString *)password;
- (int) reg:(NSString *)userid pwd:(NSString *)password nm:(NSString *) name utp:(NSString *)usertype mbl:(NSString *)mobile sx:(NSString *)sexual;
-(NSString *)getMap:(NSInteger)mapid;
-(NSDictionary *)getFriendPosition:(NSString *)userid fi:(NSString *)friendid;
-(NSString *)addFriend:(NSString *)userid fi:(NSString *)friendid;

@end
