//
//  AppUser.m
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import "AppUser.h"

@implementation AppUser

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"userId" : @"uid",
             @"name" : @"username"};
}

/**
 *  读取本地User
 */
+ (instancetype)loadUserFromLocal{
    NSData *data = [USER_DEFAULT objectForKey:kLastLoginUser];
    AppUser *lastLoginUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return lastLoginUser;
}

/**
 *  保存登录时间和信息
 */
- (void)saveToLocal{
    [USER_DEFAULT setObject:[NSDate date] forKey:kLastLoginDate];
    [self updateToLocal];
}

/**
 *  更新用户信息
 */
- (void)updateToLocal{
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [USER_DEFAULT setObject:udObject forKey:kLastLoginUser];
    [USER_DEFAULT synchronize];
}

/**
 *  移除信息
 */
- (void)removeInfo{
    [USER_DEFAULT removeObjectForKey:kLastLoginUser];
    [USER_DEFAULT removeObjectForKey:kLastLoginDate];
    [USER_DEFAULT synchronize];
}

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }

@end
