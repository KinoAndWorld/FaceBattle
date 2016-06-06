//
//  AppElementConfig.m
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import "AppElementConfig.h"

#import <objc/runtime.h>

@implementation UIColor (ConfigColor)

+ (UIColor *)backgroundLightColor{
    return [UIColor colorWithHex:0xf5f5f5];
}

//cell分割线
+ (UIColor *)cellSpColoc{
    return [UIColor colorWithWhite:0.9 alpha:1.000];
}

+ (UIColor *)textColor{
    return [UIColor colorWithHex:0x525252];
}

+ (UIColor *)appYellowColor{
    return [UIColor colorWithHex:0xFFD337];
}
+ (UIColor *)appBlackColor{
    return [UIColor colorWithHex:0x1F1F1F];
}

//通过颜色来生成一个纯色图片
- (UIImage *)createPureImageBySize:(CGSize)size{
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
//    // Add a clip before drawing anything, in the shape of an rounded rect
//    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)
//                                cornerRadius:8.0] addClip];
//    // Draw your image
//    [image drawInRect:imageView.bounds];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end


@implementation UIButton (ConfigButton)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.titleLabel.font.pointSize;
        self.titleLabel.font = [UIFont applicationFontOfSize:fontSize];
//        NSLog(@"%@",  [UIFont applicationFontOfSize:fontSize]);
    }
    return self;
}

+ (UIButton *)commonButtonWithTitle:(NSString *)title bgColor:(UIColor *)color{
    UIButton *commonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commonButton setBackgroundColor:color];
    [commonButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commonButton setTitle:title forState:UIControlStateNormal];
    commonButton.titleLabel.font = [UIFont applicationFontOfSize:15.f];
    
    return commonButton;
}

- (void)applyAbleStyleWithTitle:(NSString *)title color:(UIColor *)color enable:(BOOL)enable{
    //    [self setBackgroundImage:[UIImage imageNamed:@"mainOKButton"] forState:UIControlStateNormal];
    [self setBackgroundColor:color];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    self.userInteractionEnabled = enable;
}

@end


@implementation UILabel (ConfigLabel)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        CGFloat fontSize = self.font.pointSize;
        self.font = [UIFont applicationFontOfSize:fontSize];
    }
    return self;
}


/* Attribute String Contrust Method */

- (void)setText:(NSString *)text withColor:(UIColor *)subStrColor forSubStr:(NSString *)subStr{
    return [self setText:text withColor:nil withFont:nil subColor:subStrColor subFont:nil forSubStr:subStr];
}

- (void)setText:(NSString *)text withFont:(UIFont *)subStrFont forSubStr:(NSString *)subStr{
    return [self setText:text withColor:nil withFont:nil subColor:nil subFont:subStrFont forSubStr:subStr];
}

- (void)setText:(NSString *)text withColor:(UIColor *)subStrColor withFont:(UIFont *)subStrFont forSubStr:(NSString *)subStr{
    return [self setText:text withColor:nil withFont:nil subColor:subStrColor subFont:subStrFont forSubStr:subStr];
}

- (void)setText:(NSString *)text withColor:(UIColor *)color withFont:(UIFont *)font subColor:(UIColor *)subStrColor subFont:(UIFont *)subStrFont forSubStr:(NSString *)subStr{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    if (color) {
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length)];
    }
    
    if (font) {
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    }
    
    if (subStr) {
        if (subStrColor) {
            NSRange findRange = [text rangeOfString:subStr];
            
            [attrString addAttribute:NSForegroundColorAttributeName value:subStrColor range:findRange];
        }
        if (subStrFont) {
            NSRange findRange = [text rangeOfString:subStr];
            [attrString addAttribute:NSFontAttributeName value:subStrFont range:findRange];
        }
    }
    
    self.attributedText = attrString;
}

@end


@implementation UIFont (ConfigFont)

+ (UIFont *)applicationFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"Comic Sans MS" size:size];
}

@end


@implementation UIView (ConfigView)


- (void)applyRoundStyle:(CGFloat)radius{
    self.layer.cornerRadius = radius;
}

- (void)applyRoundBorderStyle:(CGFloat)radius{
    [self applyRoundBorderStyle:radius borderColor:[UIColor clearColor]];
}

- (void)applyRoundBorderStyle:(CGFloat)radius borderColor:(UIColor *)color{
    return [self applyRoundBorderStyle:radius borderColor:color borderWidth:1];
}

- (void)applyRoundBorderStyle:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(float)width{
    self.layer.cornerRadius = radius;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}




/**
 *  new effect
 */
- (void)applyShadowWithCornerStyle:(CGFloat)radius shadowRadius:(CGFloat)shadowRadius offset:(CGSize)offset{
    self.layer.masksToBounds = NO;
//    self.layer.cornerRadius = radius;
    self.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = offset;//默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    self.layer.shadowRadius = shadowRadius;//阴影半径，默认3
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
}

- (void)applyShadowWithCornerStyle:(CGFloat)radius{
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = radius;
    self.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,0);//默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    self.layer.shadowRadius = 2;//阴影半径，默认3
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
}

