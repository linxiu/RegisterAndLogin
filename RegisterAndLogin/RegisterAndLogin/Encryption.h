//
//  Encryption.h
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encryption : NSObject
/**
 *  登录加密
 *
 *
 */
+ (NSDictionary *)loginEncryptionAttestationWithMobile:(NSString *)mobile  withpassword:(NSString *)pwd;
@end
