//
//  PresenterManager.h
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import <Foundation/Foundation.h>

#define Presenter [PresenterManager sharedManager]


typedef void(^VoidBlock)();

@interface PresenterManager : NSObject

+ (PresenterManager *)sharedManager;


/**
 *  显示各种Message
 */
- (void)showSuccessMessage:(NSString *)msg inController:(UIViewController *)controller;
- (void)showFailureMessage:(NSString *)msg inController:(UIViewController *)controller;
- (void)showMessage:(NSString *)msg inController:(UIViewController *)controller;


/**
 *  加载视图
 */
- (void)startLoadingOnView:(UIView *)view;
- (void)startLoadingWithAlpha:(CGFloat)alpha OnView:(UIView *)view;
- (void)startLoadingWithAlpha:(CGFloat)alpha withFrame:(CGRect)frame OnView:(UIView *)view;

- (void)stopLoading;

/**
 *  停止加载并且显示错误提示页面
 */
- (void)stopLoadingAndShowErrorOnView:(UIView *)view;

- (void)stopLoadingAndHandleError:(NSError *)err controller:(UIViewController *)controller;

- (void)showAndHandleError:(NSError *)err controller:(UIViewController *)controller;

/**
 *  显示错误提示页面
 */
- (void)showFailureViewAndRecallHanlde:(void(^)())callBack
                           inContainer:(UIView *)view;

- (void)showFailureViewAndRecallHanlde:(void(^)())callBack
                           inContainer:(UIView *)view
                               message:(NSString *)errorMessage;
- (void)hideFailureView;

- (void)showNetworkFailAlert;


#pragma mark - BlankView

- (void)showBlankView:(UIView *)view message:(NSString *)message;
- (UIView *)showBlankView:(UIView *)view icon:(UIImage *)image message:(NSString *)message;


- (UIView *)showBlankView:(CGRect)frame
                     icon:(UIImage *)image
                  message:(NSString *)message
                container:(UIView *)container;

- (void)showBlankViewWithFrame:(CGRect)frame message:(NSString *)message OnView:(UIView *)view;

- (void)hideBlankView;

#pragma mark - Mask

- (void)showBlackMaskBehineView:(UIView *)someView OnView:(UIView *)view;

- (void)hideBlackMaskView;

- (void)showBlackMaskInWindow:(UIWindow *)window;

@end
