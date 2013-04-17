//
//  FirstViewController.m
//  Darrell Brogdon
//
//  Created by Darrell Brogdon on 4/14/13.
//  Copyright (c) 2013 Darrell Brogdon. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution-NonCommercial 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

#pragma mark - User interaction

//
// Make a call when the user clicks the phone number button
//
- (IBAction)userDidClickPhoneNumber:(id)sender
{
    NSURL *telURL = [NSURL URLWithString:@"tel:7202724381"];
    NSLog(@"Calling %@", telURL);
    [[UIApplication sharedApplication] openURL:telURL];
}

//
// Open the email dialog when the user clicks the email address button
//
- (IBAction)userDidClickEmailAddress:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        
        [mailController setMailComposeDelegate:self];
        
        NSString *emailAddress = @"darrell@brogdon.net";
        NSArray *emailArray = [[NSArray alloc] initWithObjects:emailAddress, nil];
        
        [mailController setToRecipients:emailArray];
        [mailController setSubject:@"Mail From App"];
        [self presentViewController:mailController animated:YES completion:nil];
    }
}

//
// Dismiss the email dialog when the email is sent or cancel button clicked
//
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)userDidClickLinkedInLink:(id)sender
{
    NSURL *liURL = [NSURL URLWithString:@"http://www.linkedin.com/in/dbrogdon/"];
    NSLog(@"Opening %@", liURL);
    [[UIApplication sharedApplication] openURL:liURL];
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
