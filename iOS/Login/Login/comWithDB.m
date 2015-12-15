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

- (int) reg:(NSString *)userid pwd:(NSString *)password nm:(NSString *) name utp:(NSString *)usertype mbl:(NSString *)mobile sx:(NSString *)sexual {
    NSString *urlString=[NSString stringWithFormat:@"http://202.120.36.137:5000/register/"];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlString]];
    NSString *contentType=[NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"userid=%@&passwd=%@&name=%@&usertype=%@&mobile=%@&sexual=%@",userid,password,name,usertype,mobile,sexual]dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error=[[NSError alloc]init];
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *result=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    return [result isEqual:@"2"] ? 2 : ([result isEqual:@"1"] ? 1 : 0);
}

- (void) processResponse: (NSString*) responseString
{
    NSLog(@"response string %@", responseString);
    NSData *data= [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError = nil;
//options:NSJSONReadingAllowFragments error:&jsonError];
   // NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    //code =  (int)[[dict objectForKey:@"code"] intValue];
    //msg = (NSString*)[dict objectForKey:@"code"];
    
}

- (void ) getFriendList:(NSString *)userid{

    NSString *url = @"http://202.120.36.137:5000/req_friend/";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
       [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    NSDictionary *parameters = @{@"userid": userid};

   
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [operation responseString];
        NSLog(@"response string %@", responseString);       // [self processResponse:responseString]; //the call to my function
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *responseString = [operation responseString];
            NSLog(@"%@", responseString);
               //NSLog(@"Error: %@", error);

        //NSLog(@"HTTP Processing error: %@", error); //this error is triggered
    }];
}

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];
//    NSDictionary *params = @{@"userid":@"t"};
//    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
//    [manager POST:@"http://202.120.36.137:5000/req_friend/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//            //NSString *string=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//           // NSLog(@"%@",string);
//        
//        
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
//    NSString *urlString=[NSString stringWithFormat:@"http://202.120.36.137:5000/req_friend/"];
//    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    NSString *contentType=[NSString stringWithFormat:@"text/html"];
//    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    
//    
//    
//    NSDictionary *mydic=[[NSDictionary alloc]initWithObjectsAndKeys:@"userid",@"test1", nil];
//    NSData *myjsondata=[NSJSONSerialization dataWithJSONObject:mydic options:NSJSONWritingPrettyPrinted error:nil];
//    //[postBody appendData:[[NSString stringWithFormat:@"userid=%@",userid]dataUsingEncoding:NSUTF8StringEncoding]];
//    NSMutableData *postBody=[NSMutableData dataWithData:myjsondata];
//    [request setHTTPBody:postBody];
//    [request setHTTPMethod:@"POST"];
//    
//    NSHTTPURLResponse *urlResponse = nil;
//    NSError *error=[[NSError alloc]init];
//    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    
//    NSString *result=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(result,nil);
//}

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
