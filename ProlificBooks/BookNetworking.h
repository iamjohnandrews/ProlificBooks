//
//  BookNetworking.h
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

typedef void (^RequestedBooksCompletionBlock)(NSArray *books);

@interface BookNetworking : NSObject

+ (instancetype)sharedManager;

- (void)getBooksWithCompletion:(RequestedBooksCompletionBlock)completionBlock;
- (void)netTest:(RequestedBooksCompletionBlock)completionBlock;

+ (void)postAddedBook:(Book *)newBook;
+ (void)putUpdatedBookInfo:(Book *)updatedBook;
@end
