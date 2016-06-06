//
//  DNTool.m
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import "DNTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import <netdb.h>
#import <arpa/inet.h>
static const NSTimeInterval DMHUDDelayTimeInterval = 1.0f;

@implementation DNTool
+ (NSDictionary *)jsonWithString:(NSString *)string {
    
    if (!string) {
        return nil;
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if (err) {
        return nil;
    }
    return dic;
}
#pragma mark -- 指示器相关方法
+ (MBProgressHUD *)HUDTextOnly:(NSString *)text toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.labelFont = [UIFont systemFontOfSize:15.0f];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:DMHUDDelayTimeInterval];
    return hud;
}
+ (MBProgressHUD *)HUDLoadingOnView:(UIView *)view delegate:(id)delegate
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    [hud show:YES];
    [hud setDelegate:delegate];
    return hud;
}
// 方法功能：md5 加密
+ (NSString *)md5:(NSString *)str
{
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
