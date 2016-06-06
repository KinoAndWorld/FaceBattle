//
//  ChooseBattleModeController.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "ChooseBattleModeController.h"
#import "ConfirmUploadImageController.h"

#import "PingInvertTransition.h"

#import "TGCameraViewController.h"
#import "TGCameraColor.h"

@interface ChooseBattleModeController ()<TGCameraDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *classicModeButton;
@property (weak, nonatomic) IBOutlet UILabel *classicLabel;

@property (weak, nonatomic) IBOutlet UIButton *hulkModeButton;
@property (weak, nonatomic) IBOutlet UILabel *hulkLabel;


@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (assign, nonatomic) NSUInteger chooseType;

@end

@implementation ChooseBattleModeController{
    
    UIPercentDrivenInteractiveTransition *percentTransition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TGCamera setOption:kTGCameraOptionHiddenFilterButton value:[NSNumber numberWithBool:YES]];
    UIColor *tintColor = [UIColor appYellowColor];
    [TGCameraColor setTintColor:tintColor];
    
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
    [_classicModeButton applyRoundBorderStyle:8.f borderColor:[UIColor appBlackColor] borderWidth:2];
    [_hulkModeButton  applyRoundBorderStyle:8.f borderColor:[UIColor appBlackColor] borderWidth:2];
    
    _classicModeButton.layer.masksToBounds = YES;
    [_classicModeButton setTitleColor:[UIColor appYellowColor] forState:UIControlStateHighlighted];
    UIImage *highlightImage = [[UIColor appBlackColor] createPureImageBySize:_classicModeButton.frame.size];
    [_classicModeButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    _hulkModeButton.layer.masksToBounds = YES;
    [_hulkModeButton setTitleColor:[UIColor appYellowColor] forState:UIControlStateHighlighted];
    [_hulkModeButton setBackgroundImage:[[UIColor appBlackColor] createPureImageBySize:_hulkModeButton.frame.size] forState:UIControlStateHighlighted];
    
    
    //events
    [[_classicModeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        TGCameraNavigationController *navigationController =
        [TGCameraNavigationController newWithCameraDelegate:self];
        
        self.chooseType = 0;
        
        [self presentViewController:navigationController animated:YES completion:nil];

    }];
    
    [[_hulkModeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        TGCameraNavigationController *navigationController =
        [TGCameraNavigationController newWithCameraDelegate:self];
        
        self.chooseType = 1;
        
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
    
    [_closeButton applyRoundBorderStyle:30 borderColor:[UIColor appBlackColor] borderWidth:2];
    [[_closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self popController];
    }];
    
    
    [self setupLayout];
}

- (void)setupLayout{
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(100);
    }];
    
    [_classicModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.equalTo(_classicModeButton.mas_width).multipliedBy(4.f/26.f);
    }];
    
    [_classicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.equalTo(_classicModeButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    [_hulkModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_classicLabel.mas_bottom).offset(50);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.equalTo(_hulkModeButton.mas_width).multipliedBy(4.f/26.f);
    }];
    
    [_hulkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.equalTo(_hulkModeButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
        make.width.height.mas_equalTo(60);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return percentTransition;
}

- (void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (per > 0.3) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition = nil;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        PingInvertTransition *pingInvert = [PingInvertTransition new];
        return pingInvert;
    }else{
        return nil;
    }
}

#pragma mark - TGCameraDelegate optional

- (void)cameraWillTakePhoto{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoAtPath:(NSURL *)assetURL{
    // When this method is implemented, an image will be saved on the user's device
    NSLog(@"%s album path: %@", __PRETTY_FUNCTION__, assetURL);
}

- (void)cameraDidSavePhotoWithError:(NSError *)error{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image{
    [self handleImageToUpload:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image{
    [self handleImageToUpload:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleImageToUpload:(UIImage *)image{
    
    ConfirmUploadImageController *dest = [[ConfirmUploadImageController alloc] init];
    dest.chooseImage = image;
    
    dest.chooseType = self.chooseType;
    
    [self pushController:dest];
    
}

@end
