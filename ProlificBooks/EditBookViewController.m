//
//  EditBookViewController.m
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "EditBookViewController.h"
#import "BookNetworking.h"

@interface EditBookViewController ()

@end

@implementation EditBookViewController
@synthesize book = _book;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = self.book.author;
    self.publisherLabel.text = self.book.publisher;
    self.lastCheckedOutLabel.text = [self convertDateIntoPresentableFormat:self.book.lastCheckedOut];
}

- (NSString *)convertDateIntoPresentableFormat:(NSDate *)date
{
    NSDateFormatter *dateAndTimeFormatter = [[NSDateFormatter alloc] init];
    [dateAndTimeFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    [dateAndTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    NSString *dateAndTime = [dateAndTimeFormatter stringFromDate:date];
    
    return dateAndTime;
}


- (IBAction)checkoutButtonPressed:(id)sender
{
    
}
@end
