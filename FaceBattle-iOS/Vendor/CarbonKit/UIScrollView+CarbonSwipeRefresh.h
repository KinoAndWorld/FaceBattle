//
//  UIScrollView+CarbonSwipeRefresh.h
//  MeiYuan
//
//  Created by kino on 16/5/9.
//
//

#import <UIKit/UIKit.h>
//

@class CarbonSwipeRefresh;

@interface UIScrollView (CarbonSwipeRefresh)

/** 下拉刷新控件 */
@property (strong, nonatomic) CarbonSwipeRefresh *carbon_header;

@end
