//
//  BaseController.m
//  HomeInns-iOS
//
//  Created by kino on 15/9/2.
//
//

#import "BaseController.h"

#import "UserManager.h"

#import "BaseNavigationController.h"
//#import "ModelNavgationController.h"

//#import "HILoginVC.h"

@interface BaseController ()

@property (strong, nonatomic) KOViewModel *viewModel;

@end

@implementation BaseController

- (instancetype)initWithViewModel:(KOViewModel *)viewModel{
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController && ![self isRootController]){
        
        if ([NSStringFromClass(self.navigationController.class)
             isEqualToString:@"ModelNavgationController"] &&
            self.navigationController.viewControllers[0] == self) {
            [self setLeftCloseItem];
        }else{
            [self setLeftBackItem];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:animated];
}

- (BOOL)isRootController{
    BOOL isRoot = NO;
    if ([NSStringFromClass([self class]) isEqualToString:@"ArtHomeController"]) {
        isRoot = YES;
    }else if ([NSStringFromClass([self class]) isEqualToString:@"ArtListController"]){
        isRoot = YES;
    }else if ([NSStringFromClass([self class]) isEqualToString:@"UserBoardController"]){
        isRoot = YES;
    }else if ([NSStringFromClass([self class]) isEqualToString:@"DesignerListController"]){
        isRoot = YES;
    }
    return isRoot;
}


#pragma mark -

/**
 *  重试 调用各自的API
 */
- (void)recallRequest{
//    [[PresenterManager sharedManager] hideFailureView];
    
    //will call continue.
}

/**
 *  common show
 */
- (BOOL)showLoginVCIfNoLogin{
    //要先登录
    return [self showLoginVCIfNoLoginWithCancel:nil];
}

- (BOOL)showLoginVCIfNoLoginWithCancel:(void(^)())cancelHanle{
    
    return [self showLoginVCIfNoLoginWithCancel:cancelHanle successHandle:nil];
}

- (BOOL)showLoginVCIfNoLoginWithCancel:(void(^)())cancelHanle
                         successHandle:(void(^)())successHandle{
    //要先登录
    if (![UserManager sharedManager].isLogin) {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您还未登录~"
//                                                       delegate:nil cancelButtonTitle:@"取消"
//                                              otherButtonTitles:@"好的", nil];
//        [[alert rac_buttonClickedSignal] subscribeNext:^(id x) {
//            if ([x intValue] == 1) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    
//                    SignInGuideController *dest = [[SignInGuideController alloc] initWithViewModel:[[SignInGuideViewModel alloc] init]];
//                    dest.isModalPresent = YES;
//                    ModalNavgationController *nav = [[ModalNavgationController alloc]
//                                                     initWithRootViewController:dest];
//                    dest.navigationItem.title = @"登录";
//                    
//                    [self presentViewController:nav animated:YES completion:nil];
//                    if (successHandle) {
//                        [dest setLoginSuccessHandle:successHandle];
//                    }
//                });
//            }else{
//                if (cancelHanle) {
//                    cancelHanle();
//                }
//            }
//        }];
//        
//        [alert show];
        
        return NO;
    }else{
        if (successHandle) {
            successHandle();
        }
    }
    return YES;
}


#pragma mark - NavgationItem

//返回
- (UIBarButtonItem *)setLeftBackItem{
    UIButton *btnLeft =[[UIButton alloc] init];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"backIcon"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"backIconSelected"] forState:UIControlStateHighlighted];
//    [btnLeft.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    btnLeft.frame = CGRectMake(0, 0, 23, 23);
    
    UIBarButtonItem *barItemLeft =[[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    [btnLeft addTarget:self action:@selector(backItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItemLeft;
    
    return barItemLeft;
}

//关闭
- (void)setLeftCloseItem{
    UIButton *btnLeft =[[UIButton alloc] init];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"close-selected"] forState:UIControlStateHighlighted];
//    [btnLeft.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    btnLeft.frame = CGRectMake(0, 0, 23, 23);
    
    UIBarButtonItem *barItemLeft =[[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    [btnLeft addTarget:self action:@selector(closeItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItemLeft;
}

#pragma mark - Action Default

/**  Action **/

- (void)backItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeItemAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)pushController:(UIViewController *)controller{
    return [self pushController:controller animatiom:NavigationTransAnimationDefault];
}

- (void)pushController:(UIViewController *)controller animatiom:(NavigationTransAnimation)animation{
    
    if (self.navigationController.viewControllers.count > 0) {
        controller.hidesBottomBarWhenPushed = YES;
    }
    
    if (animation == NavigationTransAnimationDefault) {
        [self.navigationController pushViewController:controller animated:YES];
    }else if (animation == NavigationTransAnimationFade){
        [self.navigationController pushViewController:controller animated:NO];
        [self.navigationController.view.layer addAnimation:[self transactionFade] forKey:nil];
    }else{
        [self.navigationController pushViewController:controller animated:NO];
        [self.navigationController.view.layer addAnimation:[self transactionPushIn] forKey:nil];
    }
    
}


- (void)popController{
    [self popControllerWithAnimatiom:NavigationTransAnimationDefault];
}

- (void)popControllerWithAnimatiom:(NavigationTransAnimation)animation{
    
    if (animation == NavigationTransAnimationDefault) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (animation == NavigationTransAnimationFade){
        [self.navigationController.view.layer addAnimation:[self transactionFade] forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController.view.layer addAnimation:[self transactionPushOut] forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

- (CATransition *)transactionPushIn{
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.3;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    //    transition.
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    transition.removedOnCompletion = YES;
    
    return transition;
}

- (CATransition *)transactionPushOut{
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.3;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    //    transition.
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    transition.removedOnCompletion = YES;
    
    return transition;
}

- (CATransition *)transactionFade{
    CATransition* transition = [CATransition animation];
    //执行时间长短
    transition.duration = 0.3;
    //动画的开始与结束的快慢
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //各种动画效果
    //    transition.
    transition.type = kCATransitionFade; //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //动画方向
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    transition.removedOnCompletion = YES;
    
    return transition;
}

@end
