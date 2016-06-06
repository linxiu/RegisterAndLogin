//
//  VPKCRequestManager.m
//  RegisterAndLogin
//
//  Created by linxiu on 16/5/26.
//  Copyright © 2016年 甘真辉. All rights reserved.
//

#import "VPKCRequestManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "DNTool.h"
typedef NS_ENUM(NSInteger , VPKCRequestMethod) {
    VPKCRequestMethodGet,
    VPKCRequestMethodPost,
    VPKCRequestMethodPut,
    VPKCRequestMethodDelete,
    VPKCRequestMethodPatch,
    VPKCRequestMethodHead,
};
const NSString *methodStirng[] = {
    [VPKCRequestMethodGet] = @"GET",
    [VPKCRequestMethodPost] = @"POST",
    [VPKCRequestMethodHead] = @"HEAD",
    [VPKCRequestMethodPut] = @"PUT",
    [VPKCRequestMethodDelete] = @"DELETE",
    [VPKCRequestMethodPatch] = @"PATCH",
};
@interface VPKCRequestManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) NSURLSessionDataTask *sessionDataTask;

/// 网络是否可用
@property (assign, nonatomic, readwrite) BOOL reachable;
//
/// 当前任务ID
@property (assign, nonatomic) NSInteger taskIdentifier;
//
//
//
/// 请求地址(前半段)
@property (strong, nonatomic) NSString *requestBaseUrl;
// 请求地址(后半段)
@property (copy, nonatomic) NSString *requestApiUrl;
/// 请求参数
@property (strong, nonatomic) NSDictionary *requestParame;
/// 请求方式
@property (assign, nonatomic) VPKCRequestMethod requestMethod;

@end
@implementation VPKCRequestManager

/// GET
+ (VPKCRequestManager *)GET:(NSString *)url
                 withParame:(NSDictionary *)parame
               withComplete:(void(^)(VPKCResponse *responseObj))result {
    
    return [self requestConfigWithUrl:url withParame:parame withMethod:VPKCRequestMethodGet withComplete:result];
}


/// POST
+ (VPKCRequestManager *)POST:(NSString *)url
                  withParame:(NSDictionary *)parame
                withComplete:(void(^)(VPKCResponse *responseObj))result {
    return [self requestConfigWithUrl:url withParame:parame withMethod:VPKCRequestMethodPost withComplete:result];
}

/// PUT
+ (VPKCRequestManager *)PUT:(NSString *)url
                 withParame:(NSDictionary *)parame
               withComplete:(void(^)(VPKCResponse *responseObj))result {
    return [self requestConfigWithUrl:url withParame:parame withMethod:VPKCRequestMethodPut withComplete:result];
}


/// PATCH
+ (VPKCRequestManager *)PATCH:(NSString *)url
                   withParame:(NSDictionary *)parame
                 withComplete:(void(^)(VPKCResponse *responseObj))result {
    return [self requestConfigWithUrl:url withParame:parame withMethod:VPKCRequestMethodPatch withComplete:result];
}

/// DELETE
+ (VPKCRequestManager *)DELETE:(NSString *)url
                    withParame:(NSDictionary *)parame
                  withComplete:(void(^)(VPKCResponse *responseObj))result {
    return [self requestConfigWithUrl:url withParame:parame withMethod:VPKCRequestMethodDelete withComplete:result];
}


/// 取消当前请求任务
- (void)cancelCurrentTask {
    
    // cancel specific task
    for (NSURLSessionDataTask* task in [_sessionManager tasks]) {
        if (task.taskIdentifier == _taskIdentifier) {
            [task cancel];
        }
    }
}

/// 取消所有请求任务
- (void)cancelAllTask {
    [_sessionDataTask cancel];
}