- (void)applyCornerStyle:(CGFloat)radius corner:(UIRectCorner)corner{
    
    if (!CGRectEqualToRect(CGRectZero, self.bounds)) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                       byRoundingCorners:corner
                                                             cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}

/// ============================

- (void)applyTopLine{
    [self removeTopLine];
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.f, 0.f, self.width, 1.0f);
    bottomBorder.name = @"topLine";
    bottomBorder.backgroundColor = [UIColor cellSpColoc].CGColor;
    [self.layer addSublayer:bottomBorder];
}

- (void)removeTopLine{
    __block CALayer *needDeleteLayer;
    [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([((CALayer *)obj).name isEqualToString:@"topLine"]) {
            needDeleteLayer = obj;
            *stop = YES;
        }
    }];
    [needDeleteLayer removeFromSuperlayer];
}

- (void)applyBottomLine{
    [self removeBottomLine];
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.height-1, SCREEN_WIDTH, 1.0f);
    bottomBorder.name = @"bottomLine";
    bottomBorder.backgroundColor = [UIColor cellSpColoc].CGColor;
    [self.layer addSublayer:bottomBorder];
}

- (void)applyBottomLineWithX:(CGFloat)xPos width:(CGFloat)width{
    [self removeBottomLine];
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(xPos, self.height-1, width, 1.0f);
    bottomBorder.name = @"bottomLine";
    bottomBorder.backgroundColor = [UIColor cellSpColoc].CGColor;
    [self.layer addSublayer:bottomBorder];
}

- (void)removeBottomLine{
    __block CALayer *needDeleteLayer;
    [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([((CALayer *)obj).name isEqualToString:@"bottomLine"]) {
            needDeleteLayer = obj;
            *stop = YES;
        }
    }];
    [needDeleteLayer removeFromSuperlayer];
}

- (UIImage *)screenShotFromSelf{
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    return viewImage;
}


- (UILabel *)configLabelWithFontSize:(CGFloat)size textColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont applicationFontOfSize:size];
    label.textColor = color;
    label.text = @"10086";
    
    return label;
}


- (void)addBadgeLayerWithnumber:(NSUInteger)number backColor:(UIColor *)backColor{
    
    [self removeBadgeLayer];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(self.right - 10, self.top - 8, 20, 20);
    
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
    
    layer.backgroundColor = backColor.CGColor;
    layer.name = @"MY_Badge_Layer";
    
    
    CATextLayer *textLayer = [CATextLayer layer];
    
    textLayer.foregroundColor = [UIColor whiteColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    
    
    textLayer.frame = CGRectMake(0, layer.bounds.size.height / 2 - 8, 20, 16);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:12];
    
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    if (number > 99) {
        textLayer.position = CGPointMake(textLayer.position.x, textLayer.position.y + 2);
        textLayer.string = @"99+";
        textLayer.fontSize = 9;
    }else{
        textLayer.string = [NSString stringWithFormat:@"%d",(int)number];
    }
    
    
    [layer addSublayer:textLayer];
    [self.superview.layer addSublayer:layer];
}

- (void)removeBadgeLayer{
    [[self.superview.layer sublayers] enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"MY_Badge_Layer"]) {
            [obj removeFromSuperlayer];
            *stop = YES;
        }
    }];
}


- (UIView *)addLineViewInTop{
    return [self addLineViewWithLeft:0 right:0 isTop:YES color:[UIColor colorWithWhite:0.95 alpha:1.0]];
}

- (UIView *)addLineViewInBottom{
    return [self addLineViewWithLeft:0 right:0 isTop:NO color:[UIColor colorWithWhite:0.95 alpha:1.0]];
}


- (UIView *)addLineViewWithLeft:(float)left right:(float)right isTop:(BOOL)top color:(UIColor *)color{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = color;
    
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(right);
        make.height.mas_equalTo(1);
        if (top) {
            make.top.mas_equalTo(0);
        }else{
            make.bottom.mas_equalTo(0);
        }
    }];
    
    return line;
}


@end


@implementation UIImage (configImage)

+ (UIImage *)placeHolderImage{
    return [UIImage imageNamed:@"placeHolder"];
}

+ (UIImage *)placeHolderImageForAvatar{
    return [UIImage imageNamed:@"tabPeople"];
}

- (UIImage *)createCornerImageBySize:(CGSize)size corner:(float)corner{
    
    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)].CGPath);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}

//截取部分图像
- (UIImage *)getSubImage:(CGRect)rect{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//等比例缩放
- (UIImage *)scaleToSize:(CGSize)size{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end



@implementation NSString (configString)

- (CGRect)frameWithWidth:(float)width fontSize:(float)fSize{
    
    if ([self isEqualToString:@""]) {
        return CGRectZero;
    }
    
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont applicationFontOfSize:fSize]} context:nil];
}

- (BOOL)isPureNumandCharacters{
    NSString *result = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(result.length > 0){
        return NO;
    }
    return YES;
}

- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end
