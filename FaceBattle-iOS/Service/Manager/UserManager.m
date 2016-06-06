//
//  UserManager.m
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import "UserManager.h"

#import "UserEngine.h"

#import <BFCryptor.h>

@interface UserManager()

@property (assign, nonatomic) BOOL isLogin;

@end

@implementation UserManager

+ (UserManager *)sharedManager{
    static UserManager *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

- (BOOL)isLogin{
    if (_isLogin && (!_curUser || !_curUser.authToken ||
                     _curUser.authToken.length==0 )) {
        _isLogin = NO;
    }
    return _isLogin;
}

- (void)login:(AppUser *)user{
    if (user) {
        self.curUser = user;
//        [self.curUser saveToLocal];
        
        //分配头像
        NSString *avatarName = [NSString stringWithFormat:@"%d",(int)[user.userId intValue] % 24 + 1];
        user.avatarImage = [UIImage imageNamed:avatarName];
        
        //生成token
//        NSTimeInterval stamp = [[NSDate date] timeIntervalSinceReferenceDate];
        
//        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
//        NSString *timeString = [NSString stringWithFormat:@"%.0f", interval];
        
        NSString *timeString = [NSString stringWithFormat:@"%d", (int)[[NSDate date]  timeIntervalSince1970]];
        
        NSString *str= [NSString stringWithFormat:@"%@%@%@",user.userId,user.authcode,timeString];
        
        NSString *md5Str = [BFCryptor MD5:str];
        
        NSString *finalStr = [NSString stringWithFormat:@"%@%@",[md5Str substringWithRange:NSMakeRange(8, 16)], timeString];
        
        user.authToken = finalStr;
        
        self.isLogin = YES;
    }
}

- (void)logout{
    if (self.curUser) {
        [self.curUser removeInfo];
        self.curUser = nil;
        self.isLogin = NO;
    }
}

//- (void)updateUserInfo{
//    [self updateUserInfoWhenSuccess:nil fail:nil];
//}

- (void)postNotifationForUserInfoUpdated{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifNameUserInfoUpdate object:nil];
}


@end
