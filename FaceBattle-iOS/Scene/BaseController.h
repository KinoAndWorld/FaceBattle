//
//  BaseController.h
//  HomeInns-iOS
//
//  Created by kino on 15/9/2.
//
//

#import <UIKit/UIKit.h>

#import "UIViewController+Presenter.h"

//
//#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@class KOViewModel;

typedef enum {
    NavigationTransAnimationDefault = 0,
    NavigationTransAnimationDownToUp,
    NavigationTransAnimationUpToDown,
    NavigationTransAnimationFade,
    
}NavigationTransAnimation;


@interface BaseController : UIViewController


- (instancetype)initWithViewModel:(KOViewModel *)viewModel;

#pragma mark - 

/**
 *  重试 调用各自的API
 */
- (void)recallRequest;

- (BOOL)showLoginVCIfNoLogin;
- (BOOL)showLoginVCIfNoLoginWithCancel:(void(^)())cancelHanle;
- (BOOL)showLoginVCIfNoLoginWithCancel:(void(^)())cancelHanle
                         successHandle:(void(^)())successHandle;

#pragma mark - NagationItem

//返回
- (UIBarButtonItem *)setLeftBackItem;
//关闭
- (void)setLeftCloseItem;

- (void)backItemAction;
- (void)closeItemAction;



- (void)pushController:(UIViewController *)controller;
- (void)pushController:(UIViewController *)controller animatiom:(NavigationTransAnimation)animation;

- (void)popController;
- (void)popControllerWithAnimatiom:(NavigationTransAnimation)animation;


@end
