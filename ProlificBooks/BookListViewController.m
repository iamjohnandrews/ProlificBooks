//
//  ViewController.m
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "BookListViewController.h"
#import "BookTableViewCell.h"
#import "Book.h"
#import "BookNetworking.h"


@implementation BookListViewController

@synthesize book = _book;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getBookData];
    
    self.booksTableView.delegate = self;
    self.booksTableView.dataSource = self;
    self.booksTableView.allowsMultipleSelectionDuringEditing = YES;
    
}

- (void)getBookData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsUrl = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    NSString *filePath = [documentsUrl.path stringByAppendingPathComponent:@"prolificBooks"];
    NSDictionary *tasksDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        self.bookListArray = tasksDictionary[@"books"];
    } else {
        [[BookNetworking sharedManager] getBooksWithCompletion:^(NSArray *books) {
            self.bookListArray = books;
            [self.booksTableView reloadData];
        }];
    }
    
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
    Book *book = [self.bookListArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
