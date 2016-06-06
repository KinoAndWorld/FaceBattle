//
//  PresenterManager.m
//  MeiYuan
//
//  Created by kino on 16/3/31.
//
//

#import "PresenterManager.h"

#import "FailureView.h"

#import "CSNotificationView.h"


#import "MBProgressHUD.h"
//#import "MeiYuan-Swift.h"

@interface PresenterManager()

@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UIImageView *loadingImage;

@property (strong, nonatomic) FailureView *loadFailView;

//blank
@property (strong, nonatomic) UIView *blankView;
@property (strong, nonatomic) UIImageView *blankImageView;
@property (strong, nonatomic) UILabel *blankMessageLabel;

//@property (assign, nonatomic) BOOL isLoadingData;

@property (strong, nonatomic) UIView *blackMaskView;


@property (assign, nonatomic) CGRect targetFrame;

@property (strong, nonatomic) MBProgressHUD *progressHud;

//@property (strong, nonatomic) PinballLoadingView *ballLoadingView;


@end

@implementation PresenterManager


+ (PresenterManager *)sharedManager{
    static PresenterManager *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}


#pragma mark - Plug In View

/* 加载页 */
- (UIView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.targetFrame];
        _loadingView.backgroundColor = [UIColor backgroundLightColor];
        [_loadingView addSubview:self.loadingImage];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _loadingView.width, 30)];
        lbl.text = @"正在加载中...";
        lbl.top = _loadingImage.bottom + 5;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.font = [UIFont applicationFontOfSize:15.f];
        lbl.textAlignment = NSTextAlignmentCenter;
        [_loadingView addSubview:lbl];
        
    }
    _loadingView.frame = _targetFrame;
    
    return _loadingView;
}

- (UIImageView *)loadingImage{
    if (!_loadingImage) {
        _loadingImage = [[UIImageView alloc] initWithFrame:
                         CGRectMake(_targetFrame.size.width / 2 - 100, _targetFrame.size.height/2 - 80, 200, 150)];
        
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (int i = 0; i <= 80; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"01-progress00%02d.jpg",i]];
            [tmpArr addObject:image];
        }
        [_loadingImage setAnimationImages:[NSArray arrayWithArray:tmpArr]];
        _loadingImage.animationDuration = 2.0;
        
    }
    return _loadingImage;
}

- (UIView *)blankView{
    if (!_blankView) {
        _blankView = [[UIView alloc] initWithFrame:_targetFrame];
        _blankView.top = 0;
        _blankView.left = 0;
        _blankView.backgroundColor = [UIColor whiteColor];
        
        _blankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_blankView.width/2 - 22, _blankView.height/2 - 60, 44, 63)];//178 138
        _blankImageView.contentMode = UIViewContentModeScaleAspectFill;
        _blankImageView.image = [UIImage imageNamed:@"myOrderBlank"];
        //_blankImageView.center = CGPointMake(_blankView.centerX , _blankView.centerY - 150);
        [_blankView addSubview:_blankImageView];
        //
        _blankMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _blankImageView.bottom + 20,
                                                                       _blankView.width, 30)];
        _blankMessageLabel.text = @"暂时没有任何数据";
        _blankMessageLabel.textColor = [UIColor grayColor];
        _blankMessageLabel.font = [UIFont applicationFontOfSize:15.f];
        _blankMessageLabel.textAlignment = NSTextAlignmentCenter;
        _blankMessageLabel.backgroundColor = [UIColor clearColor];
        _blankMessageLabel.numberOfLines = 0;
        
        [_blankView addSubview:_blankMessageLabel];
    }
    
    _blankView.frame = _targetFrame;
    
//    _blankImageView.frame = CGRectMake(_blankView.width/2 - 22, MAX(10, _blankView.height/2 - 80), 44, 63);
//    
//    _blankMessageLabel.frame = CGRectMake(20, _blankImageView.bottom + 20,
//                                          _blankView.width - 40, 30);
//    [_blankMessageLabel sizeToFit];
    
    return _blankView;
}

- (void)startLoadingOnView:(UIView *)view{
//    self.targetFrame = view.bounds;
//    [view addSubview:self.loadingView];
//    [self.loadingImage startAnimating];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.labelText = @"Loading";
    
    [MBProgressHUD hideHUDForView:view animated:NO];
    
    _progressHud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _progressHud.animationType = MBProgressHUDAnimationZoom;
    [_progressHud showAnimated:YES];
    
}

- (void)startLoadingWithAlpha:(CGFloat)alpha OnView:(UIView *)view{
    [self startLoadingOnView:view];
    
    if (alpha >0 && alpha<=1.0) {
        _loadingView.alpha = alpha;
    }
}

- (void)startLoadingWithAlpha:(CGFloat)alpha withFrame:(CGRect)frame OnView:(UIView *)view{
    self.targetFrame = frame;
    [view addSubview:self.loadingView];
    [self.loadingImage startAnimating];
    
    if (alpha >0 && alpha<1.0) {
        _loadingView.alpha = alpha;
    }
//    _isLoadingData = YES;
}


- (void)stopLoading{

    [_progressHud hideAnimated:YES];
    
//    [self.loadingImage stopAnimating];
//    [self.loadingView removeFromSuperview];
    [self.loadFailView removeFromSuperview];
}

/**
 *  停止加载并且显示错误提示页面
 */
