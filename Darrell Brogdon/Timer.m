//
//  Timer.m
//  Darrell Brogdon
//
//  Created by Darrell Brogdon on 4/15/13.
//  Copyright (c) 2013 Darrell Brogdon. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution-NonCommercial 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/.
//

#import "Timer.h"

@implementation Timer

- (id) init {
    self = [super init];
    if (self != nil) {
        start = nil;
        end = nil;
        is_running = NO;
    }
    return self;
}

//
// Return whether the timer is currently running or not.
//
- (BOOL) isRunning
{
    return is_running;
}

//
// Start the timer and set the start date
//
- (void) startTimer {
    is_running = YES;
    start = [NSDate date];
}

//
// Stop the timer and set the end date
//
- (void) stopTimer {
    is_running = NO;
    end = [NSDate date];
}

//
// Get the current time (timer is still running) in seconds
//
- (double) currentTimeInSeconds {
    return [[NSDate date] timeIntervalSinceDate:start];
}

//
// Get the elapsed time (timer is stopped) in seconds
//
- (double) timeElapsedInSeconds {
    return [end timeIntervalSinceDate:start];
}

@end
