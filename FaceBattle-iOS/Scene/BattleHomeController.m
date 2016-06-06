//
//  BattleHomeController.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "BattleHomeController.h"
#import "ChooseBattleModeController.h"
#import "BattleInfoController.h"

//#import "ChooseBattleModeController.h"

#import "ConfirmUploadImageController.h"
#import "TGCameraViewController.h"
#import "TGCameraColor.h"

#import "BattleViewModel.h"


#import "BattleRecordCell.h"

#import "FBTriangleView.h"

#import "PingTransition.h"

#import "NSDate-Utilities.h"

@interface BattleHomeController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate,TGCameraDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *publicBattleButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *myBattleButton;

@property (weak, nonatomic) IBOutlet FBTriangleView *triangleView;

@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;

@property (weak, nonatomic) IBOutlet UIView *userSectionView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) NSArray *contentTableViews;

@property (assign, nonatomic) BOOL disableScrollViewDidScroll;
@property (assign, nonatomic) NSUInteger currentSelectIdx;

@property (strong, nonatomic) BattleViewModel *viewModel;

@property (assign , nonatomic) NSUInteger chooseType;
@property (copy , nonatomic) NSString *chooseJoinBid;

@end

@implementation BattleHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [[BattleViewModel alloc] init];
    
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [TGCamera setOption:kTGCameraOptionHiddenFilterButton value:[NSNumber numberWithBool:YES]];
    UIColor *tintColor = [UIColor appYellowColor];
    [TGCameraColor setTintColor:tintColor];
    
    _userAvatar.image = [UserManager sharedManager].curUser.avatarImage;
    _userNameLabel.text = [UserManager sharedManager].curUser.name;
    
    
    NSMutableArray *tempTables = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        UITableView *tableView = [[UITableView alloc] init];
        [tableView registerNib:[UINib nibWithNibName:@"BattleRecordCell" bundle:nil] forCellReuseIdentifier:@"BattleRecordCell"];
        tableView.dataSource = self;
        tableView.delegate = self;
//        tableView.userInteractionEnabled = NO;
        tableView.tableFooterView = [UIView new];
        tableView.backgroundColor = [UIColor appBlackColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tempTables addObject:tableView];
        [_containerScrollView addSubview:tableView];
    }
    _contentTableViews = [NSArray arrayWithArray:tempTables];
    
    [[_publicBattleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.currentSelectIdx = 0;
//        [self contentViewIndexChanged:0];
    }];
    [[_recordButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.currentSelectIdx = 1;
//        [self contentViewIndexChanged:1];
    }];
    [[_myBattleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.currentSelectIdx = 2;
//        [self contentViewIndexChanged:2];
    }];
    
    [_logoutButton applyRoundBorderStyle:8 borderColor:[UIColor clearColor]];
    [[_logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[UserManager sharedManager] logout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    
    [_addNewBattleButton applyRoundBorderStyle:30 borderColor:[UIColor appYellowColor] borderWidth:2];
    [[_addNewBattleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.navigationController.delegate = self;
        
        ChooseBattleModeController *dest = [[ChooseBattleModeController alloc] init];
        [self pushController:dest];
    }];
    
    
    [[self rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        if (tuple.first == _containerScrollView && _disableScrollViewDidScroll == NO) {
            CGFloat viewWidth = CGRectGetWidth(self.view.frame);
            NSUInteger indexChanged = ceilf((_containerScrollView.contentOffset.x - viewWidth/2.f) / viewWidth);
            if (indexChanged != _currentSelectIdx) {
                self.currentSelectIdx = indexChanged;
//                [self contentViewIndexChanged:_currentSelectIdx];
            }
        }
    }];
    _containerScrollView.delegate = self;
    
    [self setupLayout];
}

- (void)setCurrentSelectIdx:(NSUInteger)currentSelectIdx{
    if (_currentSelectIdx != currentSelectIdx) {
        NSLog(@"current scroll state = %d", self.disableScrollViewDidScroll);
        _disableScrollViewDidScroll = YES;
        _containerScrollView.userInteractionEnabled = NO;
        
        [_containerScrollView setContentOffset:CGPointMake(currentSelectIdx * SCREEN_WIDTH, 0) animated:YES];
        
        [UIView animateWithDuration:0.25 delay:0.f usingSpringWithDamping:0.65 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [_triangleView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(SCREEN_WIDTH / 3.f * currentSelectIdx + SCREEN_WIDTH / 6.f - 20);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _disableScrollViewDidScroll = NO;
            _containerScrollView.userInteractionEnabled = YES;
            
            //获取数据
            useWeakSelf
            
            __block NSUInteger type = [self getCurrentSectionType];
            BattleSearchPageStatus *status = [_viewModel modelWithType:type];
            __block UITableView *tableView = [_contentTableViews safeObjectAtIndex:_currentSelectIdx];
            
            if ( /* status.datas.count == 0 && */ !status.isFetchingData) {
                
//                [colview.carbon_header startRefreshing];
                [[weakSelf.viewModel fetchNewestBattleListByType:type] subscribeNext:^(id x) {
                    
                    [tableView reloadData];
                    
                } error:^(NSError *error) {
                    
                }];
            }else{
                [tableView reloadData];
            }
            
        }];
        
        if (currentSelectIdx == 2) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [_addNewBattleButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(80);
                }];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [_addNewBattleButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-20);
                }];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
        
        _currentSelectIdx = currentSelectIdx;
    }
}

