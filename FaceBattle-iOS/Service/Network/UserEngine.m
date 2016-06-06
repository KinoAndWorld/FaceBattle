//
//  UserEngine.m
//  MeiYuan
//
//  Created by kino on 16/4/8.
//
//

#import "UserEngine.h"

#define APP_CACHES_PATH             [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@implementation UserEngine

/**
 *  用户注册
 *
 *  @param req
 */
+ (void)userSignUpWithRequest:(UserRequest *)req
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock
                   translater:(Class<DataTranslate>)translater{
    
    NSDictionary *params = @{ @"username" : req.account,
                              @"password" : req.password};
    
    [[APIManager shareManager] sendRequestFromMethod:APIMethodPost
                                                path:API_SignUp
                                              params:params
                                          onComplete:Default_Handle
                                             onError:Default_Err_Handle];
}

/**
 *  用户登录
 *
 *  @param req
 */
+ (void)userSignInWithRequest:(UserRequest *)req
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock
                   translater:(Class<DataTranslate>)translater{
    
    NSDictionary *params = @{ @"username" : req.account,
                              @"password" : req.password};
    
    [[APIManager shareManager] sendRequestFromMethod:APIMethodPost
                                                path:API_SignIn
                                              params:params
                                          onComplete:Default_Handle
                                             onError:Default_Err_Handle];
}

@end
