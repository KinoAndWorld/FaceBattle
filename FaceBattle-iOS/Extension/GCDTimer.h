//
//  GCDTimer.h
//  MeiYuan
//
//  Created by kino on 16/4/15.
//
//

#import <Foundation/Foundation.h>

@interface GCDTimer : NSObject

+ (GCDTimer *)repeatingTimer:(NSTimeInterval)seconds
                       block:(void (^)(void))block;

- (void)invalidate;

@end
