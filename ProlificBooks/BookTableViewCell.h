//
//  BookTableViewCell.h
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookTableViewCell : UITableViewCell
@property (strong, nonatomic) Book *book;
@end
