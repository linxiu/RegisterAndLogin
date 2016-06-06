//
//  User.h
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/25.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
/**
 *  @brief  读取用户账号信息
 *
 *  @return 用户账号信息
 */
+(id)readUserID;
/**
 *  @brief  删除用户账号信息
 *
 *  @return 用户账号信息
 */
+(void)deleteUserID;
/**
 *  @brief  删除用户信息内容
 */
+(void)deleteUserData;
/**
 *  @brief  删除密码数据
 */
+(void)deletePassWord;
/**
 *  @brief  删除用户头像内容
 */
+(void)deleteUserHeadImageUrl;
/**
 *  @brief  存储用户账号信息
 *
 *  @param  userID    用户账号信息
 */
+(void)saveUserID:(id)userID;
@end
