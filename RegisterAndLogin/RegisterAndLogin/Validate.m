//
//  Validate.m
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import "Validate.h"

@implementation Validate
+(BOOL)isLegalMobilePhoneNumber:(NSString *)number{
    //判断位数
    if ([number length] <11)return NO;
    NSString *regex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(14[57]))\\d{4,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:number];
}
#pragma mark - 判断输入是否为空
+(BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
} 


@end
