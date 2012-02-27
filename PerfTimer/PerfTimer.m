//
//  PerfTimer.m
//
//  No copyright. No rights reserved.
//

#import "PerfTimer.h"
#include <mach/mach.h>
#include <mach/mach_time.h>

// PerfTimer implementation.
@implementation PerfTimer
{
@private
    // The absolute to nanosecond conversion factor.
    volatile long double factor_;
    
    // The started absolute time.
    volatile UInt64 started_;
   
    // The capture absolute time.
    volatile UInt64 capture_;
}

// Class initializer.
- (id)init
{
    // Initialize superclass.
    self = [super init];
    
    // Handle errors.
    if (!self)
    {
        return nil;
    }
           
    // Precalculate the absolute time to nanosecond conversion factor as it
    // only needs to be done once.
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    factor_ = ((long double)info.numer) / ((long double)info.denom);
           
    // Done.
    return self;
}

// Starts or restarts the perf timer.
- (void)start;
{
    capture_ = 0ULL;
    started_ = mach_absolute_time();
}

// Captures the perf timer.
- (void)capture
{
    // Get the capture time.
    UInt64 capture = mach_absolute_time();
    
    // If the timer was started, set capture time; otherwise, ignore the call.
    if (started_)
    {
        capture_ = capture;
    }    
}

// Returns the elapsed time in nanoseconds.
- (UInt64)nsElapsed
{
    if (!started_ || !capture_)
    {
        return 0LL;
    }

    return (UInt64)roundl((long double)(capture_ - started_) * factor_);
}

// Returns the elapsed time in milliseconds.
- (UInt32)msElapsed
{
    if (!started_ || !capture_)
    {
        return 0LL;
    }

    return (UInt32)roundl((long double)(capture_ - started_) * factor_ / 1000000.0L);
}

// Returns a string containing a representation of the elapsed time.
- (NSString *)stringWithElapsedTime
{
    // Allocate a number formatter and initialize it with the decimal style. 
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    // Obtain the elapsed ns.
    UInt64 nsElapsed = [self nsElapsed];

    // Format the elapsed ns. This will always be returned.
    NSString * nsElapsedString = [formatter stringFromNumber:[NSNumber numberWithLongLong:nsElapsed]];

    // If the elapsed NS is < 1 ns, just return the elapsed ns.
    if (nsElapsed < 1000000ULL)
    {
        return [NSString stringWithFormat:@"[%@ ns]", nsElapsedString];
    }

    // Format the elapsed ns.
    NSString * msElapsedString = [formatter stringFromNumber:[NSNumber numberWithLong:[self msElapsed]]];
    
    // Done.
    return [NSString stringWithFormat:@"[%@ ms] [%@ ns]", msElapsedString, nsElapsedString];
}

@end