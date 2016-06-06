//
//  NSString+DMReverse.m
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import "NSString+DMReverse.h"

@implementation NSString (DMReverse)
- (NSString *)stringByReversed
{
    //    NSMutableString *s = [NSMutableString string];
    //    for (NSUInteger i=self.length; i>0; i--) {
    //        [s appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    //    }
    //    return s;
    unsigned long len;
    len = [self length];
    unichar a[len];
    for(int i = 0; i < len; i++)
    {
        unichar c = [self characterAtIndex:len-i-1];
        a[i] = c;
    }
    NSString *str1=[NSString stringWithCharacters:a length:len];
    return  str1;
}
@end