- (void)stopLoadingAndShowErrorOnView:(UIView *)view{
    [self stopLoading];
    
    [view addSubview:self.loadFailView];
}

/**
 *  显示错误提示页面
 */
- (void)showFailureViewAndRecallHanlde:(void(^)())callBack
                           inContainer:(UIView *)view{
    [self showFailureViewAndRecallHanlde:callBack inContainer:view message:nil];
}
- (void)showFailureViewAndRecallHanlde:(void(^)())callBack
                           inContainer:(UIView *)view
                               message:(NSString *)errorMessage{
    [self hideFailureView];
    _loadFailView = [[FailureView alloc] initWithFrame:view.bounds recallHandle:callBack];
    _loadFailView.message = errorMessage;
    [view addSubview:_loadFailView];
}

- (void)hideFailureView{
    if (_loadFailView) {
        [_loadFailView removeFromSuperview];
        _loadFailView = nil;
    }
}

- (void)stopLoadingAndHandleError:(NSError *)err controller:(UIViewController *)controller{
    [self stopLoading];
    
    [self showAndHandleError:err controller:controller];
}

- (void)showAndHandleError:(NSError *)err controller:(UIViewController *)controller{
    if (err.userInfo && err.userInfo[@"result"]) {
        NSString *msg = err.userInfo[@"result"];
        if (msg && [msg isKindOfClass:[NSString class]] && msg.length > 0) {
            [self showFailureMessage:msg inController:controller];
        }else{
            [self showFailureMessage:@"网络请求失败 :(" inController:controller];
        }
    }else{
        [self showNetworkFailAlert];
    }
}

- (void)showNetworkFailAlert{
    //    [FCUtil showMessage: @"您的网络好像不太给力，请稍后再试"];
}


//空白视图
- (void)showBlankView:(UIView *)view message:(NSString *)message{
    _targetFrame = view.bounds;
    [view addSubview:self.blankView];
    _blankMessageLabel.text = message;
}

- (UIView *)showBlankView:(UIView *)view icon:(UIImage *)image message:(NSString *)message{
    _targetFrame = view.bounds;
    
    [view addSubview:self.blankView];
    
    _blankImageView.image = image;
    
    _blankMessageLabel.text = message;
    
    [self updateBlankViewsPos];
    
    return self.blankView;
}

- (UIView *)showBlankView:(CGRect)frame
                 icon:(UIImage *)image
              message:(NSString *)message
            container:(UIView *)container{
    _targetFrame = frame;
    [container addSubview:self.blankView];
    
    _blankImageView.image = image;
    
    _blankMessageLabel.text = message;
    
    [self updateBlankViewsPos];
    
    return _blankView;
}

- (void)showBlankViewWithFrame:(CGRect)frame message:(NSString *)message OnView:(UIView *)view{
    _targetFrame = frame;
    [view addSubview:self.blankView];
    
    _blankMessageLabel.text = message;
}

- (void)hideBlankView{
    [self.blankView removeFromSuperview];
}

- (void)updateBlankViewsPos{
    _blankImageView.frame = CGRectMake(0, 0, _blankImageView.image.size.width, _blankImageView.image.size.height);
    _blankImageView.centerX = _blankView.centerX;
    _blankImageView.centerY = _blankView.centerY - _blankImageView.image.size.height;
    
    
    CGRect newSize = [_blankMessageLabel.text boundingRectWithSize:CGSizeMake(_targetFrame.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _blankMessageLabel.font} context:nil];
    _blankMessageLabel.frame = CGRectMake(20, _blankImageView.bottom + 10, newSize.size.width, newSize.size.height);
}


#pragma mark - mask

- (void)showBlackMaskBehineView:(UIView *)someView OnView:(UIView *)view{
    if (!someView) {
        [view addSubview:self.blackMaskView];
    }else{
        [view insertSubview:self.blackMaskView belowSubview:someView];
    }
    [UIView animateWithDuration:0.25 animations:^{
        _blackMaskView.alpha = 0.7;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showBlackMaskInWindow:(UIWindow *)window{
    
    [window addSubview:self.blackMaskView];
    
    [UIView animateWithDuration:0.25 animations:^{
        _blackMaskView.alpha = 0.7;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideBlackMaskView{
    [UIView animateWithDuration:0.25 animations:^{
        _blackMaskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_blackMaskView removeFromSuperview];
    }];
}

- (UIView *)blackMaskView{
    if (!_blackMaskView) {
        _blackMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _blackMaskView.backgroundColor = [UIColor blackColor];
        _blackMaskView.alpha = 0.f;
        _blackMaskView.userInteractionEnabled = YES;
    }
    return _blackMaskView;
}

#pragma mark - Messages

- (void)showSuccessMessage:(NSString *)msg inController:(UIViewController *)controller{
    [CSNotificationView showInViewController:controller
                                       style:CSNotificationViewStyleSuccess
                                     message:msg];
}


- (void)showFailureMessage:(NSString *)msg inController:(UIViewController *)controller{
    [CSNotificationView showInViewController:controller
                                       style:CSNotificationViewStyleError
                                     message:msg];
}

- (void)showMessage:(NSString *)msg inController:(UIViewController *)controller{
    [CSNotificationView showInViewController:controller tintColor:[UIColor turquoiseColor]
                                       image:nil message:msg
                                    duration:2.0];
}


@end
