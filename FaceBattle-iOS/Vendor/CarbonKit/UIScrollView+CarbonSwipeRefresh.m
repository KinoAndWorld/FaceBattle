//
//  UIScrollView+CarbonSwipeRefresh.m
//  MeiYuan
//
//  Created by kino on 16/5/9.
//
//

#import "UIScrollView+CarbonSwipeRefresh.h"

#import "CarbonSwipeRefresh.h"

#import <objc/runtime.h>


@implementation UIScrollView (CarbonSwipeRefresh)

#pragma mark - header
static const char CarbonRefreshHeaderKey = 'c';

- (void)setCarbon_header:(CarbonSwipeRefresh *)carbon_header{
    if (carbon_header != self.carbon_header) {
        // 删除旧的，添加新的
        [self.carbon_header removeFromSuperview];
        [self insertSubview:carbon_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"carbon_header"]; // KVO
        objc_setAssociatedObject(self, &CarbonRefreshHeaderKey,
                                 carbon_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"carbon_header"]; // KVO
    }
}

- (CarbonSwipeRefresh *)carbon_header{
    return objc_getAssociatedObject(self, &CarbonRefreshHeaderKey);
}



@end
