//
//  DownloadSourceViewController.m
//  Darrell Brogdon
//
//  Created by Darrell Brogdon on 4/14/13.
//  Copyright (c) 2013 Darrell Brogdon. All rights reserved.
//
//  This work is licensed under the Creative Commons Attribution-NonCommercial 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/.
//

#import "AppDelegate.h"
#import "DownloadSourceViewController.h"
#import "InfoViewController.h"

@interface DownloadSourceViewController ()

@end

@implementation DownloadSourceViewController

@synthesize infoButton;

//
// Show the information View when the info button is clicked.
//
- (IBAction)infoButtonWasClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        InfoViewController *infoViewController = [[InfoViewController alloc] init];
        
        [self presentViewController:infoViewController animated:YES completion:nil];
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
