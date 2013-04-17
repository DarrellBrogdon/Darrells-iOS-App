//
//  Timer.m
//  Darrell Brogdon
//
//  Created by Darrell Brogdon on 4/15/13.
//  Copyright (c) 2013 Darrell Brogdon. All rights reserved.
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

- (BOOL) isRunning
{
    return is_running;
}

- (void) startTimer {
    is_running = YES;
    start = [NSDate date];
}

- (void) stopTimer {
    is_running = NO;
    end = [NSDate date];
}

- (double) currentTimeInSeconds {
    return [[NSDate date] timeIntervalSinceDate:start];
}

- (double) timeElapsedInSeconds {
    return [end timeIntervalSinceDate:start];
}

- (double) timeElapsedInMilliseconds {
    return [self timeElapsedInSeconds] * 1000.0f;
}

- (double) timeElapsedInMinutes {
    return [self timeElapsedInSeconds] / 60.0f;
}

@end
