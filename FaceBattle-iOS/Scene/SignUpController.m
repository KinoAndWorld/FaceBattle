//
//  SignUpController.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "SignUpController.h"
#import "BattleHomeController.h"

#import "FBTextField.h"

#import "UserEngine.h"

//#import ""

@interface SignUpController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet FBTextField *nameBox;
@property (weak, nonatomic) IBOutlet FBTextField *passwordBox;
@property (weak, nonatomic) IBOutlet FBTextField *confirmpasswordBox;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor appYellowColor];
    
    [_signUpButton applyRoundBorderStyle:8];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"OR BACK TO LOGIN"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [_loginButton setAttributedTitle:content forState:UIControlStateNormal];
    
    [self setupLayout];
    
    _nameBox.font = [UIFont applicationFontOfSize:13];
    _passwordBox.font = [UIFont applicationFontOfSize:13];
    _confirmpasswordBox.font = [UIFont applicationFontOfSize:13];
    
    
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
    
    [[_signUpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //checl param
        if (_nameBox.text.length < 4) {
            [self showFailureMessage:@"User name is too short"];
            return ;
        }
        if (_passwordBox.text.length < 6) {
            [self showFailureMessage:@"Password is too short"];
            return ;
        }
        
        if (![_passwordBox.text isEqualToString:_confirmpasswordBox.text]) {
            [self showFailureMessage:@"Password is not match to each other"];
            return ;
        }
        
        [self startLoadingWithMessage:@"Sign up now"];
        
        UserRequest *req = [[UserRequest alloc] init];
        req.account = _nameBox.text;
        req.password = _passwordBox.text;
        [UserEngine userSignUpWithRequest:req onComplete:^(id responseResult) {
            
            AppUser *user = responseResult;
            if ([user isKindOfClass:[AppUser class]]) {
                [[UserManager sharedManager] login:user];
                //
                BattleHomeController *dest = [[BattleHomeController alloc] init];
                [self pushController:dest];
            }else{
                [self showFailureMessage:@"User create failed, Please retry"];
            }
            [self stopLoading];
        } onError:^(NSError *error) {
            [self showFailureMessage:error.domain];
            [self stopLoading];
        } translater:[AppUser class]];
    }];
    
    
    [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self popController];
    }];
}

- (void)setupLayout{
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(150);
        make.top.mas_equalTo(40);
        make.centerX.equalTo(self.view);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoView.mas_bottom).offset(0);
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
    
    [_confirmpasswordBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        make.top.equalTo(_passwordBox.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [_signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.bottom.equalTo(_loginButton.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(200);
        make.bottom.mas_equalTo(-10);
    }];
}


@end
