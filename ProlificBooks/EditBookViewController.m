//
//  EditBookViewController.m
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "EditBookViewController.h"
#import "BookNetworking.h"
#import <Social/Social.h>

@interface EditBookViewController ()

@end

@implementation EditBookViewController
@synthesize book = _book;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (NSString *)convertDateIntoPresentableFormat:(NSDate *)date
{
    NSDateFormatter *dateAndTimeFormatter = [[NSDateFormatter alloc] init];
    [dateAndTimeFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    [dateAndTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    NSString *dateAndTime = [dateAndTimeFormatter stringFromDate:date];
    
    return dateAndTime;
}

- (void)setupUI
{
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = self.book.author;
//    self.publisherLabel.text = self.book.publisher;
//    self.lastCheckedOutLabel.text = [self convertDateIntoPresentableFormat:self.book.lastCheckedOut];
    self.publisherLabel.text = @"publisher placeholder";
    self.lastCheckedOutLabel.text = [self convertDateIntoPresentableFormat:[NSDate date]];
    
    self.navigationItem.title = @"Detail";
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(shareButtonPressed:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)shareButtonPressed:(id)sender
{
    [self shareBookInfo];
}

- (IBAction)checkoutButtonPressed:(id)sender
{
    [self askUserForName];
}

#pragma mark TextField Methods
- (void)askUserForName
{
    UITextField *userName = [[UITextField alloc] initWithFrame:CGRectMake(self.checkoutButtonOutlet.frame.origin.x,
                                                                          self.checkoutButtonOutlet.frame.origin.y + self.checkoutButtonOutlet.frame.size.height + 20.0f,
                                                                          self.checkoutButtonOutlet.frame.size.width,
                                                                          self.checkoutButtonOutlet.frame.size.height)];
    userName.placeholder = @"Insert name here";
    [self.view addSubview:userName];
}

 - (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.book.lastCheckedOutBy = textField.text;
    self.book.lastCheckedOut = [NSDate date];
    
    [BookNetworking putUpdatedBookInfo:self.book];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

#pragma mark Social Share Methods
- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"Placeholder";
}

- (void)shareBookInfo
{
    NSArray *bookInfoToShare = @[self.titleLabel.text, self.authorLabel.text, self.publisherLabel.text, self.lastCheckedOutLabel.text];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:bookInfoToShare
                                                                             applicationActivities:nil];
    [self.navigationController presentViewController:activityVC animated:YES completion:^{
        NSLog(@"presenting social stuff");
    }];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        [self postToFacebookOrTwitter:@"facebook"];
        return @"Facebook";
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        [self postToFacebookOrTwitter:@"twiiter"];
        return @"Twiiter";
    }
    
    return nil;
}

- (void)postToFacebookOrTwitter:(NSString *)socialPlatform
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *socialViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [socialViewController setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             if (result == SLComposeViewControllerResultCancelled) {
                 NSLog(@"%@ Result Cancelled", socialPlatform);
             }
         }];
        
        [self presentViewController:socialViewController animated:YES completion:nil];
    } else {
        NSString *title = [NSString stringWithFormat:@"%@ Problem", socialPlatform];
        NSString *message = [NSString stringWithFormat:@"Currently, %@ is not available", socialPlatform];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}



@end
