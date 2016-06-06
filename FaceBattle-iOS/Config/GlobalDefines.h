//
//  GlobalDefines.h
//  HomeInns-iOS
//
//  Created by kino on 15/9/7.
//
//

#ifndef MeiYuan_iOS_GlobalDefines_h
#define MeiYuan_iOS_GlobalDefines_h

/* Const key */
static NSString *const kUmengKey =      @"56fe552467e58ef6e300328a";

static NSString *const kWXAppID =       @"wx6377ae9a982325e9";
static NSString *const kWXAppSecret =   @"c57481042e7850eafc7cccac74cebc2d";

static NSString *const kSinaAppID =       @"1199056963";
static NSString *const kSinaAppSecret =   @"9038cce2319f5b9714514cece095aa61";

static NSString *const kQQAppID =       @"1105242999";
static NSString *const kQQAppSecret =   @"mclB9egKr2EtJgzz";

static NSString *const kJSPatchKey = @"7aecdca2183527a1";



/* Notificaitons */

static NSString *const kNotifationSignInStatus = @"NotifationSignInStatus";


static NSString *const kNotifationPayStatus = @"NotifationPayStatus";

typedef enum {
    PayStatusSuccess = 0,
    PayStatusFail,
    PayStatusCancel
}PayStatus;

/**
 *  常用宏
 */

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define useWeakSelf __weak typeof(self) weakSelf = self;

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define MobEvent(name) [MobClick event:name];

#define useNickNameTransform    + (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{\
                                    return [propertyName mj_underlineFromCamel];\
                                }\


#endif
