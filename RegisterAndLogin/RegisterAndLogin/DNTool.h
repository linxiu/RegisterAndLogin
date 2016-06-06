//
//  DNTool.h
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

NSString *const DMPWD = @"q!wse#r4t%yhu&i8o(p;";
@interface DNTool : NSObject

+ (NSDictionary *)jsonWithString:(NSString *)string;
+ (MBProgressHUD *)HUDTextOnly:(NSString *)text toView:(UIView *)view;
+ (MBProgressHUD *)HUDLoadingOnView:(UIView *)view delegate:(id)delegate;
+ (NSString *)md5:(NSString *)str;
@end
