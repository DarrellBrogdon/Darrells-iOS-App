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

@interface DownloadSourceViewController ()

@end

@implementation DownloadSourceViewController

BOOL alreadyDownloaded = NO;

- (IBAction)submitDownloadSourceRequest:(id)sender
{
    // Check to see that we haven't already sent the source. If so, ask the user if they want it to be sent to them again.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"SourceDownloads"
                                                  inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    alreadyDownloaded = [objects count] > 0;
    
    if (alreadyDownloaded)
    {
        NSLog(@"%d Matches found", [objects count]);
        
        UIActionSheet *confirmation = [[UIActionSheet alloc] initWithTitle:@"You've already downloaded once.\nDownload Again?"
                                                                  delegate:self
                                                         cancelButtonTitle:@"No"
                                                    destructiveButtonTitle:@"Yes"
                                                         otherButtonTitles:nil];
        confirmation.actionSheetStyle = UIActionSheetStyleAutomatic;
        [confirmation showFromTabBar:self.tabBarController.tabBar];
    }
    else
    {
        [self makeEndpointRequest:_emailAddress.text alreadyDownloaded:NO];
    }
}

- (void)makeEndpointRequest:(NSString *)emailAddress alreadyDownloaded:(BOOL)alreadyDownloaded
{
    // If they provided a valid email address then make an HTTP POST to the endpoint with that.
    if ([self validateEmail:_emailAddress.text])
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL
                                                                            URLWithString:@"http://localhost:3000/downloadsource"]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"email_address=%@", _emailAddress.text];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        // The request was successful so notify the user.
        if (connection)
        {
            if (!alreadyDownloaded) {
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                NSManagedObject *sourceDownloaded;
                
                sourceDownloaded = [NSEntityDescription insertNewObjectForEntityForName:@"SourceDownloads"
                                                                 inManagedObjectContext:context];
                
                [sourceDownloaded setValue:[NSNumber numberWithBool:YES] forKey:@"downloaded"];
                
                NSError *error;
                [context save:&error];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks!"
                                                            message:@"You will receive an email with the source attached"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    // The email address they provided was invalid.  Ask them to try again.
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You must provide a valid email address"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self makeEndpointRequest:_emailAddress.text alreadyDownloaded:alreadyDownloaded];
    }
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (void)dismissKeyboard
{
    [_emailAddress resignFirstResponder];
}

- (BOOL) validateEmail: (NSString *) emailAddress
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailAddress];
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

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
