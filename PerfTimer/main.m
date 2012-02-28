//
//  main.m
//
//  No copyright. No rights reserved.
//

#import <Foundation/Foundation.h>
#import "PerfTimer.h"

// Main program entry point. 
int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        // Log.
        NSLog(@"Start.");

        // Allocate and initialize the perf timer.
        PerfTimer * perfTimer = [[PerfTimer alloc] init];
        
        // Throw the first measurement away.
        [perfTimer start];
        [perfTimer capture];

        [perfTimer start];
        [perfTimer capture];
        NSLog(@"Empty start/capture: %@", [perfTimer stringWithElapsedTime]);

        [perfTimer start];
        [perfTimer capture];
        NSLog(@"Empty start/capture: %@", [perfTimer stringWithElapsedTime]);
                
        [perfTimer start];
        [perfTimer capture];
        NSLog(@"Empty start/capture: %@", [perfTimer stringWithElapsedTime]);

        [perfTimer start];
        [perfTimer capture];
        NSLog(@"Empty start/capture: %@", [perfTimer stringWithElapsedTime]);

        // Measure sleeping 1/2 second.
        [perfTimer start];
        [NSThread sleepForTimeInterval:0.5];
        [perfTimer capture];
        NSLog(@"   Sleep 1/2 second: %@", [perfTimer stringWithElapsedTime]);

        // Measure sleeping 1 second.
        [perfTimer start];
        [NSThread sleepForTimeInterval:1.0];
        [perfTimer capture];
        NSLog(@"     Sleep 1 second: %@", [perfTimer stringWithElapsedTime]);

        // Measure sleeping 4.6 seconds.
        [perfTimer start];
        [NSThread sleepForTimeInterval:4.6];
        [perfTimer capture];
        NSLog(@"  Sleep 4.6 seconds: %@", [perfTimer stringWithElapsedTime]);
        
        // Allocate and initalize the operation queue.
        NSOperationQueue * operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:2];

        // Allocate and initalize the URL request.
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]
                                                     cachePolicy:NSURLCacheStorageNotAllowed
                                                 timeoutInterval:60.0];
        
        // Perform the URL request asynchronously using an NSURLConnection.
        volatile __block BOOL done = NO;
        [perfTimer start];
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:operationQueue
                               completionHandler:^(NSURLResponse * urlResponse, NSData * data, NSError * error)
         {
             if (!error)
             {
                 [perfTimer capture];
                 NSLog(@"       Google took: %@", [perfTimer stringWithElapsedTime]); 
             }
         }];
        
        // Allocate and initalize the URL request.
        urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bing.com"]
                                      cachePolicy:NSURLCacheStorageNotAllowed
                                  timeoutInterval:60.0];
        
        // Perform the URL request asynchronously using an NSURLConnection.
        [perfTimer start];
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:operationQueue
                               completionHandler:^(NSURLResponse * urlResponse, NSData * data, NSError * error)
         {
             if (!error)
             {
                 [perfTimer capture];
                 NSLog(@"         Bing took: %@", [perfTimer stringWithElapsedTime]); 
             }
             
             done = YES;
         }];

        // Simple wait for URL request completion.
        while (!done)
        {
            [NSThread sleepForTimeInterval:0.5];
        }

        // Log.
        NSLog(@"Done.");
    }
    
    return 0;
}
