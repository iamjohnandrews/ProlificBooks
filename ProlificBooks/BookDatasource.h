//
//  BookDatasource.h
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@protocol BookDatasource <NSObject>
@property (strong, nonatomic) Book *book;
@end
