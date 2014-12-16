//
//  BookNetworking.m
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "BookNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "Book.h"

NSString * const ProlificBooksAPI = @"http://prolific-interview.herokuapp.com/5489d91051a6c6000738272e/";

@interface BookNetworking ()
@property (strong, nonatomic) AFHTTPSessionManager *session;
@end

@implementation BookNetworking

+ (instancetype)sharedManager
{
    static BookNetworking *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[self alloc] init];
            sharedManager.session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ProlificBooksAPI]];
            sharedManager.session.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
    });
    return sharedManager;
}

#pragma mark - GET Networking

- (void)getBooksWithCompletion:(RequestedBooksCompletionBlock)completionBlock
{
    NSURLSessionDataTask *dataTask = [self.session GET:@"" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *jsonError = nil;
        NSData *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
        
        NSArray *booksArray = [[NSArray alloc] initWithArray:[self parseBooksResponse:[NSKeyedUnarchiver unarchiveObjectWithData:jsonData]]];
        if (completionBlock) {
            completionBlock(booksArray);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR =%@", error);
    }];
    
    [dataTask resume];
}


- (NSMutableArray *)parseBooksResponse:(NSArray *)bookData
{
    NSMutableArray *BookItemsArray = [NSMutableArray array];
    
    for (NSDictionary *bookInfoDict in bookData) {
        Book *singleBookDetails = [[Book alloc] init];
        singleBookDetails.author = [bookInfoDict objectForKey:@"author"];
        singleBookDetails.categories = [bookInfoDict objectForKey:@"categories"];
        singleBookDetails.lastCheckedOut = [bookInfoDict objectForKey:@"lastCheckedOut"];
        singleBookDetails.lastCheckedOutBy = [bookInfoDict objectForKey:@"lastCheckedOutBy"];
        singleBookDetails.publisher = [bookInfoDict objectForKey:@"publisher"];
        singleBookDetails.title = [bookInfoDict objectForKey:@"title"];
        
        [BookItemsArray addObject:singleBookDetails];
    }
    
    return BookItemsArray;
}

@end
