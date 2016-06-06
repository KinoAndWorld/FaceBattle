//
//  UserEngine.h
//  MeiYuan
//
//  Created by kino on 16/4/8.
//
//

#import "BaseApiEngine.h"

#import "UserRequest.h"

@interface UserEngine : BaseApiEngine

/**
 *  用户注册
 *
 *  @param req
 */
+ (void)userSignUpWithRequest:(UserRequest *)req
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock
                   translater:(Class<DataTranslate>)translater;

/**
 *  用户登录
 *
 *  @param req
 */
+ (void)userSignInWithRequest:(UserRequest *)req
                   onComplete:(ResponseBlock)completeBlock
                      onError:(ErrorBlock)errorBlock
                   translater:(Class<DataTranslate>)translater;



@end
