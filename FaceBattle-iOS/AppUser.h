//
//  AppUser.h
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import <Foundation/Foundation.h>

static NSString *const kLastLoginUser = @"MYLastLoginUser";
static NSString *const kLastLoginDate = @"MYLastLoginDate";

@interface AppUser : KOModel<NSCoding, NSCopying>

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *authToken;

@property (copy, nonatomic) NSString *authcode;

//@property (copy, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) UIImage *avatarImage;

/**
 *  读取本地User
 */
+ (instancetype)loadUserFromLocal;

/**
 *  保存登录时间和信息
 */
- (void)saveToLocal;

/**
 *  更新用户信息
 */

- (void)updateToLocal;
/**
 *  移除信息
 */
- (void)removeInfo;


@end