//
//  BottomInputViewer.h
//  MeiYuan
//
//  Created by kino on 16/6/1.
//
//

#import <Foundation/Foundation.h>

@interface BottomInputViewer : NSObject

@property (copy, nonatomic) void(^postHandler)(BottomInputViewer *viewer, NSString *postStr);
@property (copy, nonatomic) void(^cancelHandler)(BottomInputViewer *);


+ (instancetype)viewerWithPlaceHolder:(NSString *)placeStr
                          sendHandler:(void(^)(BottomInputViewer *viewer, NSString *sendStr))postHandler;

- (void)showInWindow;

- (void)hideInWindow;

@end
