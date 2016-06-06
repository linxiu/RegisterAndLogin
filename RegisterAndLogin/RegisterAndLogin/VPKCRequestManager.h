//
//  VPKCRequestManager.h
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPKCResponse.h"
@interface VPKCRequestManager : NSObject

/// 获取当前网络是否可用
@property (assign, nonatomic, readonly) BOOL reachable;

/// 单利
+ (VPKCRequestManager *)sharedRequest;

/// 取消当前请求任务
- (void)cancelCurrentTask;

/// 取消所有请求任务
- (void)cancelAllTask;

/// GET
+ (VPKCRequestManager *)GET:(NSString *)url
                 withParame:(NSDictionary *)parame
               withComplete:(void(^)(VPKCResponse *responseObj))result;


/// POST
+ (VPKCRequestManager *)POST:(NSString *)url
                  withParame:(NSDictionary *)parame
                withComplete:(void(^)(VPKCResponse *responseObj))result;

/// PUT
+ (VPKCRequestManager *)PUT:(NSString *)url
                 withParame:(NSDictionary *)parame
               withComplete:(void(^)(VPKCResponse *responseObj))result;


/// PATCH
+ (VPKCRequestManager *)PATCH:(NSString *)url
                   withParame:(NSDictionary *)parame
                 withComplete:(void(^)(VPKCResponse *responseObj))result;

/// DELETE
+ (VPKCRequestManager *)DELETE:(NSString *)url
                    withParame:(NSDictionary *)parame
                  withComplete:(void(^)(VPKCResponse *responseObj))result;
@end