+ (VPKCRequestManager *)sharedRequest {
    static VPKCRequestManager *requestManage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManage = [[self alloc] initPrivate];
    });
    
    return requestManage;
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        
        _reachable = YES;
        _requestBaseUrl = [NSURL URLWithString:@"http://baidu.com"];
        _requestMethod = VPKCRequestMethodGet;
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = 30;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
        [_sessionManager setSecurityPolicy:[self customSecurityPolicy]];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [_sessionManager.reachabilityManager startMonitoring];
        __weak typeof(self)weakSelf = self;
        [_sessionManager.reachabilityManager setReachabilityStatusChangeBlock:^void(AFNetworkReachabilityStatus status)
         {
             weakSelf.reachable = [@(status) boolValue];
         }];
        
    }
    return self;
}
//// 设置请求头
- (void)setHmacStringWithSessionManager:(AFHTTPRequestSerializer *)requestSerializer {
    
    //    NSString *time = [VPKCUtils timeToTurnTheTimestamp];
    //    NSString *hmac = [NSString stringWithFormat:@"%@\n%@/%@\n%@",time,kHmacUrl,_requestApiUrl,methodStirng[_requestMethod]];
    //    hmac = [NSString hmac:hmac];
    //    NSString *devID = [VPKCUserInfo sharedUserInfo].parentDeviceId;
    //    NSString *user = [VPKCUserInfo sharedUserInfo].username;
    //    NSString *child = [VPKCUserInfo sharedUserInfo].childDeviceId?:@"";
    //
    //    [requestSerializer setValue:time forHTTPHeaderField:@"X-KC-TIME"];
    //    [requestSerializer setValue:hmac forHTTPHeaderField:@"X-KC-HMAC"];
    //    [requestSerializer setValue:devID forHTTPHeaderField:@"X-KC-DEVICEID"];
    //    [requestSerializer setValue:user forHTTPHeaderField:@"X-KC-USERNAME"];
    //    [requestSerializer setValue:child forHTTPHeaderField:@"X-KC-CHILD-DEVICEID"];
}
// https配置
- (AFSecurityPolicy*)customSecurityPolicy {
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"d" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:NO];
    [securityPolicy setPinnedCertificates:@[certData]];
    return securityPolicy;
}
//
/// 拼接url
- (NSString *)requestServiceUrlString {
    if ([_requestApiUrl hasPrefix:@"http"]) {
        return _requestApiUrl;
    }
    return [NSString stringWithFormat:@"%@/%@",_requestBaseUrl,_requestApiUrl];
}

#pragma mark ------------------------------------------------------------

- (void)requestStartWithWithSuccess:(void (^)(VPKCResponse *))result {
    
    
    [self requestMethodWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"【request_responseObject】=%@ == %@",responseObject,task.response.URL.absoluteString);
        VPKCResponse *response = [[VPKCResponse alloc] init];
        response.responseObject = responseObject;
        response.error = nil;
        
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            response.headerFields = r.allHeaderFields;
            response.status = @(r.statusCode);
        }
        if (result) {
            result(response);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"【request_error】=%@  == Url = %@",error,task.response.URL.absoluteString);
        VPKCResponse *response = [[VPKCResponse alloc] init];
        response.error = error;
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            response.headerFields = r.allHeaderFields;
            response.status = @(r.statusCode);
            if ([response.status isEqualToNumber:@403]) {
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data) {
                    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSDictionary *responseObject = [DNTool jsonWithString:s];
                    NSLog(@"error = %@",responseObject);
                    response.content = responseObject[@"content"];
                    response.errorCode = responseObject[@"errorCode"];
                    response.errorDescription = responseObject[@"errorDescription"];
                }
            }
            
            if ([response.status isEqualToNumber:@502]) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"连接服务器异常" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        if (result) {
            result(response);
        }
    }];
    
}


- (void)requestMethodWithSuccess:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure {
    
    if (!_reachable) {
        failure(nil,[NSError errorWithDomain:@"网络连接失败" code:-1 userInfo:nil]);
        return ;
    }
    
    NSDictionary *parame = _requestParame;
    NSString *URLString = [self requestServiceUrlString];
    [self setHmacStringWithSessionManager:_sessionManager.requestSerializer];
    
    NSLog(@"【URL】%@",URLString);
    NSLog(@"【parame】%@",parame);
    
    
    
    switch (_requestMethod)
    {
        case VPKCRequestMethodGet:
            _sessionDataTask = [_sessionManager GET:URLString parameters:parame success:success failure:failure];
            break;
        case VPKCRequestMethodPost:
            _sessionDataTask = [_sessionManager POST:URLString parameters:parame success:success failure:failure];
            break;
        case VPKCRequestMethodPut:
            _sessionDataTask =  [_sessionManager PUT:URLString parameters:parame success:success failure:failure];
            break;
        case VPKCRequestMethodDelete:
            _sessionDataTask =  [_sessionManager DELETE:URLString parameters:parame success:success failure:failure];
            break;
        case VPKCRequestMethodPatch:
            _sessionDataTask =  [_sessionManager PATCH:URLString parameters:parame success:success failure:failure];
            break;
        case VPKCRequestMethodHead:{
            _sessionDataTask = [_sessionManager HEAD:URLString parameters:parame success:^(NSURLSessionDataTask * task) {
                success(task,nil);
            } failure:failure];
        }
            break;
        default:
            break;
    }
    _taskIdentifier = _sessionDataTask.taskIdentifier;
}


+ (VPKCRequestManager *)requestConfigWithUrl:(NSString *)url
                                  withParame:(NSDictionary *)parame
                                  withMethod:(VPKCRequestMethod)method
                                withComplete:(void(^)(VPKCResponse *responseObj))result
{
    VPKCRequestManager *request = [VPKCRequestManager sharedRequest];
    request.requestApiUrl = url;
    request.requestParame = parame;
    request.requestMethod = method;
    [request requestStartWithWithSuccess:result];
    return request;
}
@end

