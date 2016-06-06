//
//  AppElementConfig.h
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import <Foundation/Foundation.h>

#import <UIView+YYAdd.h>

#import "UIViewController+Control.h"


@interface UIColor (ConfigColor)

//浅色背景
+ (UIColor *)backgroundLightColor;

//cell分割线
+ (UIColor *)cellSpColoc;

+ (UIColor *)textColor;



+ (UIColor *)appYellowColor;
+ (UIColor *)appBlackColor;

//通过颜色来生成一个纯色图片
- (UIImage *)createPureImageBySize:(CGSize)size;


@end


@interface UIButton (ConfigButton)

//- (void)applyButtonStyle;
+ (UIButton *)commonButtonWithTitle:(NSString *)title bgColor:(UIColor *)color;

- (void)applyAbleStyleWithTitle:(NSString *)title color:(UIColor *)color enable:(BOOL)enable;

@end

@interface UILabel (ConfigLabel)

/* Attribute String Contrust Method */

- (void)setText:(NSString *)text withColor:(UIColor *)subStrColor forSubStr:(NSString *)subStr;

- (void)setText:(NSString *)text withFont:(UIFont *)subStrFont forSubStr:(NSString *)subStr;

- (void)setText:(NSString *)text withColor:(UIColor *)subStrColor withFont:(UIFont *)subStrFont forSubStr:(NSString *)subStr;

- (void)setText:(NSString *)text withColor:(UIColor *)color withFont:(UIFont *)font subColor:(UIColor *)subStrColor subFont:(UIFont *)subStrFont forSubStr:(NSString *)subStr;

@end


@interface UIFont (ConfigFont)

+ (UIFont *)applicationFontOfSize:(CGFloat)size;

@end



@interface UIView (ConfigView)


- (void)applyRoundStyle:(CGFloat)radius;
- (void)applyRoundBorderStyle:(CGFloat)radius;
- (void)applyRoundBorderStyle:(CGFloat)radius borderColor:(UIColor *)color;
- (void)applyRoundBorderStyle:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(float)width;


- (void)applyShadowWithCornerStyle:(CGFloat)radius;
- (void)applyShadowWithCornerStyle:(CGFloat)radius shadowRadius:(CGFloat)shadowRadius offset:(CGSize)offset;

- (void)applyCornerStyle:(CGFloat)radius corner:(UIRectCorner)corner;


- (void)applyTopLine;
- (void)removeTopLine;
- (void)applyBottomLine;
- (void)applyBottomLineWithX:(CGFloat)xPos width:(CGFloat)width;

- (UIImage *)screenShotFromSelf;

- (UILabel *)configLabelWithFontSize:(CGFloat)size textColor:(UIColor *)color;

- (void)addBadgeLayerWithnumber:(NSUInteger)number backColor:(UIColor *)backColor;


- (UIView *)addLineViewInTop;
- (UIView *)addLineViewInBottom;
- (UIView *)addLineViewWithLeft:(float)left right:(float)right isTop:(BOOL)top color:(UIColor *)color;


@end



@interface UIImage (configImage)

+ (UIImage *)placeHolderImage;
+ (UIImage *)placeHolderImageForAvatar;

- (UIImage *)createCornerImageBySize:(CGSize)size corner:(float)corner;


//截取部分图像
- (UIImage *)getSubImage:(CGRect)rect;

//等比例缩放
- (UIImage *)scaleToSize:(CGSize)size;

@end


@interface NSString (configString)

- (CGRect)frameWithWidth:(float)width fontSize:(float)fSize;

- (BOOL)isPureNumandCharacters;
- (BOOL)isPureFloat;

@end













