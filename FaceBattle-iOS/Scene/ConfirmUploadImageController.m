//
//  ConfirmUploadImageController.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/5.
//
//

#import "ConfirmUploadImageController.h"

#import "BattleEngine.h"

#import "MBProgressHUD.h"

@interface ConfirmUploadImageController ()

@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) MBProgressHUD *uploadHud;

@end

@implementation ConfirmUploadImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    _chooseImageView.image = self.chooseImage;
    
    [_sureButton applyRoundBorderStyle:8 borderColor:[UIColor clearColor]];
    [_cancelButton applyRoundBorderStyle:8 borderColor:[UIColor clearColor]];
    
    useWeakSelf
    [[_sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        _uploadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _uploadHud.mode = MBProgressHUDModeAnnularDeterminate;
        _uploadHud.label.text = @"Uploading...";
        
        
        if (self.joinBid) {
            [BattleEngine joinBattleWithPhoto:[self resizeImage:self.chooseImage] bid:self.joinBid progress:^(NSProgress *progress) {
                _uploadHud.progress = (progress.completedUnitCount * 1.f / progress.totalUnitCount * 1.f);
                NSLog(@"current = %f",progress.completedUnitCount * 1.f / progress.totalUnitCount * 1.f);
            } onComplete:^(id responseResult) {
                [_uploadHud hideAnimated:YES];
                [weakSelf showSuccessMessage:@"Upload Success!"];
                
                __block UIViewController *willJumpController;
                [weakSelf.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([NSStringFromClass([obj class]) isEqualToString:@"BattleHomeController"]) {
                        willJumpController = obj;
                    }
                }];
                
                if (willJumpController) {
                    [weakSelf.navigationController popToViewController:willJumpController animated:YES];
                }else{
                    [weakSelf popController];
                }
            } onError:^(NSError *error) {
                [weakSelf showFailureMessage:error.domain];
                [_uploadHud hideAnimated:YES];
            } translater:nil];
            
        }else{
            [BattleEngine uploadPhotoToBattleWithImage:[self resizeImage:self.chooseImage] type:self.chooseType progress:^(NSProgress *progress) {
                _uploadHud.progress = (progress.completedUnitCount * 1.f / progress.totalUnitCount * 1.f);
                NSLog(@"current = %f",progress.completedUnitCount * 1.f / progress.totalUnitCount * 1.f);
            } onComplete:^(id responseResult) {
                
                [_uploadHud hideAnimated:YES];
                [weakSelf showSuccessMessage:@"Upload Success!"];
                
                
                __block UIViewController *willJumpController;
                [weakSelf.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([NSStringFromClass([obj class]) isEqualToString:@"BattleHomeController"]) {
                        willJumpController = obj;
                    }
                }];
                
                if (willJumpController) {
                    [weakSelf.navigationController popToViewController:willJumpController animated:YES];
                }else{
                    [weakSelf popController];
                }
                
                
            } onError:^(NSError *error) {
                [weakSelf showFailureMessage:error.domain];
                [_uploadHud hideAnimated:YES];
            } translater:nil];
        }
        
    }];
    
    [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self popControllerWithAnimatiom:NavigationTransAnimationUpToDown];
    }];
    
}


//
//UIImage *willUploadImage = [self resizeImage:image];
//
///**
// *  上传头像
// *
// *  @param 50 size
// */
////    UIImage *scaleImage = [imageToUse imageByResizeToSize:CGSizeMake(200, 200)];
////
////    [[_viewModel updateUserProfileWithAvatar:scaleImage] subscribeNext:^(id x) {
////        AppUser *user = [UserManager sharedManager].curUser;
////        user.avatarUrl = x;
////
////    } error:^(NSError *error) {
////        [self showFailureMessage:error.domain];
////    }];
//}

- (UIImage *)resizeImage:(UIImage *)image{
    UIImage *newImage = image;
    float scaleX = image.size.width / 800.f;
    if (scaleX > 1.f) {
        newImage = [image scaleToSize:CGSizeMake(image.size.width / scaleX, image.size.height / scaleX)];
    }
    
    float scaleY = newImage.size.height / 1000.f;
    if (scaleY > 1.f) {
        newImage = [newImage scaleToSize:CGSizeMake(newImage.size.width / scaleY, newImage.size.height / scaleY)];
    }
    return newImage;
}

@end
