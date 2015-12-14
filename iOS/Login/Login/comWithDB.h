//
//  comWithDB.h
//  Login
//
//  Created by 常柯 on 15/9/21.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface comWithDB : NSURL{
}
- (BOOL) logIn:(NSString *)userid pwd:(NSString *)password;
- (int) reg:(NSString *)userid pwd:(NSString *)password nm:(NSString *) name utp:(int)usertype mbl:(NSString *)mobile sx:(NSString *)sexual;
- (NSString *) getFriendList:(NSString *)userid;
-(NSString *)getMap:(NSInteger)mapid;
-(NSDictionary *)getFriendPosition:(NSString *)userid fi:(NSString *)friendid;
@end
