//
//  Timer.h
//  Darrell Brogdon
//
//  Created by Darrell Brogdon on 4/15/13.
//  Copyright (c) 2013 Darrell Brogdon. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution-NonCommercial 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/.
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

@end
