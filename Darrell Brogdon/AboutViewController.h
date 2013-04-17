//
//  FirstViewController.h
//  Darrell Brogdon
//
//  Created by Darrell Brogdon on 4/14/13.
//  Copyright (c) 2013 Darrell Brogdon. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution-NonCommercial 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)userDidClickPhoneNumber:(id)sender;
- (IBAction)userDidClickEmailAddress:(id)sender;
- (IBAction)userDidClickLinkedInLink:(id)sender;

@end
