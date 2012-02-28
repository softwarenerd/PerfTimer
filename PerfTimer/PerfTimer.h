//
//  PerfTimer.h
//
//  No copyright. No rights reserved.
//

#import <Foundation/Foundation.h>

// PerfTimer interface.
@interface PerfTimer : NSObject

// Starts or restarts the perf timer.
- (void)start;

// Captures the perf timer.
- (void)capture;

// Returns the elapsed time in nanoseconds of the last capture.
- (UInt64)nsElapsed;

// Returns the elapsed time in milliseconds of the last capture.
- (UInt32)msElapsed;

// Returns a string representation of the last capture.
- (NSString *)stringWithElapsedTime;

@end
