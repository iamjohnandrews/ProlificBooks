//
//  AddBookViewController.m
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "AddBookViewController.h"
#import "Book.h"

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
        [self AccessLocalStorageAndCreateNewModelObject];
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

- (void)AccessLocalStorageAndCreateNewModelObject
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsUrl = [[fileManager URLsForDirectory:NSDocumentDirectory
                                               inDomains:NSUserDomainMask] lastObject];
    NSString *filePath = [documentsUrl.path stringByAppendingPathComponent:@"prolificBooks"];
    NSDictionary *booksDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSMutableArray *booksListArray = booksDictionary[@"books"];
    
    if (![self doesBookAlreadyExist:booksListArray]) {
        Book *newBook = [[Book alloc] init];
        newBook.author = self.authorTextField.text;
        newBook.categories = self.categoryTextField.text;
        newBook.publisher = self.publisherTextField.text;
        newBook.title = self.titleTextField.text;
        
        [booksListArray addObject:newBook];
    }
}

- (BOOL)doesBookAlreadyExist:(NSArray *)bookList
{
    BOOL bookAlreadyExists = NO;
    
    for (Book *existingBook in bookList) {
        if ([existingBook.author isEqualToString:self.authorTextField.text] &&
            [existingBook.title isEqualToString:self.titleTextField.text]) {
            bookAlreadyExists = YES;
        }
    }
    return bookAlreadyExists;
}

- (void)saveToLocalStorage:(Book *)newBook
{
    
}
@end
