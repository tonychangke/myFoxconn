//
//  RSSModel.h
//  BLEoffline
//
//  Created by whathexd on 15/10/7.
//  Copyright (c) 2015年 whathexd. All rights reserved.
//

#ifndef BLEoffline_RSSModel_h
#define BLEoffline_RSSModel_h


#endif

#define ARC4RANDOM_MAX 0X100000000

@interface RSSModel : NSObject
@property (strong, nonatomic) NSMutableArray *APposX;
@property (strong, nonatomic) NSMutableArray *APposY;
@property (nonatomic) NSInteger numOfAP;
@property (strong, nonatomic) NSNumber* UserX;
@property (strong, nonatomic) NSNumber* UserY;
@property (strong, nonatomic) NSMutableArray *standardRSS;
@property (strong, nonatomic) NSMutableArray *distance;
@property (strong, nonatomic) NSMutableArray *RSS_receive;
@property (strong, nonatomic) NSMutableArray *RSS_distance;

-(void) rssInput:(NSMutableArray *)RSSreceive;
@end