//
//  ConfirmUploadImageController.h
//  FaceBattle-iOS
//
//  Created by kino on 16/6/5.
//
//

#import "BaseController.h"

@interface ConfirmUploadImageController : BaseController

@property (strong , nonatomic) UIImage *chooseImage;
@property (assign , nonatomic) NSUInteger chooseType;

@property (assign, nonatomic) NSString *joinBid;

@end
