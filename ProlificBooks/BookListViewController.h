//
//  ViewController.h
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookNetworking.h"
#import "BookDatasource.h"

@interface BookListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, BookDatasource>

@property (weak, nonatomic) IBOutlet UITableView *booksTableView;
@property (strong, nonatomic) NSMutableArray *bookListArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBookButtonOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButtonOutlet;
@property (strong, nonatomic) UIBarButtonItem *doneButton;


- (IBAction)addBookButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;

@end

