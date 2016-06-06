//
//  PhotoPickerService.h
//  MeiYuan
//
//  Created by kino on 16/4/16.
//
//

#import <Foundation/Foundation.h>

@interface PhotoPickerService : NSObject

- (void)showPhotoFromActionsheet:(UIViewController *)controller complete:(void(^)(UIImage *image, NSUInteger pickerWay))completeHandler;

@end
