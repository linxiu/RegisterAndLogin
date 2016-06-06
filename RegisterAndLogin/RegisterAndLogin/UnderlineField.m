//
//  UnderlineField.m
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import "UnderlineField.h"
#define DMRGB(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define DMLineColor DMRGB(219, 219, 219)//线条
@implementation UnderlineField
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, DMLineColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame)-0.5, CGRectGetWidth(self.frame), 0.5));
}
@end
