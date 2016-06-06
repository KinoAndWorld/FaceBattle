//
//  KOBarItemView.h
//  MeiYuan
//
//  Created by kino on 16/5/20.
//
//

#import <UIKit/UIKit.h>

@interface KOBarItemView : UIView

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;

- (void)setSelected:(BOOL)isSelected;

- (void)setSelected:(BOOL)isSelected animation:(BOOL)anima;

@end
