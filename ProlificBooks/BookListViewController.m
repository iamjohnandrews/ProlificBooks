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
    NSDictionary *booksDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        self.bookListArray = booksDictionary[@"books"];
    } else {
        [[BookNetworking sharedManager] getBooksWithCompletion:^(NSArray *books) {
            self.bookListArray = (NSMutableArray *)books;
            [self.booksTableView reloadData];
        }];
        
//        BookNetworking *bookNet = [[BookNetworking alloc] init];
//        [bookNet netTest:^(NSArray *books) {
//            self.bookListArray = books;
//            [self.booksTableView reloadData];
//        }];
    }
    
    
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTableViewCell *cell = [self.booksTableView dequeueReusableCellWithIdentifier:@"bookCell"];
    Book *book = [self.bookListArray objectAtIndex:indexPath.row];
    cell.book = book;
    cell.editing = YES;
    
    return cell;
}


#pragma mark - TableView Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//first called after tap edit button
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    
    if (self.booksTableView.isEditing) {
        style = UITableViewCellEditingStyleDelete;
    }
    
    return style;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.bookListArray removeObjectAtIndex:indexPath.row];
        
        [self.booksTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.row != destinationIndexPath.row) {
        Book *bookToMove = [self.bookListArray objectAtIndex:sourceIndexPath.row];
        [self.bookListArray removeObjectAtIndex:sourceIndexPath.row];
        [self.bookListArray insertObject:bookToMove atIndex:destinationIndexPath.row];
    }
}

#pragma mark - BarButton Methods
- (UIBarButtonItem *)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(editButtonPressed:)];
        _doneButton.tintColor = [UIColor orangeColor];
    }
    
    return _doneButton;
}
- (IBAction)addBookButtonPressed:(id)sender {
}

- (IBAction)editButtonPressed:(id)sender
{
    BOOL isEditing = self.booksTableView.editing;
    
    isEditing = !isEditing;
    [self.booksTableView setEditing:isEditing animated:YES];
    
    if (isEditing) {
        [self.navigationItem setRightBarButtonItem:self.doneButton
                                          animated:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:self.editButtonOutlet
                                          animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *viewController = segue.destinationViewController;    
    if ([viewController conformsToProtocol:@protocol(BookDatasource)]) {
        ((id<BookDatasource>)viewController).book = self.book;
    }
        
}

@end
