//
//  UserManager.h
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import <Foundation/Foundation.h>
#import "AppUser.h"

static NSString * const kNotifNameUserInfoUpdate = @"notifNameUserInfoUpdate";

@interface UserManager : NSObject

@property (strong, nonatomic) AppUser *curUser;
@property (assign, nonatomic, readonly) BOOL isLogin;

//@property (assign, nonatomic) BOOL isNeedUpdate;

+ (UserManager *)sharedManager;


- (void)login:(AppUser *)user;

- (void)logout;

//- (void)updateUserInfo;
//- (void)updateUserInfoWhenSuccess:(void(^)())successBlock
//                             fail:(void(^)(NSError *err))errorBlock;

- (void)postNotifationForUserInfoUpdated;

@end
