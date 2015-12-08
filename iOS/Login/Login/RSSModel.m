//
//  RSSModel.m
//  BLEoffline
//
//  Created by whathexd on 15/10/7.
//  Copyright (c) 2015年 whathexd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSModel.h"
#import "offline.h"
#import <math.h>

@interface RSSModel()
//@property (strong, nonatomic) NSMutableArray *APposX;
//@property (strong, nonatomic) NSMutableArray *APposY;
//@property (nonatomic) NSInteger numOfAP;
//@property (strong, nonatomic) NSNumber* UserX;
//@property (strong, nonatomic) NSNumber* UserY;
//@property (strong, nonatomic) NSMutableArray *standardRSS;
//@property (strong, nonatomic) NSMutableArray *distance;
//@property (strong, nonatomic) NSMutableArray *RSS_receive;
//@property (strong, nonatomic) NSMutableArray *RSS_distance;

@end

@implementation RSSModel

//-(NSMutableArray *)APposX {
//    if (!_APposX)
//        
//        _APposX = [[NSMutableArray alloc] init];
//    return _APposX;
//    
//}
//
//-(NSMutableArray *)APposY {
//    if (!_APposY)
//        
//        _APposY = [[NSMutableArray alloc] init];
//    return _APposY;
//    
//}
//
//-(NSMutableArray *)standardRSS {
//    if (!_standardRSS)
//        
//        _standardRSS = [[NSMutableArray alloc] init];
//    return _standardRSS;
//    
//}
//
//-(NSMutableArray *)distance {
//    if (!_distance)
//        
//        _distance = [[NSMutableArray alloc] init];
//    return _distance;

//}

//-(NSMutableArray *)RSS_receive {
//    if (!_RSS_receive)
//        
//        _RSS_receive = [[NSMutableArray alloc] init];
//    return _RSS_receive;
//    
//}



