//
//  BaseNavigationController.m
//  MeiYuan
//
//  Created by kino on 16/4/16.
//
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.delegate = self;
}

@end





@implementation ModalNavgationController

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    self.navigationBar.translucent = NO;
//    self.navigationBar.barTintColor = [UIColor colorWithHex:0xE91F3B];
//    
//    [self.navigationBar setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor whiteColor],
//       NSFontAttributeName : [UIFont applicationFontOfSize:16]}
//     ];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
