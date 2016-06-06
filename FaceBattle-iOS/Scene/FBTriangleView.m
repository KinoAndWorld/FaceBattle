//
//  FBTriangleView.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "FBTriangleView.h"

@implementation FBTriangleView

- (id)initWithFrame:(CGRect)frame
          fillColor:(UIColor *)fillColor
        strokeColor:(UIColor *)strokeColor{
    if (self = [super initWithFrame:frame]) {
        self.fillColor = fillColor;
        self.strokeColor = strokeColor;
        self.opaque = YES;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        self.fillColor = [UIColor appYellowColor];
        self.strokeColor = [UIColor appYellowColor];
        self.opaque = YES;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    //// Polygon Drawing
    UIBezierPath* polygonPath = [UIBezierPath bezierPath];
    [polygonPath moveToPoint: CGPointMake(1, 0)];
    [polygonPath addLineToPoint: CGPointMake(30, 0)];
    [polygonPath addLineToPoint: CGPointMake(15, 10)];
    polygonPath.lineJoinStyle = kCGLineJoinBevel;
    [polygonPath closePath];
    [self.fillColor setFill];
    [polygonPath fill];
    [self.strokeColor setStroke];
    polygonPath.lineWidth = 1;
    [polygonPath stroke];
}

@end
