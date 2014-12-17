//
//  AddBookViewController.m
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "AddBookViewController.h"
#import "Book.h"
#import "BookSaver.h"

@interface AddBookViewController ()

@end

@implementation AddBookViewController
@synthesize book = _book;

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - TextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}

- (BOOL)doAllTextFieldsHaveInformation
{
    BOOL textFieldsHaveInfo;
    
    if (self.authorTextField.text.length && self.titleTextField.text.length &&
        self.publisherTextField.text.length && self.categoryTextField.text.length ) {
        textFieldsHaveInfo = YES;
    } else {
        textFieldsHaveInfo = NO;
    }
    
    return textFieldsHaveInfo;
}

- (IBAction)doneButtonPressed:(id)sender
{
    if ([self doAllTextFieldsHaveInformation]) {
        [self saveToLocalStorage];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Incomplete"
                                                         message:@"Please provide all book details."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
}

- (void)saveToLocalStorage
{
    BookSaver *localStorage = [[BookSaver alloc] init];
    if (![localStorage checkIfBookIsAlreadySaved:self.titleTextField.text and:self.authorTextField.text] ) {
        Book *newBook = [[Book alloc] init];
        newBook.author = self.authorTextField.text;
        newBook.categories = self.categoryTextField.text;
        newBook.publisher = self.publisherTextField.text;
        newBook.title = self.titleTextField.text;
        
        [localStorage saveBook:newBook];
        
    } else {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Book Already Saved"
                                                         message:@"You have already saved this book."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
    }
}


@end
