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

enum TableRowSelected
{
    kUIDisplayPickerRow = 0,
    kUICreateNewContactRow,
    kUIDisplayContactRow,
    kUIEditUnkownContactRow
};

#define kUIEditUnknownContactRowHeight 81.0;

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize infoButton;

#pragma mark - User interaction

-(IBAction)userDidClickAddContactButton:(id)sender
{
    ABRecordRef record = ABPersonCreate();
    CFErrorRef an_error = NULL;
    
    ABRecordSetValue(record, kABPersonFirstNameProperty, CFSTR("Darrell"), &an_error);
    ABRecordSetValue(record, kABPersonLastNameProperty, CFSTR("Brogdon"), &an_error);

    ABMutableMultiValueRef multi_phone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi_phone, @"1-720-272-4381", kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(record, kABPersonPhoneProperty, multi_phone, &an_error);
    
    ABMutableMultiValueRef multi_email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi_email, @"darrell@brogdon.net", kABWorkLabel, NULL);
    ABRecordSetValue(record, kABPersonEmailProperty, multi_email, &an_error);
    
    ABMutableMultiValueRef multi_aim = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi_aim, @"Xelphyr", kABPersonInstantMessageServiceAIM, NULL);
    ABRecordSetValue(record, kABPersonInstantMessageProperty, multi_aim, &an_error);
    
    ABMutableMultiValueRef multi_skype = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi_skype, @"darrell.brogdon", kABPersonInstantMessageServiceSkype, NULL);
    ABRecordSetValue(record, kABPersonInstantMessageProperty, multi_skype, &an_error);
    
    if (an_error != NULL) {
        NSLog(@"Error while creating contact");
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef address_book = ABAddressBookCreateWithOptions(NULL, &error);
    ABAddressBookRequestAccessWithCompletion(address_book, ^(bool granted, CFErrorRef error) {
        if (!granted) {
            UIAlertView *fail_alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Unable to access address book"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
            [fail_alert show];
        } else {
            BOOL is_added = ABAddressBookAddRecord(address_book, record, &error);
            
            if (is_added) {
                NSLog(@"Address book entry added");
                
                error = NULL;
                
                BOOL is_saved = ABAddressBookSave(address_book, &error);
                
                if (is_saved) {
                    NSLog(@"Saved address book");
                    
                    [infoButton setEnabled:NO];
                } else {
                    NSLog(@"ERROR saving address book: %@", error);
                }
            } else {
                NSLog(@"ERROR adding address book entry: %@", error);
            }
            
//            if (error == NULL) {
//                UIAlertView *success_alert = [[UIAlertView alloc] initWithTitle:@"Contact Saved!"
//                                                                        message:@"You now have my contact info in your Address Book"
//                                                                       delegate:self
//                                                              cancelButtonTitle:nil
//                                                              otherButtonTitles:nil];
//                [success_alert show];
//            }
        }
        
        CFRelease(record);
        CFRelease(multi_phone);
        CFRelease(multi_email);
        CFRelease(multi_aim);
        CFRelease(multi_skype);
        CFRelease(address_book);
    });
}

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
        [mailController setSubject:@"Mail From Darrell's iOS App"];
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


#pragma mark - View methods

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
