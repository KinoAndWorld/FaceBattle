//
//  FBTextField.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "FBTextField.h"

@implementation FBTextField

- (void)awakeFromNib{
    [self applyRoundBorderStyle:10 borderColor:[UIColor appBlackColor] borderWidth:2];
    self.backgroundColor = [UIColor clearColor];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}


@end
