//
//  Validate.h
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validate : NSObject
#pragma mark 判断是否是合法手机号
+(BOOL)isLegalMobilePhoneNumber:(NSString *)number;
#pragma mark - 判断输入是否为空
+(BOOL)isBlankString:(NSString *)string;
@end
