//
//  BookSaver.m
//  ProlificBooks
//
//  Created by John Andrews on 12/17/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "BookSaver.h"
#import "BookNetworking.h"

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
    NSString *bookFilePath = [[self.savedBooksDirectory stringByAppendingString:title] stringByAppendingString:author];
    BOOL bookExists = [self.fileManager fileExistsAtPath:bookFilePath];
    
    return bookExists;
}

- (void)saveBook:(Book *)newBook
{
    NSString *newBooksPath = [[self.savedBooksDirectory stringByAppendingString:newBook.title] stringByAppendingString:newBook.author];
    
    if (![self checkIfBookIsAlreadySaved:newBook.title and:newBook.author]) {
        [self.fileManager createDirectoryAtPath:newBooksPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [NSKeyedArchiver archiveRootObject:newBook toFile:newBooksPath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [BookNetworking postAddedBook:newBook];
    });
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

- (void)deleteBook:(Book *)unwantedBook
{
    NSString *unwantedBookPath = [[self.savedBooksDirectory stringByAppendingString:unwantedBook.title] stringByAppendingString:unwantedBook.author];
    NSError *error = nil;
    if (![self.fileManager removeItemAtPath:unwantedBookPath error:&error]) {
        NSLog(@"[Error] %@ (%@)", error, unwantedBookPath);
    }
}

- (void)deleteBooks:(NSArray *)unwantedBookList
{
    for (Book *unwantedBook in unwantedBookList) {
        [self deleteBook:unwantedBook];
    }
}

@end
