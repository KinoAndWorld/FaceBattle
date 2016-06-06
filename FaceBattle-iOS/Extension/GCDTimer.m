//
//  GCDTimer.m
//  MeiYuan
//
//  Created by kino on 16/4/15.
//
//

#import "GCDTimer.h"

@interface GCDTimer ()

@property (copy, nonatomic) void(^excuteBlock)(void);

@property (strong, nonatomic) dispatch_source_t source;

@end

@implementation GCDTimer

+ (GCDTimer *)repeatingTimer:(NSTimeInterval)seconds
                       block:(void (^)(void))block {
    NSParameterAssert(seconds);
    NSParameterAssert(block);
    
    GCDTimer *timer = [[self alloc] init];
    timer.excuteBlock = block;
    timer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                          0, 0,
                                          dispatch_get_main_queue());
    uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(timer.source,
                              dispatch_time(DISPATCH_TIME_NOW, nsec),
                              nsec, 0);
    dispatch_source_set_event_handler(timer.source, block);
    dispatch_resume(timer.source);
    return timer;
}

- (void)invalidate {
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
    self.excuteBlock = nil;
}

@end
