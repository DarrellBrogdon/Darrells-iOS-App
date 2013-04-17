//
//  SecondViewController.h
//  Darrell Brogdon
//
//  Created by Darrell Brogdon on 4/14/13.
//  Copyright (c) 2013 Darrell Brogdon. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution-NonCommercial 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UIImageView *gameImage;
@property (nonatomic, retain) IBOutlet UIButton *faceButton1;
@property (nonatomic, retain) IBOutlet UIButton *faceButton2;
@property (nonatomic, retain) IBOutlet UIButton *faceButton3;
@property (nonatomic, retain) IBOutlet UIButton *faceButton4;
@property (nonatomic, retain) IBOutlet UIButton *faceButton5;
@property int *score;

- (IBAction)buttonWasClicked:(id)sender;

@end
