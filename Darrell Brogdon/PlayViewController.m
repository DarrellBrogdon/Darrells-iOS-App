//
//  SecondViewController.m
//  Darrell Brogdon
//
//  Created by Darrell Brogdon on 4/14/13.
//  Copyright (c) 2013 Darrell Brogdon. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution-NonCommercial 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/.
//

#import "PlayViewController.h"
#import "Timer.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

@synthesize timerLabel;
@synthesize scoreLabel;
@synthesize gameImage;
@synthesize faceButton1;
@synthesize faceButton2;
@synthesize faceButton3;
@synthesize faceButton4;
@synthesize faceButton5;
@synthesize score;

double current_score;
int game_image = 1;
Timer *timer;
NSTimer *interval;

//
// The user found the face so replace the current image with the next in line.  Same for the face button.
//
- (IBAction)buttonWasClicked:(id)sender
{
    // Only do this if the timer is still running.
    if ([timer isRunning]) {
        [timer stopTimer];
        
        // Update the score and current timer values
        NSNumberFormatter *number_formatter = [[NSNumberFormatter alloc] init];
        [number_formatter setPositiveFormat:@"###.#"];
        
        current_score += [timer timeElapsedInSeconds];
        NSNumber *current_score_as_number = [NSNumber numberWithDouble:current_score];
        scoreLabel.text = [number_formatter stringFromNumber:current_score_as_number];
        timerLabel.text = @"0.0";
        
        // Stop the timer for now until we can show the next image and face button (assuming we're not at the last one).
        [interval invalidate];
        
        game_image++;
        
        if (game_image <= 5) {
            NSString *new_image_file_name = [NSString stringWithFormat:@"%d.jpg", game_image];
            UIImage *new_image = [UIImage imageNamed:new_image_file_name];

            switch (game_image) {
                case 2:
                    faceButton1.hidden = YES;
                    faceButton2.hidden = NO;
                    faceButton3.hidden = YES;
                    faceButton4.hidden = YES;
                    faceButton5.hidden = YES;
                    break;
                case 3:
                    faceButton1.hidden = YES;
                    faceButton2.hidden = YES;
                    faceButton3.hidden = NO;
                    faceButton4.hidden = YES;
                    faceButton5.hidden = YES;
                    break;
                case 4:
                    faceButton1.hidden = YES;
                    faceButton2.hidden = YES;
                    faceButton3.hidden = YES;
                    faceButton4.hidden = NO;
                    faceButton5.hidden = YES;
                    break;
                case 5:
                    faceButton1.hidden = YES;
                    faceButton2.hidden = YES;
                    faceButton3.hidden = YES;
                    faceButton4.hidden = YES;
                    faceButton5.hidden = NO;
                    break;
            }
            
            [gameImage setImage:new_image];
            [timer startTimer];
            
            // Restart the timer now that the new image and face button are ready
            interval = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(updateTime)
                                                      userInfo:nil
                                                       repeats:YES];
        // We're at the last image so notify the user
        } else {
            faceButton5.hidden = YES;
            gameImage.alpha = 0.25;
            
            NSString *message = [NSString stringWithFormat:@"You found me in only %@ seconds!",
                                 [number_formatter stringFromNumber:current_score_as_number]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great Job!"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

//
// Update the "Time:" label. Gets called once a second.
//
- (void) updateTime
{    
    NSNumber *current_time = [NSNumber numberWithDouble:[timer currentTimeInSeconds]];
    NSNumberFormatter *number_formatter = [[NSNumberFormatter alloc] init];
    
    [number_formatter setPositiveFormat:@"###.#"];
    
    timerLabel.text = [number_formatter stringFromNumber:current_time];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Basic instructions on how to play.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Where's Darrell?"
                                                    message:@"Find the picture of my face and tap it.  The faster you find it the better you are."
                                                   delegate:self
                                          cancelButtonTitle:@"Let's Play!"
                                          otherButtonTitles:nil];
    [alert show];    
}

//
// Handler for when the user clicks the "Let's Play!" button on the intro dialog.  This shows the first image and face button and starts the timer.
//
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        gameImage.hidden = NO;
        faceButton1.hidden = NO;
        
        timer = [[Timer alloc] init];

        [timer startTimer];

        interval = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
