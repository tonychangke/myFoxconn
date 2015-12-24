//
//  drawLineView.m
//  Login
//
//  Created by 常柯 on 15/10/20.
//  Copyright (c) 2015年 menuz's lab. All rights reserved.
//

#import "drawLineView.h"

@implementation drawLineView

-(void)drawRect:(CGRect)rect
{
    CGContextRef context    =UIGraphicsGetCurrentContext();//获取画布
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);//线条颜色
    CGContextSetShouldAntialias(context,NO);//设置线条平滑，不需要两边像素宽
    CGContextSetLineWidth(context,1.0f);//设置线条宽度
    
    CGContextMoveToPoint(context,self.initPoint.x,self.initPoint.y); //线条起始点
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    for (NSValue *value in self.points)
    {
        CGPoint tem=[value CGPointValue];
        CGContextAddLineToPoint(context, tem.x, tem.y);
    }
    CGContextStrokePath(context);
}
@end
