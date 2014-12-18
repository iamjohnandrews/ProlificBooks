//
//  Book.m
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "Book.h"

@implementation Book

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.author = [aDecoder decodeObjectForKey:@"author"];
    self.categories = [aDecoder decodeObjectForKey:@"categories"];
    self.lastCheckedOut = [aDecoder decodeObjectForKey:@"lastCheckedOut"];
    self.lastCheckedOutBy = [aDecoder decodeObjectForKey:@"lastCheckedOutBy"];
    self.publisher = [aDecoder decodeObjectForKey:@"publisher"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.categories forKey:@"categories"];
    [aCoder encodeObject:self.lastCheckedOut forKey:@"lastCheckedOut"];
    [aCoder encodeObject:self.lastCheckedOutBy forKey:@"lastCheckedOutBy"];
    [aCoder encodeObject:self.publisher forKey:@"publisher"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

@end
