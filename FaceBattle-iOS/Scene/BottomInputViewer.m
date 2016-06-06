//
//  BottomInputViewer.m
//  MeiYuan
//
//  Created by kino on 16/6/1.
//
//

#import "BottomInputViewer.h"

#import "HPGrowingTextView.h"


#import "IQKeyboardManager.h"


@interface BottomInputViewer()<HPGrowingTextViewDelegate>



@end

@implementation BottomInputViewer{
    UIView *_backMaskView;
    
    UIView *_inputView;
    HPGrowingTextView *_growTextView;
//    UIButton *_sendButton;
}

+ (instancetype)viewerWithPlaceHolder:(NSString *)placeStr
                          sendHandler:(void(^)(BottomInputViewer *viewer, NSString *sendStr))postHandler{
    
    BottomInputViewer *viewer = [[BottomInputViewer alloc] init];
    [viewer commonInit];
    viewer.postHandler = postHandler;
    
    return viewer;
}

- (void)commonInit{
    
    _backMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backMaskView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    _backMaskView.alpha = 0.f;
    _backMaskView.userInteractionEnabled = YES;
    
    useWeakSelf
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * tap) {
        [weakSelf cancelAction];
    }];
    [_backMaskView addGestureRecognizer:tap];
    
    
    _inputView = [[UIView alloc] init];
    _inputView.backgroundColor = [UIColor whiteColor];
    
    
    _growTextView = [[HPGrowingTextView alloc] init];
    _growTextView.backgroundColor = [UIColor cloudsColor];
    _growTextView.returnKeyType = UIReturnKeySend;
    _growTextView.maxNumberOfLines = 5;
    _growTextView.minHeight = 30;
    _growTextView.placeholder = @"写上你的评论吧~";
    _growTextView.delegate = self;
    
    /**
     *  layout
     */
    [[UIApplication sharedApplication].keyWindow addSubview:_backMaskView];
    [_backMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backMaskView.superview);
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_inputView];
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
//        make.top.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    
    [_inputView addSubview:_growTextView];
    [_growTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-10);
    }];
}


- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
    [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height + 8);
        
    }];
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    
    if (self.postHandler) {
        self.postHandler(self, _growTextView.text);
    }
    
    return YES;
}

- (void)showInWindow{
    [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backMaskView.alpha = 0.7;
    } completion:^(BOOL finished) {
        
    }];
    
    [self listeningKeyboardEvents];
    
    //show keyboard
    [_growTextView becomeFirstResponder];
}

- (void)listeningKeyboardEvents{
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *x) {
        NSDictionary* info = [x userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.mas_equalTo(-kbSize.height);
                             }];
                             [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
                         } completion:nil];
    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *x) {
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.mas_equalTo(_inputView.height);
                             }];
                             [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
                         } completion:nil];
    }];
    
}


- (void)cancelAction{
    [self hideInWindow];
    if (self.cancelHandler) {
        self.cancelHandler(self);
    }
}

- (void)hideInWindow{
    [_growTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _backMaskView.alpha = 0.0;
        
        [_inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCREEN_HEIGHT);
        }];
        
        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_backMaskView removeFromSuperview];
        _backMaskView = nil;
        
        [_inputView removeFromSuperview];
        _inputView = nil;
        
        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    }];
}


@end
