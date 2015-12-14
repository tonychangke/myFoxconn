//
//  comWithDB.m
//  Login
//
//  Created by 常柯 on 15/9/21.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import "comWithDB.h"

@implementation comWithDB

- (BOOL) logIn:(NSString *)userid pwd:(NSString *)password{
    NSString *urlString=[NSString stringWithFormat:@"http://202.120.36.137:5000/login/"];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlString]];
    NSString *contentType=[NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"userid=%@&passwd=%@",userid,password]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error=[[NSError alloc]init];
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    return [resDic objectForKey:@"ok"];
}

- (int) reg:(NSString *)userid pwd:(NSString *)password nm:(NSString *) name utp:(int)usertype mbl:(NSString *)mobile sx:(NSString *)sexual {
    NSString *urlString=[NSString stringWithFormat:@"http://202.120.36.137:5000/register/"];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlString]];
    NSString *contentType=[NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"userid=%@&passwd=%@&name=%@&usertype=%d&mobile=%@&sexual=%@",userid,password,name,usertype,mobile,sexual]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error=[[NSError alloc]init];
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *result=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    return [result isEqual:@"2"] ? 2 : ([result isEqual:@"1"] ? 1 : 0);
}


- (NSString *) getFriendList:(NSString *)userid{
    NSString *urlString=[NSString stringWithFormat:@"http://202.120.36.137:5000/req_friend/"];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlString]];
    NSString *contentType=[NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"userid=%@",userid]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error=[[NSError alloc]init];
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *result=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    return result;
}

-(NSString *)getMap:(NSInteger)mapid{
    NSString *urlString=[NSString stringWithFormat:@"http://202.120.36.137:5000/req_map/"];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlString]];
    NSString *contentType=[NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"mapid=%ld",mapid]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error=[[NSError alloc]init];
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *result=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    return result;
}

-(NSDictionary *)getFriendPosition:(NSString *)userid fi:(NSString *)friendid{
    NSString *urlString=[NSString stringWithFormat:@"http://202.120.36.137:5000/login/"];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlString]];
    NSString *contentType=[NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"userid=%@&friendid=%@",userid,friendid]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error=[[NSError alloc]init];
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    return resDic;
}


@end
