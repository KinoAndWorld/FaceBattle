//
//  KOBarItemView.m
//  MeiYuan
//
//  Created by kino on 16/5/20.
//
//

#import "KOBarItemView.h"

@implementation KOBarItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    _iconView = [[UIImageView alloc] init];
    _iconView.frame = CGRectMake(self.width/2 - 10, 12, 20, 20);
//    _iconView.backgroundColor = [UIColor belizeHoleColor];
    [self addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, 32, self.width, 12);
    _titleLabel.font = [UIFont boldSystemFontOfSize:10.f];
    _titleLabel.textColor = [UIColor turquoiseColor];
//    _titleLabel.text = @"标题";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleLabel];
}

- (void)setSelected:(BOOL)isSelected{
    [self setSelected:isSelected animation:NO];
}

- (void)setSelected:(BOOL)isSelected animation:(BOOL)anima{
    
    NSTimeInterval interv = anima ? 0.5 : 0;
    if (isSelected) {
        [UIView animateWithDuration:interv animations:^{
            _titleLabel.alpha = 1.f;
            _iconView.top = 8.f;
            _iconView.alpha = 1.f;
        }];
    }else{
        [UIView animateWithDuration:interv animations:^{
            _titleLabel.alpha = 0.f;
            _iconView.top = 12.f;
            _iconView.alpha = 0.8;
        }];
    }
}

@end
