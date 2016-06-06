//
//  ApplicationManager.m
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import "ApplicationManager.h"

#import <AFNetworkActivityIndicatorManager.h>


#import "LoginController.h"
//home controllers
//#import "ArtHomeController.h"
//#import "ArtListController.h"
//#import "DesignerListController.h"
//#import "UserBoardController.h"
#import "BaseNavigationController.h"

#import "NSDate-Utilities.h"

@implementation ApplicationManager

+ (ApplicationManager *)sharedManager{
    static ApplicationManager *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

#pragma mark - InitRootUI

- (void)setupRootControllersInWindow:(UIWindow *)window{
    
    window.backgroundColor = [UIColor whiteColor];
    
    [self setupViewControllers];
    
    [window setRootViewController:self.rootController];
    [window makeKeyAndVisible];
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
        _statusBarView.backgroundColor = [UIColor clearColor];
        [window.rootViewController.view addSubview:_statusBarView];
    }
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

- (void)setupViewControllers {
    LoginController *homeVC = [[LoginController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:homeVC];
    
    self.rootController = nav;
}

- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
//    NSArray *tabBarItemImages = @[@"", @"second", @"", @"first"];
    NSDictionary *dict1 = @{CYLTabBarItemTitle : @"推荐",
                            CYLTabBarItemImage : @"icn_home",
                            CYLTabBarItemSelectedImage : @"first_selected",
                            };
    
    NSDictionary *dict2 = @{CYLTabBarItemTitle : @"发现作品",
                            CYLTabBarItemImage : @"icn_filter",
                            CYLTabBarItemSelectedImage : @"second_selected",
                            };
    
    NSDictionary *dict3 = @{CYLTabBarItemTitle : @"发现设计师",
                            CYLTabBarItemImage : @"icn_designer",
                            CYLTabBarItemSelectedImage : @"third_selected",
                            };
    
    NSDictionary *dict4 = @{CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"icn_profile",
                            CYLTabBarItemSelectedImage : @"first_selected",
                            };
    
    NSArray *tabBarItemsAttributes = @[ dict1, dict2, dict3, dict4 ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor turquoiseColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)customizeNavgationStyle:(UINavigationController *)nav{
    nav.navigationBar.translucent = NO;
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    
    [nav.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName : [UIColor blackColor],
           NSFontAttributeName : [UIFont applicationFontOfSize:16]}
         ];
}

#pragma mark - InitSDKs

- (void)setupComponentSDKs:(UIApplication *)application options:(NSDictionary *)launchOptions{
    
//    [JSPatch startWithAppKey:kJSPatchKey];
//    [JSPatch sync];
//    [JSPatch testScriptInBundle];
    
    
//    /**
//     *  推送
//     */
//    application.applicationIconBadgeNumber = 0;
//    //set AppKey and LaunchOptions
//    [UMessage startWithAppkey:UMENGAppID launchOptions:launchOptions];
//    [UMessage setAutoAlert:NO];
//    //for log
//    [UMessage setLogEnabled:YES];
//    [UMessage removeAllTags:nil];
//    
//    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if(remoteNotif){
//        //Handle remote notification
//        [((AppDelegate *)[UIApplication sharedApplication].delegate) application:application
//                                                    didReceiveRemoteNotification:remoteNotif];
//    }
//    BOOL closePush = [[USER_DEFAULT objectForKey:kClosePush] boolValue];
//    if (!closePush) {
//        if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
//            UIUserNotificationSettings *userSettings = [UIUserNotificationSettings
//                                                        settingsForTypes:UIUserNotificationTypeBadge|
//                                                        UIUserNotificationTypeSound|
//                                                        UIUserNotificationTypeAlert
//                                                        categories:nil];
//            [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
//            
//        } else{
//            //register remoteNotification types
//            [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//             |UIRemoteNotificationTypeSound
//             |UIRemoteNotificationTypeAlert];
//        }
//    }else{
//        [UMessage addTag:@"unsupportMessage" response:nil];
//        [UMessage unregisterForRemoteNotifications];
//    }
    
//    [AMapLocationServices sharedServices].apiKey = @"a9fef9a406e0c2ddc7a3660b076e12f8";
}

- (void)handleRemotePushWithUserInfo:(NSDictionary *)userInfo{
//    NSString *content = [userInfo[@"aps"] objectForKey:@"alert"];
//    NSString *title = userInfo[@"title"];
    
}

- (void)changeTabIndex:(NSUInteger)index{
    CYLTabBarController *rootController = (CYLTabBarController *)[ApplicationManager sharedManager].rootController;
    rootController.selectedIndex = index;
}


#pragma mark - InitPreloadData

- (void)setupApplicationData{
    //check login time out
    if ([USER_DEFAULT objectForKey:kLastLoginUser]) {
        AppUser *lastLoginUser = [AppUser loadUserFromLocal];
        if (lastLoginUser && lastLoginUser.authToken && lastLoginUser.authToken.length != 0) {
            NSDate *lastLoginDate = [USER_DEFAULT objectForKey:kLastLoginDate];
            
            NSInteger day = [[NSDate date] daysAfterDate:lastLoginDate];
            //超过30天 token过期
            if (day > 30) {
                [USER_DEFAULT removeObjectForKey:kLastLoginUser];
                [USER_DEFAULT synchronize];
            }else{
                [[UserManager sharedManager] login:lastLoginUser];
            }
        }else{
            [USER_DEFAULT removeObjectForKey:kLastLoginUser];
            [USER_DEFAULT synchronize];
        }
    }
}


@end
