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

@synthesize infoButton;

#pragma mark - User interaction

//
// Check to see if my contact is already in their Address Book
//
-(BOOL)addressBookContactAlreadyExists
{
    BOOL return_value = NO;
    
    NSUInteger i;
    NSUInteger k;
    
    CFStringRef search_first_name = CFSTR("Darrell");
    CFStringRef search_last_name = CFSTR("Brogdon");
    CFStringRef search_email_address = CFSTR("darrell@brogdon.net");
    
    CFErrorRef error = NULL;
    
    ABAddressBookRef address_book = ABAddressBookCreateWithOptions(NULL, &error);
    NSArray *people = (NSArray *) CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(address_book));
    
    if (people == nil) {
        NSLog(@"No Address Book entries to scan");
        CFRelease(address_book);
        return NO;
    }
    
    // Loop through all the contacts looking for one that matches my first and last name as well as my email address.
    for (i = 0; i < [people count]; i++) {
        ABRecordRef person = (ABRecordRef) CFBridgingRetain([people objectAtIndex:i]);
                
        CFStringRef first_name = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef last_name = ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        ABMutableMultiValueRef email_addresses = ABRecordCopyValue(person, kABPersonEmailProperty);
        CFIndex email_count = ABMultiValueGetCount(email_addresses);
        
        for (k=0; k<email_count; k++) {
            CFStringRef email_value = ABMultiValueCopyValueAtIndex(email_addresses, k);

            if (first_name != nil && last_name != nil && email_value != nil &&
                CFStringCompare(search_first_name, first_name, kCFCompareCaseInsensitive) == kCFCompareEqualTo &&
                CFStringCompare(search_last_name, last_name, kCFCompareCaseInsensitive) == kCFCompareEqualTo &&
                CFStringCompare(search_email_address, email_value, kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
                return_value = YES;
            }
        
            CFRelease(email_value);
        }
    }
    
    CFRelease(address_book);
        
    return return_value;
}


//
// Add my contact information to the Address Book
//
-(IBAction)userDidClickAddContactButton:(id)sender
{
    // We shouldn't ever hit this check since addressBookContactAlreadyExists gets called from viewDidLoad but
    // lets avoid adding any possible duplicates just in case.
    if ([self addressBookContactAlreadyExists]) {
        [infoButton setEnabled:NO];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Exists"
                                                        message:@"Looks like you already have my contact info in your Address Book."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Create and populate the Address Book record
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
    
    // Request access to the Address book.  If granted, add the record and save.
    CFErrorRef error = NULL;
    ABAddressBookRef address_book = ABAddressBookCreateWithOptions(NULL, &error);
    ABAddressBookRequestAccessWithCompletion(address_book, ^(bool granted, CFErrorRef error) {
        if (granted) {            
            if (ABAddressBookAddRecord(address_book, record, &error)) {                
                error = NULL;
                
                if (ABAddressBookSave(address_book, &error)) {                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [infoButton setEnabled:NO];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Added"
                                                                        message:@"You have my contact info in your Address Book now."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [infoButton setEnabled:NO];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Unable to save changes to the Address Book."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [infoButton setEnabled:NO];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Unable to add a contact to the Address Book."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [infoButton setEnabled:NO];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Unable to access the Address Book."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            });
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
    
    if ([self addressBookContactAlreadyExists]) {
        [infoButton setEnabled:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
