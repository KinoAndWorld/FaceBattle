//
//  UIViewController+Control.m
//  HomeInns-iOS
//
//  Created by kino on 15/9/6.
//
//

#import "UIViewController+Control.h"

@implementation UIViewController (Control)

- (UIButton *)setNavgationItemWithImage:(UIImage *)image position:(NavgationItemPosition)position{
    UIButton *button;
    
    if (position == NavgationItemPositionLeft) {
        [self.navigationItem setLeftBarButtonItem:({
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 40, 40);
            [button setImage:image forState:UIControlStateNormal];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
            item;
        })];
    }else{
        [self.navigationItem setRightBarButtonItem:({
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 40, 40);
            [button setImage:image forState:UIControlStateNormal];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
            item;
        })];
    }
    return button;
}

- (UIButton *)setNavgationItemWithTitle:(NSString *)title
                              textColor:(UIColor *)textColor
                               position:(NavgationItemPosition)position{
    UIButton *button;
    
    if (position == NavgationItemPositionLeft) {
        [self.navigationItem setLeftBarButtonItem:({
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 90, 50);
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:textColor forState:UIControlStateNormal];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
            item;
        })];
    }else{
        [self.navigationItem setRightBarButtonItem:({
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 90, 50);
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:textColor forState:UIControlStateNormal];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
            item;
        })];
    }
    return button;
}

- (void)setNavgationCitySelectionWithCityName:(NSString *)currentCityName
                                   cityButton:(UIButton *)cityButton{
    
    CGFloat TitleViewWidthMax = SCREEN_WIDTH - 100;
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,TitleViewWidthMax,44)];
    [iv setBackgroundColor:[UIColor clearColor]];
    
    CGSize cityNameSize = [currentCityName sizeWithFont:[UIFont systemFontOfSize:15]];
    cityNameSize.width = MIN(TitleViewWidthMax, cityNameSize.width+5);
    
    [cityButton setFrame:CGRectMake(iv.frame.size.width/2 - cityNameSize.width/2, 0, cityNameSize.width, 44)];
    [cityButton setTitle:currentCityName
                 forState:UIControlStateNormal];
    [cityButton setTitleColor:[UIColor colorWithRed:0.448 green:0.293 blue:0.152 alpha:1.000]
                      forState:UIControlStateNormal];
//    [cityButton addTarget:self action:@selector(citySelectAction) forControlEvents:UIControlEventTouchUpInside];
    cityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cityButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    cityButton.titleLabel.minimumScaleFactor = 0.5f;
    
    UIImageView *titleIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(cityButton.frame.origin.x + cityButton.frame.size.width + 2, 18, 12, 9)];
    titleIndicator.image = [UIImage imageNamed:@"expandIcon"];
    [iv addSubview:titleIndicator];
    
    [iv addSubview:cityButton];
    
    self.navigationItem.titleView = iv;
}

- (void)setNavigationBarWithImage:(UIImage *)image{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


- (void)changeNavgationBarAlpha:(CGFloat)alpha{
    if (alpha == 0.f) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                           forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setStatusBarStyle:(UIStatusBarStyle)style{
    [UIApplication sharedApplication].statusBarStyle = style;
}

@end
