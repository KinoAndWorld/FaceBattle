//
//  FailureView.h
//  HomeInns-iOS
//
//  Created by kino on 15/11/2.
//  Copyright © 2015年 BestApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailureView : UIView

@property (copy, nonatomic) void(^recallBlock)();

@property (copy, nonatomic) NSString *message;

- (id)initWithRecallHandle:(void(^)())recallBlock;
- (id)initWithFrame:(CGRect)frame recallHandle:(void(^)())recallBlock;

@end
