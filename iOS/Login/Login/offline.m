////
////  offline.m
////  BLEoffline
////
////  Created by whathexd on 15/10/2.
////  Copyright (c) 2015年 whathexd. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "offline.h"
//#import "RSSModel.h"
//#import <math.h>
//
//
//@interface OffLine()
////@property (nonatomic) NSInteger Num;
////@property (strong, nonatomic) NSMutableArray *x;
////@property (strong, nonatomic) NSMutableArray *y;
////@property (strong, nonatomic) NSMutableArray *distance;
////@property (strong, nonatomic) NSMutableArray *theta;
////@property (strong, nonatomic) NSMutableArray *grad;
//@end
//
//@implementation OffLine
//
////- (NSMutableArray *)x {
////    if (!_x)
////        _x = [[NSMutableArray alloc] init];
////    return _x;
////}
////
////- (NSMutableArray *)y {
////    if (!_y)
////        _y = [[NSMutableArray alloc] init];
////    return _y;
////}
////
////- (NSMutableArray *)distance {
////    if (!_distance)
////        _distance = [[NSMutableArray alloc] init];
////    return _distance;
////}
////
////- (NSMutableArray *)theta {
////    if (!_theta)
////        _theta = [[NSMutableArray alloc] init];
////    return _theta;
////}
////
////- (NSMutableArray *)grad {
////    if (!_grad)
////        _grad = [[NSMutableArray alloc] init];
////    return _grad;
////}
//
//    
//
//    
//
//-(void)thetarandom:(NSMutableArray *) distance APx:(NSMutableArray *) xx APy:(NSMutableArray *) yy APnum:(NSInteger) num{
//    
////    double var1=((double)arc4random() / ARC4RANDOM_MAX); //大于0.0小于1.0的伪随机double值
////    NSNumber *obj1 =[NSNumber numberWithDouble:var1];
////    [self.theta insertObject:obj1 atIndex:0];
////    double var2= ((double)arc4random() / ARC4RANDOM_MAX);
////    NSNumber *obj2 =[NSNumber numberWithDouble:var2];
////    [self.theta insertObject:obj2 atIndex:1];
////    self.distance=distance;
////    self.x=xx;
////    self.y=yy;
////    [self Decent];
//
//
//}
//
//-(void) gradient{
//    NSMutableArray *xnum=[[NSMutableArray alloc]init];
//    NSMutableArray *ynum=[[NSMutableArray alloc]init];
//    double lambda=0.1;
//    NSNumber *g1 = @0;
//    [self.grad addObject:g1];
//    [self.grad insertObject:g1 atIndex:0];
//    [self.grad insertObject:g1 atIndex:1];
//
//
//
//    
//    //for(int i=0;i<[self.distance count];i++)
//    for(int i=0;i<1;i++)
//    {   float thetanum0=[self.theta[0] floatValue];
//        float xnum=[self.x[i] floatValue];
//        
//        float thetanum1=[self.theta[1] floatValue];
//        float ynum=[self.y[i] floatValue];
//        
//        float gradnum0=[self.grad[0] floatValue];
//        float gradnum1=[self.grad[1] floatValue];
//        float distancenum=[self.distance[i] floatValue];
//        
//    
//        double tmp=pow(thetanum0-xnum, 2) +pow(thetanum1-ynum, 2);
//        double h=sqrt(tmp);
//        gradnum0+=2*(h-distancenum)/h*(thetanum0-xnum);
//        gradnum1+=2*(h-distancenum)/h*(thetanum0-ynum);
//        
//        
//        
//    
//        self.theta[0] = [NSNumber numberWithFloat:thetanum0];
//        self.x[i] = [NSNumber numberWithFloat:xnum];
//        self.theta[1]=[NSNumber numberWithFloat:thetanum1];
//        self.y[i]=[NSNumber numberWithFloat:ynum];
//        
//        self.grad[0]=[NSNumber numberWithFloat:gradnum0];
//        self.grad[1]=[NSNumber numberWithFloat:gradnum1];
//        self.distance[i]=[NSNumber numberWithFloat:distancenum];
//
//        
//        
//}
//    
//    self.theta[0] = [NSNumber numberWithFloat:[self.theta[0] floatValue] - (lambda/self.Num * [self.grad[0] floatValue])];
//    self.theta[1] = [NSNumber numberWithFloat:[self.theta[1] floatValue] - (lambda/self.Num * [self.grad[1] floatValue])];
//    
//    
//}
//
//-(void) Decent{
//    for(int i=0;i<50;i++)
//        [self gradient];
//    NSLog(@"theta");
//    NSLog(@"%@",self.theta);
//    
//    
//}
//
//
//@end
