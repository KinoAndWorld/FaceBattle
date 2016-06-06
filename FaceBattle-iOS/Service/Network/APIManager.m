//
//  APIManager.m
//  Swipidea
//
//  Created by kino on 15/9/1.
//  Copyright (c) 2015年 cosmo. All rights reserved.
//

#import "APIManager.h"

#import <AFNetworking/AFNetworking.h>

//#define DEBUG_MODE @"DebugVersion"

@interface APIManager()

@property (strong, nonatomic) AFHTTPSessionManager *manager;
//@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation APIManager

+ (APIManager *)shareManager{
    static APIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[APIManager alloc] init];
        instance.manager = [AFHTTPSessionManager manager];
        instance.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        instance.manager.requestSerializer.timeoutInterval = 30.0f;
    });
    return instance;
}

//AFHTTPResponseSerializer

- (void)sendRequestFromMethod:(APIMethod)method
                         path:(NSString *)path
                       params:(NSDictionary *)params
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock
           responseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer{
    return [self sendRequestFromMethod:method path:path params:params
                            onComplete:completeBlock onError:errorBlock
                    responseSerializer:responseSerializer
             constructingBodyWithBlock:nil progress:nil];
}



- (void)sendRequestFromMethod:(APIMethod)method
                         path:(NSString *)path
                       params:(NSDictionary *)params
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock
           responseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress{
    if (responseSerializer) {
        self.manager.responseSerializer = responseSerializer;
    }else{
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
//    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy = NSHTTPCookieAcceptPolicyNever;
//    if ([UserManager sharedManager].isLogin) {
//        [self.manager.requestSerializer setValue:[UserManager sharedManager].curUser.authToken forHTTPHeaderField:@"Auth-Token"];
//    }
    
    
//    [self.manager.requestSerializer setValue:@"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    
    
    
#ifdef DEBUG_MODE
    NSString *route = [NSString stringWithFormat:@"%@/%@",TEST_BASE_API_URL, path];
#else
    NSString *route = [NSString stringWithFormat:@"%@/%@",BASE_API_URL, path];
#endif
    if (method == APIMethodGet) {
        [self.manager GET:route parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completeBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            BFLog(@"network error:%@",task.response);
            BFLog(error.localizedDescription);
            errorBlock(error);
        }];
    }else if (method == APIMethodPost){
        [self.manager POST:route parameters:params constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completeBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            BFLog(@"network error:%@",task.response);
            BFLog(error.localizedDescription);
            errorBlock(error);
        }];
        
    }else if(method == APIMethodPut){
        [self.manager PUT:route parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completeBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            BFLog(@"network error:%@",task.response);
            BFLog(error.localizedDescription);
            errorBlock(error);
        }];
    }else{
        [self.manager DELETE:route parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            completeBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            BFLog(@"network error:%@",task.response);
            BFLog(error.localizedDescription);
            errorBlock(error);
        }];
    }
}


- (void)sendRequestFromMethod:(APIMethod)method
                         path:(NSString *)path
                       params:(NSDictionary *)params
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock{
    
    [self sendRequestFromMethod:method path:path params:params onComplete:completeBlock onError:errorBlock responseSerializer:nil];
}


- (void)handleCompleteBlock:(ResponseBlock)completeBlock
                   errBlock:(ErrorBlock)errorBlock
                     result:(id)responseResult
                 translater:(Class<DataTranslate>)translater{
    
    id apiResponseDic = responseResult;
    
    if ([apiResponseDic isKindOfClass:[NSArray class]] && [apiResponseDic count] != 0) {
        completeBlock([translater translateFromData:apiResponseDic]);
        return ;
    }
    
    if (![apiResponseDic isKindOfClass:[NSDictionary class]]){
        completeBlock(responseResult);
        return ;
    }
    
    /* DEBUG */
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:apiResponseDic
                                                       options:kNilOptions
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    BFLog(@"%@",jsonString);
    /* DEBUG */
    
    if (!apiResponseDic[@"msg"] || [apiResponseDic[@"msg"] isEqualToString:@"Success"]) {
        id dataArray = apiResponseDic[@"data"];
        
        if (!dataArray) {
            if (translater) {
                completeBlock? completeBlock([translater translateFromData:apiResponseDic]): nil;
            }else{
                completeBlock? completeBlock(apiResponseDic) : nil;
            }
        }else{
            if (translater) {
                completeBlock? completeBlock([translater translateFromData:dataArray]) : nil;
            }else{
                completeBlock? completeBlock(dataArray) : nil;
            }
        }
        
    }else{
        NSString *errMsg = @"网络错误，请稍后再试";
        if ([apiResponseDic objectForKey:@"msg"] &&
            [apiResponseDic[@"msg"] isKindOfClass:[NSString class]]) {
            errMsg = apiResponseDic[@"msg"];
        }
        NSError *requestFailErr = [NSError errorWithDomain:errMsg
                                                      code:-1
                                                  userInfo:apiResponseDic];
        errorBlock? errorBlock(requestFailErr) : nil;
    }
}


- (void)handleErrorBlock:(ErrorBlock)block withError:(NSError *)error{
    
    block? block([self translateError:error]) : nil;
}

- (NSString *)getUserToken{
    if ([[UserManager sharedManager] isLogin]) {
        return [UserManager sharedManager].curUser.authToken;
    }else{
        return @"";
    }
}


- (NSError *)translateError:(NSError *)error{
    //AFNetworkingOperationFailingURLResponseDataErrorKey
    
//    if ([dict[@"error_msg"] isKindOfClass:[NSString class]] && [dict[@"error_msg"] length] > 0) {
//        NSError *err = [NSError errorWithDomain:dict[@"error_msg"] code:-10 userInfo:nil];
//        return err;
//    }
//    
//    if ([dict[@"error"] isKindOfClass:[NSString class]] && [dict[@"error"] length] > 0) {
//        NSError *err = [NSError errorWithDomain:dict[@"error"] code:-10 userInfo:nil];
//        return err;
//    }
    
    return [NSError errorWithDomain:error.userInfo[NSLocalizedDescriptionKey] code:error.code userInfo:nil];
}


@end

