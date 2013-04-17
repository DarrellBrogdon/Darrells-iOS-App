//
//  Timer.h
//  Darrell Brogdon
//
//  Created by Darrell Brogdon on 4/15/13.
//  Copyright (c) 2013 Darrell Brogdon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject {
    NSDate *start;
    NSDate *end;
    BOOL is_running;
}

- (BOOL) isRunning;
- (void) startTimer;
- (void) stopTimer;
- (double) currentTimeInSeconds;
- (double) timeElapsedInSeconds;
- (double) timeElapsedInMilliseconds;
- (double) timeElapsedInMinutes;

@end
