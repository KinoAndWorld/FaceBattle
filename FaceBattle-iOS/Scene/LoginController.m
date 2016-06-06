//
//  LoginController.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "LoginController.h"

#import "FBTextField.h"

#import "UserEngine.h"

//#import <yyte>
#import "SignUpController.h"
#import "BattleHomeController.h"

@interface LoginController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet FBTextField *nameBox;
@property (weak, nonatomic) IBOutlet FBTextField *passwordBox;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameBox.text = @"";
    _passwordBox.text = @"";
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor appYellowColor];
    
    [_loginButton applyRoundBorderStyle:8];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"OR REGISTER NOW"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [_signUpButton setAttributedTitle:content forState:UIControlStateNormal];
    
    [self setupLayout];
    
    _nameBox.font = [UIFont applicationFontOfSize:13];
    _passwordBox.font = [UIFont applicationFontOfSize:13];
    
    [[self.nameBox rac_textSignal] subscribeNext:^(id x) {
        if ([x length] > 20) {
            self.nameBox.text = [x substringToIndex:11];
        }
    }];
    [[self.passwordBox rac_textSignal] subscribeNext:^(id x) {
        if ([x length] > 20) {
            self.passwordBox.text = [x substringToIndex:20];
        }
    }];
    
//    RACSignal *enableSignal = [RACSignal combineLatest:@[self.nameBox.rac_textSignal, self.passwordBox.rac_textSignal] reduce:^(NSString *account, NSString *pwd){
//        BOOL pass = account.length >= 4 && pwd.length >= 6;
//        return @(pass);
//    }];
//    [enableSignal subscribeNext:^(id x) {
//        self.loginButton.enabled = [x boolValue];
//    }];
    
    useWeakSelf
    
    [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        //check param
        if (_nameBox.text.length < 4) {
            [self showFailureMessage:@"User name is too short"];
            return ;
        }
        if (_passwordBox.text.length < 6) {
            [self showFailureMessage:@"Password is too short"];
            return ;
        }
        
        [self startLoadingWithMessage:@"Login Now"];
        
        UserRequest *req = [[UserRequest alloc] init];
        req.account = _nameBox.text;
        req.password = _passwordBox.text;
        
        [UserEngine userSignInWithRequest:req onComplete:^(id responseResult) {
            [weakSelf stopLoading];
            
            if ([responseResult isKindOfClass:[AppUser class]]) {
                [[UserManager sharedManager] login:responseResult];
                BattleHomeController *dest = [[BattleHomeController alloc] init];
                [weakSelf pushController:dest];
            }
            
        } onError:^(NSError *error) {
            [weakSelf showFailureMessage:error.domain];
            [weakSelf stopLoading];
        } translater:[AppUser class]];
        
    }];
    
    [[_signUpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        SignUpController *dest = [[SignUpController alloc] init];
        [self pushController:dest];
    }];
}

- (void)setupLayout{
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(150);
        make.top.mas_equalTo(40);
        make.centerX.equalTo(self.view);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];

    [_nameBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.top.equalTo(_descLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    [_passwordBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.top.equalTo(_nameBox.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.bottom.equalTo(_signUpButton.mas_top).offset(-5);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [_signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(200);
        make.bottom.mas_equalTo(-30);
    }];
}


@end