-(void) rssInput:(NSMutableArray *)RSSreceive
{
      NSInteger i;
//    double X;
//    double Y;
//    double currentDistance;
//    self.numOfAP= num;
    
    
//    for (i=0;i<self.numOfAP;i++)
//    {   self.APposX[i]=APx[i];
//        self.APposY[i]=APy[i];
//        X= [self.APposX[i] floatValue]-[posX floatValue];
//        Y= [self.APposY[i] floatValue]-[posY floatValue];
//        currentDistance =sqrt(X*X+Y*Y);
//        float distancenum=[self.distance[i] floatValue];
//        float standardRSSnum=[self.standardRSS[i] floatValue];
//        distancenum=currentDistance;
//        standardRSSnum=-(double)60 -(double)20 *log(currentDistance/log((double)10));
//        
//        self.distance[i]=[NSNumber numberWithFloat:distancenum];
//        self.standardRSS[i]=[NSNumber numberWithFloat:standardRSSnum];
//        
//    }
    NSMutableArray *RSSdistance=[[NSMutableArray alloc]init];

    for(i=0;i<[RSSreceive count];i++)
    {   float rssreceivenum=[RSSreceive[i] floatValue];
        //float rssdistancenum=[RSSdistance[i] floatValue];
        //float standardRSSnum=[self.standardRSS[i] floatValue];
        
        
        //double u1 = (double)arc4random() / UINT32_MAX; // uniform distribution
        //double u2 = (double)arc4random() / UINT32_MAX; // uniform distribution
        //double f1 = sqrt(-2 * log(u1));
        //double f2 = 2 * M_PI * u2;
        //double g1 = f1 * cos(f2); // gaussian distribution
        //double g2 = f1 * sin(f2); // gaussian distribution
        
        //rssreceivenum=standardRSSnum;
        float rssdistancenum;
        rssdistancenum=pow(10,((rssreceivenum+(double)80)/(-(double)20)));//core用接收到的rss算距离distance
   
        //RSSreceive[i]=[NSNumber numberWithFloat:rssreceivenum];
        RSSdistance[i]=[NSNumber numberWithFloat:rssdistancenum];  //传到offline.m中的距离数组
        //self.standardRSS[i]=[NSNumber numberWithFloat:standardRSSnum];
    }
    //NSLog(@"%@","123");
    //NSLog(@"%@",self.distance);
    //NSLog(@"%@",self.standardRSS);
    //NSLog(@"%@",self.RSS_distance);
    //OffLine *offline = [[OffLine alloc] init];
    NSMutableArray * a1;//a1为各个ap的横坐标
    NSMutableArray * a2;//a2为各个ap的纵坐标
    a1 = [[NSMutableArray alloc] init];
    a2 = [[NSMutableArray alloc] init];
    
    [a1 addObject:@"0"];
    [a2 addObject:@"0"];
    
    NSMutableArray * theta;
    theta = [[NSMutableArray alloc] init];
    double var1=((double)arc4random() / ARC4RANDOM_MAX); //大于0.0小于1.0的伪随机double值
    NSNumber *obj1 =[NSNumber numberWithDouble:var1];
    [theta insertObject:obj1 atIndex:0];
    double var2= ((double)arc4random() / ARC4RANDOM_MAX);
    NSNumber *obj2 =[NSNumber numberWithDouble:var2];
    [theta insertObject:obj2 atIndex:1];
    
    [self Decent:theta APx:a1 APy:a2 RSSdistance:RSSdistance];
    
    //[offline thetarandom:RSSdistance APx:a1 APy:a2 APnum:2];
    //NSLog(@"RSSdistance");
    //NSLog(@"%@",RSSdistance);




}
-(void) gradient:(NSMutableArray *) theta APx:(NSMutableArray *)x APy:(NSMutableArray *)y RSSdistance:(NSMutableArray *)distance {
    //NSMutableArray *xnum=[[NSMutableArray alloc]init];
    //NSMutableArray *ynum=[[NSMutableArray alloc]init];
    double lambda=0.1;
    NSNumber *g1 = @0;
    NSMutableArray *grad=[[NSMutableArray alloc]init ];
    [grad addObject:g1];
    [grad insertObject:g1 atIndex:0];
    [grad insertObject:g1 atIndex:1];
    
    
    
    
    //for(int i=0;i<[self.distance count];i++)
    for(int i=0;i<1;i++)
    {   float thetanum0=[theta[0] floatValue];
        float xnum=[x[i] floatValue];
        
        float thetanum1=[theta[1] floatValue];
        float ynum=[y[i] floatValue];
        
        float gradnum0=[grad[0] floatValue];
        float gradnum1=[grad[1] floatValue];
        float distancenum=[distance[i] floatValue];
        
        
        double tmp=pow(thetanum0-xnum, 2) +pow(thetanum1-ynum, 2);
        double h=sqrt(tmp);
        gradnum0+=2*(h-distancenum)/h*(thetanum0-xnum);
        gradnum1+=2*(h-distancenum)/h*(thetanum0-ynum);
        
        
        
        
        theta[0] = [NSNumber numberWithFloat:thetanum0];
        x[i] = [NSNumber numberWithFloat:xnum];
        theta[1]=[NSNumber numberWithFloat:thetanum1];
        y[i]=[NSNumber numberWithFloat:ynum];
        
        grad[0]=[NSNumber numberWithFloat:gradnum0];
        grad[1]=[NSNumber numberWithFloat:gradnum1];
        distance[i]=[NSNumber numberWithFloat:distancenum];
        
        
        
    }
    
    theta[0] = [NSNumber numberWithFloat:[theta[0] floatValue] - (lambda/x.count * [grad[0] floatValue])];
    theta[1] = [NSNumber numberWithFloat:[theta[1] floatValue] - (lambda/x.count * [grad[1] floatValue])];
    //x.count表示ap数量
    
}

-(void) Decent:(NSMutableArray *) theta APx:(NSMutableArray *)x APy:(NSMutableArray *)y RSSdistance:(NSMutableArray *)distance {
    for(int i=0;i<50;i++)
    [self gradient:theta APx:x APy:y RSSdistance:distance];
    //NSLog(@"theta");
    //NSLog(@"%@",theta);
    
    
}





@end


