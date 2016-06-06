//
//  CYLTabBar.m
//  CYLCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 10/20/15.
//  Copyright © 2015 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLTabBar.h"
#import "CYLPlusButton.h"
#import "CYLTabBarController.h"

//#import "KOBarItemView.h"

static void *const CYLTabBarContext = (void*)&CYLTabBarContext;

@interface CYLTabBar ()

/** 发布按钮 */
@property (nonatomic, strong) UIButton<CYLPlusButtonSubclassing> *plusButton;
@property (nonatomic, assign) CGFloat tabBarItemWidth;


@property (assign, nonatomic) NSUInteger selectedIdx;


@end

@implementation CYLTabBar

#pragma mark -
#pragma mark - LifeCycle Method

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)sharedInit {
//    self.delegate = self;
    
    if (CYLExternPlusButton) {
        self.plusButton = CYLExternPlusButton;
        [self addSubview:(UIButton *)self.plusButton];
    }
    // KVO注册监听
    _tabBarItemWidth = CYLTabBarItemWidth;
    [self addObserver:self forKeyPath:@"tabBarItemWidth" options:NSKeyValueObservingOptionNew context:CYLTabBarContext];
    
    return self;
}

- (void)addIndictorView{
    _indicView = [[UIView alloc] init];
    _indicView.backgroundColor = [UIColor turquoiseColor];
    _indicView.frame = CGRectMake(30, 0, SCREEN_WIDTH / 4 - 60, 2);
    [self addSubview:_indicView];
}

//- (void)reloadItemViews{
//    NSArray *sortedSubviews = [self sortedSubviews];
//    NSArray *tabBarButtonArray = [self tabBarButtonFromTabBarSubviews:sortedSubviews];
//    
//    _barItemViews = [NSMutableArray array];
//    [tabBarButtonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        KOBarItemView *itemView = [[KOBarItemView alloc] initWithFrame:[obj bounds]];
//        itemView.userInteractionEnabled = NO;
//        itemView.backgroundColor = [UIColor cloudsColor];
//        
//        [_barItemViews addObject:itemView];
//        if (idx == 0) {
//            [itemView setSelected:YES];
//        }else{
//            [itemView setSelected:NO];
//        }
////        ((UIView *)obj).hidden = YES;
//        
//        [self addSubview:itemView];
//    }];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat barWidth = self.bounds.size.width;
    CGFloat barHeight = self.bounds.size.height;
    CYLTabBarItemWidth = (barWidth - CYLPlusButtonWidth) / CYLTabbarItemsCount;
    self.tabBarItemWidth = CYLTabBarItemWidth;
    if (!CYLExternPlusButton) {
        return;
    }
    CGFloat multiplerInCenterY = [self multiplerInCenterY];
    self.plusButton.center = CGPointMake(barWidth * 0.5, barHeight * multiplerInCenterY);
    NSUInteger plusButtonIndex = [self plusButtonIndex];
    NSArray *sortedSubviews = [self sortedSubviews];
    NSArray *tabBarButtonArray = [self tabBarButtonFromTabBarSubviews:sortedSubviews];
    
    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
        //调整UITabBarItem的位置
        CGFloat childViewX;
        if (buttonIndex >= plusButtonIndex) {
            childViewX = buttonIndex * CYLTabBarItemWidth + CYLPlusButtonWidth;
        } else {
            childViewX = buttonIndex * CYLTabBarItemWidth;
        }
        //仅修改childView的x和宽度,yh值不变
        childView.frame = CGRectMake(childViewX,
                                     CGRectGetMinY(childView.frame),
                                     CYLTabBarItemWidth,
                                     CGRectGetHeight(childView.frame)
                                     );
        
    }];
    //bring the plus button to top
    [self bringSubviewToFront:self.plusButton];
}

#pragma mark -
#pragma mark - Private Methods

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != CYLTabBarContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == CYLTabBarContext) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CYLTabBarItemWidthDidChangeNotification object:self];
    }
}

- (void)dealloc {
    // KVO反注册
    [self removeObserver:self forKeyPath:@"tabBarItemWidth"];
}

