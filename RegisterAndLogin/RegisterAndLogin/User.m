//
//  User.m
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/25.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import "User.h"
static NSString * const KEY_UserID = @"DMSJ.DMWallet.userID";
static NSString * const KEY_UserData = @"DMSJ.DMWallet.userData";
static NSString * const KEY_PASSWORD = @"DMSJ.DMWallet.gesturePassword";
static NSString * const KEY_UserHeadImageUrl = @"DMSJ.DMWallet.userHeadImageUrl";
@implementation User
+(id)readUserID
{
    
    //    NSMutableDictionary *userDataKVPairs = (NSMutableDictionary *)[DMKeyChain load:KEY_UserData];
    NSMutableDictionary *userIDKVPairs = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UserID];
    return [userIDKVPairs objectForKey:KEY_UserID];
}
+(void)deleteUserID
{
    //    [DMKeyChain delete:KEY_UserData];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_UserID];
}
+(void)deleteUserData{
    //    [DMKeyChain delete:KEY_UserData];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_UserData];
}
+(void)deletePassWord
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_PASSWORD];
    //    [DMKeyChain delete:KEY_PASSWORD];
}
+(void)deleteUserHeadImageUrl
{
    //    [DMKeyChain delete:KEY_UserData];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_UserHeadImageUrl];
}
+(void)saveUserID:(id)userID
{
    NSMutableDictionary *userIDKVPairs = [NSMutableDictionary dictionary];
    [userIDKVPairs setObject:userID forKey:KEY_UserID];
    [[NSUserDefaults standardUserDefaults] setObject:userIDKVPairs forKey:KEY_UserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [DMKeyChain save:KEY_UserData data:userDataKVPairs];
}
@end
