//
//  BookSaver.h
//  ProlificBooks
//
//  Created by John Andrews on 12/17/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface BookSaver : NSObject
- (BOOL)checkIfBookIsAlreadySaved:(NSString *)title and:(NSString *)author;
- (void)saveBook:(Book *)newBook;
- (void)deleteBook:(Book *)unwantedBook;
- (void)deleteBooks:(NSArray *)unwantedBookList;
- (NSArray *)fetchAllBooks;
@end
