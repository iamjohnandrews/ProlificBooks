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

@interface BookListViewController ()
@property (strong, nonatomic) NSArray *bookListArray;
@end

@implementation BookListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BookNetworking sharedManager] getBooksWithCompletion:^(NSArray *books) {
        self.bookListArray = books;
    }];
    
    self.booksTableView.delegate = self;
    self.booksTableView.dataSource = self;
    
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
