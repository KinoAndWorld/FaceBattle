//
//  BattleInfoController.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "BattleInfoController.h"

#import "BattleEngine.h"

#import <UIImageView+YYWebImage.h>

@interface BattleInfoController ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (weak, nonatomic) IBOutlet UIView *centerBarView;

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation BattleInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    
    [self setupLayout];
    
    [self fetchData];
    
    _statusImageView.alpha = 0;
}

- (void)setupLayout{
    
    [_centerBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.view);
    }];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(40);
    }];
    
    [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(_centerBarView.mas_top);
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    [_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerBarView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(60);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
}

- (void)fetchData{
    [self startLoadingWithMessage:@"Feth Battle Info"];
    
    useWeakSelf
    [BattleEngine getBattleInfoFormBid:_currentBattle.bid onComplete:^(id responseResult) {
        
        Battle *battle = responseResult;
        
        battle.startPhotoUrl = [NSString stringWithFormat:@"%@/photos/%@",BASE_API_URL, battle.startPid];
        battle.parterPhotoUrl = [NSString stringWithFormat:@"%@/photos/%@",BASE_API_URL, battle.parterPid];
        
        weakSelf.currentBattle = battle;
        
        [weakSelf stopLoading];
        
        [weakSelf updateViewWhenBattleUpdated];
    } onError:^(NSError *error) {
        [weakSelf stopLoading];
        
    } translater:[Battle class]];
}

- (void)updateViewWhenBattleUpdated{
    
    AppUser *user = [UserManager sharedManager].curUser;
    
    [_topImageView yy_setImageWithURL:[NSURL URLWithString:_currentBattle.startPhotoUrl] placeholder:nil];
    
    [_bottomImageView yy_setImageWithURL:[NSURL URLWithString:_currentBattle.parterPhotoUrl] placeholder:nil];
    
    _statusImageView.transform = CGAffineTransformMakeScale(5.0, 5.0);
    
    [UIView animateWithDuration:0.5 animations:^{
        _statusImageView.alpha = 1.0;
        _statusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
    
    if ( [_currentBattle.startUid isEqualToString:user.userId]){
        
        _topLabel.text = [NSString stringWithFormat:@"  You are %@", [_currentBattle startDescString]];
        _bottomLabel.text = [NSString stringWithFormat:@"  He is %@", [_currentBattle partnerString]];
        
    }else{
        _bottomLabel.text = [NSString stringWithFormat:@"  You are %@", [_currentBattle partnerString]];
        _topLabel.text = [NSString stringWithFormat:@"  He is %@", [_currentBattle startDescString]];
    }
    
    
    if ([_currentBattle.status isEqualToString:@"0"]) { //未完成
        
    }else{      //已完成
        
        BOOL startUserWin = [_currentBattle checkBattleIfStartUserWin];
        if (startUserWin) {
            if ( [_currentBattle.startUid isEqualToString:user.userId]) {//i win
                _statusImageView.image = [UIImage imageNamed:@"win_text"];
                
            }else{ //i lost
                _statusImageView.image = [UIImage imageNamed:@"lost_text"];
            }
        }else{
            if ( [_currentBattle.startUid isEqualToString:user.userId]) {//i lost
                _statusImageView.image = [UIImage imageNamed:@"lost_text"];
            }else{//i win
                _statusImageView.image = [UIImage imageNamed:@"win_text"];
            }
        }
        
        
        
    }
}


@end
