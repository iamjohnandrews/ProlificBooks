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
@property (strong, nonatomic) NSArray *bookListArray;

@end