- (void)setTabBarItemWidth:(CGFloat )tabBarItemWidth {
    if (_tabBarItemWidth != tabBarItemWidth) {
        [self willChangeValueForKey:@"tabBarItemWidth"];
        _tabBarItemWidth = tabBarItemWidth;
        [self didChangeValueForKey:@"tabBarItemWidth"];
    }
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return NO;
}

- (CGFloat)multiplerInCenterY {
    CGFloat multiplerInCenterY;
    if ([[self.plusButton class] respondsToSelector:@selector(multiplerInCenterY)]) {
        multiplerInCenterY = [[self.plusButton class] multiplerInCenterY];
    } else {
        CGSize sizeOfPlusButton = self.plusButton.frame.size;
        CGFloat heightDifference = sizeOfPlusButton.height - self.bounds.size.height;
        if (heightDifference < 0) {
            multiplerInCenterY = 0.5;
        } else {
            CGPoint center = CGPointMake(self.bounds.size.height / 2.0f, self.bounds.size.height / 2.0f);
            center.y = center.y - heightDifference / 2.0f;
            multiplerInCenterY = center.y / self.bounds.size.height;
        }
    }
    return multiplerInCenterY;
}

- (NSUInteger)plusButtonIndex {
    NSUInteger plusButtonIndex;
    if ([[self.plusButton class] respondsToSelector:@selector(indexOfPlusButtonInTabBar)]) {
        plusButtonIndex = [[self.plusButton class] indexOfPlusButtonInTabBar];
        //仅修改self.plusButton的x,ywh值不变
        self.plusButton.frame = CGRectMake(plusButtonIndex * CYLTabBarItemWidth,
                                           CGRectGetMinY(self.plusButton.frame),
                                           CGRectGetWidth(self.plusButton.frame),
                                           CGRectGetHeight(self.plusButton.frame)
                                           );
    } else {
        if (CYLTabbarItemsCount % 2 != 0) {
            [NSException raise:@"CYLTabBarController" format:@"If the count of CYLTabbarControllers is odd,you must realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果CYLTabbarControllers的个数是奇数，你必须在你自定义的plusButton中实现`+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
        }
        plusButtonIndex = CYLTabbarItemsCount / 2.0;
    }
    CYLPlusButtonIndex = plusButtonIndex;
    return plusButtonIndex;
}

/*!
 *  Deal with some trickiness by Apple, You do not need to understand this method, somehow, it works.
 *  NOTE: If the `self.title of ViewController` and `the correct title of tabBarItemsAttributes` are different, Apple will delete the correct tabBarItem from subViews, and then trigger `-layoutSubviews`, therefore subViews will be in disorder. So we need to rearrange them.
*/
- (NSArray *)sortedSubviews {
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * view1, UIView * view2) {
        CGFloat view1_x = view1.frame.origin.x;
        CGFloat view2_x = view2.frame.origin.x;
        if (view1_x > view2_x) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    return sortedSubviews;
}

- (NSArray *)tabBarButtonFromTabBarSubviews:(NSArray *)tabBarSubviews {
    NSArray *tabBarButtonArray = [NSArray array];
    NSMutableArray *tabBarButtonMutableArray = [NSMutableArray arrayWithCapacity:tabBarSubviews.count - 1];
    [tabBarSubviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonMutableArray addObject:obj];
        }
    }];
    if (CYLPlusChildViewController) {
        [tabBarButtonMutableArray removeObjectAtIndex:CYLPlusButtonIndex];
    }
    tabBarButtonArray = [tabBarButtonMutableArray copy];
    return tabBarButtonArray;
}

/**
 *  Capturing touches on a subview outside the frame of its superview
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        UIView *result = [super hitTest:point withEvent:event];
        if (result) {
            return result;
        } else {
            for (UIView *subview in self.subviews.reverseObjectEnumerator) {
                CGPoint subPoint = [subview convertPoint:point fromView:self];
                result = [subview hitTest:subPoint withEvent:event];
                if (result) {
                    return result;
                }
            }
        }
    }
    return nil;
}

- (void)changeItemIndexTo:(NSUInteger)toIdx{
    
}

- (void)animationDisplayItem{
//    _selectedIdx
    
}

@end
