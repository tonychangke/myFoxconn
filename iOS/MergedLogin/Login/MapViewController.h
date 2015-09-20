//
//  MapViewController.h
//  Login
//
//  Created by 常柯 on 15/8/19.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAMapView.h"

@interface MapViewController : UIViewController
{
    IBOutlet NAMapView *mapView;

}
@property (retain, nonatomic) IBOutlet NAMapView *mapView;

@end
