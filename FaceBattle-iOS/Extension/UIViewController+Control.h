//
//  UIViewController+Control.h
//  HomeInns-iOS
//
//  Created by kino on 15/9/6.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    NavgationItemPositionLeft,
    NavgationItemPositionRight
}NavgationItemPosition;

@interface UIViewController (Control)

- (UIButton *)setNavgationItemWithImage:(UIImage *)image
                               position:(NavgationItemPosition)position;

- (UIButton *)setNavgationItemWithTitle:(NSString *)title
                              textColor:(UIColor *)textColor
                               position:(NavgationItemPosition)position;

- (void)setNavgationCitySelectionWithCityName:(NSString *)currentCityName
                                   cityButton:(UIButton *)cityButton;

- (void)setNavigationBarWithImage:(UIImage *)image;

- (void)changeNavgationBarAlpha:(CGFloat)alpha;
- (void)setStatusBarStyle:(UIStatusBarStyle)style;

@end
