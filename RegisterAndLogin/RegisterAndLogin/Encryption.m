//
//  Encryption.m
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import "Encryption.h"
#import "DNTool.h"
#import "NSString+DMReverse.h"
@implementation Encryption
+ (NSDictionary *)loginEncryptionAttestationWithMobile:(NSString *)mobile  withpassword:(NSString *)pwd
{
    
    int randomNumber = [self getRandomNumber];
    NSDictionary *requestParameters = [ NSDictionary  dictionaryWithObjectsAndKeys:[self loginAttestationForType:(randomNumber%3) withRandomNumber:randomNumber withMobile:mobile withpassword:pwd],@"login_sign", [NSString stringWithFormat:@"%d",randomNumber],@"login_random", nil];
    return requestParameters;
}
+ (int)getRandomNumber
{
    return (int)(10000000 + (arc4random() % (100000000 - 10000000 + 1)));
}
+(NSString *)loginAttestationForType:(int)type  withRandomNumber:(int)randomNumber withMobile:(NSString *)mobile  withpassword:(NSString *)pwd
{
    
    
    NSString *sign;
    
    switch (type) {
        case 0:{
            
            NSString *mobileAndRandomNumberByReversed = [NSString stringWithFormat:@"%@%d",mobile,randomNumber];
            NSLog(@"%@",[mobile substringToIndex:mobile.length/2]);
            NSLog(@"%@",pwd);
            NSLog(@"%@",[mobile substringFromIndex:mobile.length/2 ]);
            NSLog(@"%@",mobileAndRandomNumberByReversed.stringByReversed);
            sign =  [NSString stringWithString:[DNTool md5:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@%@%@",[mobile substringToIndex:mobile.length/2],pwd, [mobile substringFromIndex:mobile.length/2 ]],mobileAndRandomNumberByReversed.stringByReversed]]];
            
            break;
        }
        case 1:{
            NSLog(@"%d",[mobile intValue]/2);
            NSLog(@"%@",[pwd uppercaseString]);
            NSLog(@"%d",[mobile intValue]/2 -randomNumber/2);
            
            NSString *randomString = [NSString stringWithFormat:@"%d",randomNumber];
            sign = [NSString stringWithString:[DNTool md5:[NSString stringWithFormat:@"%d%@",[[mobile substringToIndex:mobile.length/2] intValue] - [[randomString substringToIndex:randomString.length/2] intValue],[pwd uppercaseString]]]];
            
            break;
        }
            
        case 2:{
            
            sign = [ NSString stringWithString:[DNTool md5:[NSString stringWithFormat:@"%@%@%d",[[ pwd.stringByReversed substringToIndex:pwd.length/2  ]uppercaseString],[mobile substringToIndex:mobile.length/2],randomNumber<<(randomNumber % 2) ]]];
            
            
            break;
        }
        default:
            break;
    }
    
    return sign;
}
@end
