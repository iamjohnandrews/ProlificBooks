//
//  Book.h
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject <NSCoding>
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *categories;
@property (strong, nonatomic) NSDate *lastCheckedOut;
@property (strong, nonatomic) NSString *lastCheckedOutBy;
@property (strong, nonatomic) NSString *publisher;
@property (strong, nonatomic) NSString *title;

@end
