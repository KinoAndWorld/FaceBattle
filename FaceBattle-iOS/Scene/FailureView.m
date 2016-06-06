//
//  FailureView.m
//  HomeInns-iOS
//
//  Created by kino on 15/11/2.
//  Copyright © 2015年 BestApp. All rights reserved.
//

#import "FailureView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FailureView()



@end

@implementation FailureView{
    UIImageView *netErrImageView;
    UILabel *messageLabel;
    UIButton *recallButton;
}

- (id)initWithFrame:(CGRect)frame recallHandle:(void(^)())recallBlock{
    if (self = [super initWithFrame:frame]) {
        self.recallBlock = recallBlock;
        [self commonInit];
    }
    return self;
}

- (id)initWithRecallHandle:(void(^)())recallBlock{
    return [self initWithFrame:CGRectZero recallHandle:recallBlock];
}

- (void)commonInit{
    self.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1];
    
    netErrImageView = [[UIImageView alloc] init];//178 138
    netErrImageView.image = [UIImage imageNamed:@"networkError"];
    
    messageLabel = [[UILabel alloc] init];
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.font = [UIFont applicationFontOfSize:12.f];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = [UIColor clearColor];
    
    recallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recallButton.titleLabel.font = [UIFont applicationFontOfSize:16.f];
    [recallButton setTitle:@"点击重试" forState:UIControlStateNormal];
    [recallButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [recallButton applyRoundBorderStyle:4.f borderColor:[UIColor grayColor]];
    
    [[recallButton rac_signalForControlEvents:UIControlEventTouchUpOutside] subscribeNext:^(id x) {
        if (self.recallBlock) {
            self.recallBlock();
        }
    }];
    
    [self addSubview:netErrImageView];
    [self addSubview:messageLabel];
    [self addSubview:recallButton];
    
    self.message = @"当前网络状态异常或无网络";
}

- (void)layoutSubviews{
    
    netErrImageView.frame = CGRectMake(0, 0, 89, 69);
    netErrImageView.center = CGPointMake(self.centerX , MAX(60, self.centerY - 100));
    
    messageLabel.frame = CGRectMake(0, netErrImageView.bottom + 20,self.width, 30);
    recallButton.frame = CGRectMake(self.width/2 - 100, messageLabel.bottom + 20, 200, 40);
}

- (void)setMessage:(NSString *)message{
    if (message) {
        messageLabel.text = message;
    }
}


@end
