//
//  CYLTabBarController.m
//  CYLCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLTabBarController.h"
#import "CYLTabBar.h"
#import "CYLPlusButton.h"
#import <objc/runtime.h>

#import "KOBarItemView.h"

NSString *const CYLTabBarItemTitle = @"CYLTabBarItemTitle";
NSString *const CYLTabBarItemImage = @"CYLTabBarItemImage";
NSString *const CYLTabBarItemSelectedImage = @"CYLTabBarItemSelectedImage";

NSUInteger CYLTabbarItemsCount = 0;
NSUInteger CYLPlusButtonIndex = 0;
CGFloat CYLTabBarItemWidth = 0.0f;
NSString *const CYLTabBarItemWidthDidChangeNotification = @"CYLTabBarItemWidthDidChangeNotification";

@interface NSObject (CYLTabBarControllerItemInternal)

- (void)cyl_setTabBarController:(CYLTabBarController *)tabBarController;

@end



@interface CYLTabBarController () <UITabBarControllerDelegate>


/** 自定义按钮们 **/
@property (nonatomic, strong) NSMutableArray *barItemViews;

@end
@implementation CYLTabBarController

@synthesize viewControllers = _viewControllers;

#pragma mark -
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 处理tabBar，使用自定义 tabBar 添加 发布按钮
    [self setUpTabBar];
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[KOBarItemView class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    [((CYLTabBar *)self.tabBar) addIndictorView];
}

#pragma mark -
#pragma mark - public Methods

+ (BOOL)havePlusButton {
    if (CYLExternPlusButton) {
        return YES;
    }
    return NO;
}

+ (NSUInteger)allItemsInTabBarCount {
    NSUInteger allItemsInTabBar = CYLTabbarItemsCount;
    if ([CYLTabBarController havePlusButton]) {
        allItemsInTabBar += 1;
    }
    return allItemsInTabBar;
}

- (id<UIApplicationDelegate>)appDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (UIWindow *)rootWindow {
    UIWindow *result = nil;
    
    do {
        if ([self.appDelegate respondsToSelector:@selector(window)]) {
            result = [self.appDelegate window];
        }
        
        if (result) {
            break;
        }
    } while (NO);
    
    return result;
}

#pragma mark -
#pragma mark - Private Methods

/**
 *  利用 KVC 把系统的 tabBar 类型改为自定义类型。
 */
- (void)setUpTabBar {
    [self setValue:[[CYLTabBar alloc] init] forKey:@"tabBar"];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        if ((!_tabBarItemsAttributes) || (_tabBarItemsAttributes.count != viewControllers.count)) {
            [NSException raise:@"CYLTabBarController" format:@"The count of CYLTabBarControllers is not equal to the count of tabBarItemsAttributes.【Chinese】设置_tabBarItemsAttributes属性时，请确保元素个数与控制器的个数相同，并在方法`-setViewControllers:`之前设置"];
        }
        
        if (CYLPlusChildViewController) {
            NSMutableArray *viewControllersWithPlusButton = [NSMutableArray arrayWithArray:viewControllers];
            [viewControllersWithPlusButton insertObject:CYLPlusChildViewController atIndex:CYLPlusButtonIndex];
            _viewControllers = [viewControllersWithPlusButton copy];
        } else {
            _viewControllers = [viewControllers copy];
        }
        CYLTabbarItemsCount = [viewControllers count];
        CYLTabBarItemWidth = ([UIScreen mainScreen].bounds.size.width - CYLPlusButtonWidth) / (CYLTabbarItemsCount);
        NSUInteger idx = 0;
        for (UIViewController *viewController in _viewControllers) {
            NSString *title = nil;
            NSString *normalImageName = nil;
            NSString *selectedImageName = nil;
            if (viewController != CYLPlusChildViewController) {
                title = _tabBarItemsAttributes[idx][CYLTabBarItemTitle];
                normalImageName = _tabBarItemsAttributes[idx][CYLTabBarItemImage];
                selectedImageName = _tabBarItemsAttributes[idx][CYLTabBarItemSelectedImage];
            } else {
                idx--;
            }
            
            [self addChildViewController:viewController];
            [viewController cyl_setTabBarController:self];
            idx++;
        }
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController cyl_setTabBarController:nil];
        }
        _viewControllers = nil;
    }
    
    [self initializeTabBar];
}

- (void)initializeTabBar{
    
    _barItemViews = [NSMutableArray array];
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KOBarItemView *itemView = [[KOBarItemView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / self.childViewControllers.count * idx, 0,
                                                                                  SCREEN_WIDTH / self.childViewControllers.count, self.tabBar.height)];
        
        NSString *normalImageName = _tabBarItemsAttributes[idx][CYLTabBarItemImage];
        itemView.iconView.image = [UIImage imageNamed:normalImageName];
        
        NSString *title = _tabBarItemsAttributes[idx][CYLTabBarItemTitle];
        itemView.titleLabel.text = title;
        itemView.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] init];
        [[tapRec rac_gestureSignal] subscribeNext:^(id x) {
            self.selectedIndex = idx;
            [self tabBarController:self didSelectViewController:[_viewControllers safeObjectAtIndex:idx]];
        }];
        [itemView addGestureRecognizer:tapRec];
        
        [_barItemViews addObject:itemView];
        if (idx == 0) {
            [itemView setSelected:YES];
        }else{
            [itemView setSelected:NO];
        }
        [self.tabBar addSubview:itemView];
    }];
}

#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController*)viewController {
    NSUInteger selectedIndex = tabBarController.selectedIndex;
    UIButton *plusButton = CYLExternPlusButton;
    if (CYLPlusChildViewController) {
        if ((selectedIndex == CYLPlusButtonIndex) && (viewController != CYLPlusChildViewController)) {
            plusButton.selected = NO;
        } 
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index <= 5) {
        CYLTabBar *tabBar = (CYLTabBar *)self.tabBar;
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tabBar.indicView.left = (SCREEN_WIDTH / 4 * index) + 30;
        } completion:^(BOOL finished) { }];
        
        [_barItemViews enumerateObjectsUsingBlock:^(KOBarItemView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == index) {
                [obj setSelected:YES animation:YES];
            }else{
                [obj setSelected:NO animation:YES];
            }
        }];
    }
}


@end

#pragma mark - NSObject+CYLTabBarControllerItem

@implementation NSObject (CYLTabBarControllerItemInternal)

- (void)cyl_setTabBarController:(CYLTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(cyl_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation NSObject (CYLTabBarController)

- (CYLTabBarController *)cyl_tabBarController {
    CYLTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(cyl_tabBarController));
    if (!tabBarController ) {
        if ([self isKindOfClass:[UIViewController class]] && [(UIViewController *)self parentViewController]) {
            tabBarController = [[(UIViewController *)self parentViewController] cyl_tabBarController];
        } else {
            id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
            UIWindow *window = delegate.window;
            if ([window.rootViewController isKindOfClass:[CYLTabBarController class]]) {
                tabBarController = (CYLTabBarController *)window.rootViewController;
            }
        }
    }
    return tabBarController;
}

@end