- (BattleSectionType)getCurrentSectionType{
    return (BattleSectionType)_currentSelectIdx;
}

- (void)setupLayout{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(130);
    }];
    
    [_publicBattleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.f);
        make.height.mas_equalTo(44);
    }];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_publicBattleButton.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.f);
        make.height.mas_equalTo(44);
    }];
    [_myBattleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_recordButton.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.f);
        make.height.mas_equalTo(44);
    }];
    
    [_triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH / 6 - 20);
        make.top.equalTo(_topView.mas_bottom).offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(10);
    }];
    
    [_containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(20);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.contentTableViews enumerateObjectsUsingBlock:^(UITableView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(idx * SCREEN_WIDTH);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.equalTo(_containerScrollView);
        }];
    }];

    [self.userSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.equalTo(_containerScrollView);
        make.left.equalTo(((UIView *)[_contentTableViews lastObject]).mas_right);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    [_addNewBattleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
    }];
    
    [_userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.centerX.equalTo(_userAvatar.superview);
        make.top.mas_equalTo(50);
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userAvatar.mas_bottom).offset(10);
        make.centerX.equalTo(_userNameLabel.superview);
    }];
    
    [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_logoutButton.superview);
        make.bottom.mas_equalTo(-50);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.equalTo(_logoutButton.mas_width).multipliedBy(4.f / 26.f);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = nil;
    
    [self reFetchData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = nil;
}

- (void)reFetchData{
    __block BattleSectionType type = [self getCurrentSectionType];
    [[_viewModel fetchNewestBattleListByType:type] subscribeNext:^(id x) {
        UITableView *table = [_contentTableViews safeObjectAtIndex:type];
        [table reloadData];
    } error:^(NSError *error) {
        
    }];
}

#pragma maek - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    BattleSearchPageStatus *status = [_viewModel modelWithType:[self getCurrentSectionType]];
    
    return status.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"BattleRecordCell";
    BattleRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor appYellowColor];
    cell.selectedBackgroundView = backView;
    
    BattleSearchPageStatus *status = [_viewModel modelWithType:[self getCurrentSectionType]];
    Battle *battle = [status.datas safeObjectAtIndex:indexPath.row];
    
    cell.nameLabel.text = battle.startUsername;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd HH:mm"];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];//直接指定时区
    NSString *strDate = [dateFormatter stringFromDate:battle.startTime];
    cell.timeLabel.text = strDate;
    
    NSString *imageName = [NSString stringWithFormat:@"%d",(int)[battle.startUid intValue] % 24 + 1];
    [cell.avatarView setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    cell.modeLabel.text = battle.type == BattleTypeDiff ? @"Classic Mode" : @"Hulk Mode";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BattleSearchPageStatus *status = [_viewModel modelWithType:[self getCurrentSectionType]];
    Battle *battle = [status.datas safeObjectAtIndex:indexPath.row];
    
    if ([battle.status isEqualToString:@"0"]) {
        
        AppUser *user = [UserManager sharedManager].curUser;
        if ([battle.startUid isEqualToString:user.userId]) {
            
            [self showMessage:@"Wait another receive your challange~"];
            
            return;
        }
        
        TGCameraNavigationController *navigationController =
        [TGCameraNavigationController newWithCameraDelegate:self];
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        self.chooseType = battle.type;
        self.chooseJoinBid = battle.bid;
        
    }else{
        BattleInfoController *dest = [[BattleInfoController alloc] init];
        dest.currentBattle = battle;
        [self pushController:dest];
    }
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        PingTransition *ping = [PingTransition new];
        return ping;
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
    dest.joinBid = self.chooseJoinBid;
    
    [self pushController:dest];
    
}


@end
