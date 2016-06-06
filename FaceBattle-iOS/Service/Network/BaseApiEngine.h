//
//  BaseApiEngine.h
//  HomeInns-iOS
//
//  Created by kino on 15/9/7.
//
//

#import <Foundation/Foundation.h>
#import "APIManager.h"

#import <AFHTTPSessionManager.h>

#define Default_Handle ^(id responseResult){\
        [[APIManager shareManager] handleCompleteBlock:completeBlock\
                                              errBlock:errorBlock\
                                                result:responseResult\
                                            translater:translater];\
        }

#define Default_Err_Handle ^(NSError *error) {\
        [[APIManager shareManager] handleErrorBlock:errorBlock\
        withError:error];\
        }

@interface BaseApiEngine : NSObject

//+ (NSString *)jsonStringFromDic:(NSDictionary *)dic;
//+ (NSString *)encryString:(NSString *)oriString;

@end
