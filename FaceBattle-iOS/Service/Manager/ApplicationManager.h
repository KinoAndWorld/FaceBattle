//
//  ApplicationManager.h
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import <Foundation/Foundation.h>

@interface ApplicationManager : NSObject

@property (strong, nonatomic) UINavigationController *rootController;

@property (strong, nonatomic) UIView *statusBarView;

+ (ApplicationManager *)sharedManager;

- (void)setupRootControllersInWindow:(UIWindow *)window;

- (void)setupComponentSDKs:(UIApplication *)application options:(NSDictionary *)launchOptions;

- (void)setupApplicationData;


- (void)handleRemotePushWithUserInfo:(NSDictionary *)userInfo;

- (void)changeTabIndex:(NSUInteger)index;

@end
