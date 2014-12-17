//
//  BookSaver.m
//  ProlificBooks
//
//  Created by John Andrews on 12/17/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "BookSaver.h"

@interface BookSaver ()
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSString *allBooksPath;
@property (strong, nonatomic) NSString *savedBooksDirectory;

@end

@implementation BookSaver

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        self.allBooksPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.savedBooksDirectory = [self.allBooksPath stringByAppendingString:@"/prolificBooks"];
    }
    return self;
}

- (BOOL)checkIfBookIsAlreadySaved:(NSString *)title and:(NSString *)author
{
    NSString *bookFilePath = [[[self.allBooksPath stringByAppendingString:@"/prolificBooks/"] stringByAppendingString:title] stringByAppendingString:author];
    BOOL bookExists = [self.fileManager fileExistsAtPath:bookFilePath];
    
    return bookExists;
}

- (void)saveBook:(Book *)newBook
{
    if (![self.fileManager fileExistsAtPath:self.savedBooksDirectory]) {
        [self.fileManager createDirectoryAtPath:self.savedBooksDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *bookPath = [[self.savedBooksDirectory stringByAppendingPathComponent:newBook.title] stringByAppendingPathComponent:newBook.author];
    
    [NSKeyedArchiver archiveRootObject:newBook toFile:bookPath];
}

- (NSArray *)fetchAllBooks
{
    NSMutableArray *bookListArray = [NSMutableArray array];
    
    NSURL *booksURL = [NSURL URLWithString:self.savedBooksDirectory];
    NSArray *contents = [self.fileManager contentsOfDirectoryAtURL:booksURL
                                        includingPropertiesForKeys:@[]
                                                           options:NSDirectoryEnumerationSkipsHiddenFiles
                                                             error:nil];
    for (NSURL *booksFile in contents) {
        Book *booksDetails = [NSKeyedUnarchiver unarchiveObjectWithFile:booksFile.path];
        [bookListArray addObject:booksDetails];
    }
    
    return bookListArray;
}

@end
