//
//  APIManager.h
//
//  Created by kino on 15/9/1.
//  Copyright (c) 2015年 Kino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFURLResponseSerialization.h>
#import <AFURLRequestSerialization.h>

#import "NetworkConsts.h"
#import "DataTranslate.h"

typedef void (^ResponseBlock)(id responseResult);
typedef void (^ErrorBlock)(NSError *error);


@class AFHTTPResponseSerializer, AFHTTPSessionManager;

@interface APIManager : NSObject

+ (APIManager *)shareManager;

@property (strong, nonatomic, readonly) AFHTTPSessionManager *manager;

- (void)sendRequestFromMethod:(APIMethod)method
                         path:(NSString *)path
                       params:(NSDictionary *)params
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock;


- (void)sendRequestFromMethod:(APIMethod)method
                         path:(NSString *)path
                       params:(NSDictionary *)params
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock
           responseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer;


- (void)sendRequestFromMethod:(APIMethod)method
                         path:(NSString *)path
                       params:(NSDictionary *)params
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock
           responseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer
    constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                     progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress;

/**
 *  API 的标准处理
 *
 *  @param completeBlock
 *  @param errorBlock
 *  @param responseResult
 *  @param translater
 */
- (void)handleCompleteBlock:(ResponseBlock)completeBlock
                   errBlock:(ErrorBlock)errorBlock
                     result:(id)responseResult
                 translater:(Class<DataTranslate>)translater;

- (void)handleErrorBlock:(ErrorBlock)block withError:(NSError *)error;
//- (void)handleErrorBlock:(ErrorBlock)block withError:(NSError *)error;
@end
