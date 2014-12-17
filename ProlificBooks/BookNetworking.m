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
//            sharedManager.session.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
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
                                                           options:kNilOptions
                                                             error:&jsonError];
        NSArray *booksArray;
        if (!jsonData) {
            booksArray = [[NSArray alloc] initWithArray:[self getHotelData]];
        } else {
            booksArray = [[NSArray alloc] initWithArray:[self parseBooksResponse:[NSKeyedUnarchiver unarchiveObjectWithData:jsonData]]];
        }
        if (completionBlock) {
            completionBlock(booksArray);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR =%@", error);
    }];
    
    [dataTask resume];
}

- (NSArray *)getHotelData
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"hotels" ofType:@"json"];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                                            options:kNilOptions
                                                              error:nil];
    
    NSMutableArray *hotelObjectsArray = [NSMutableArray array];
    NSArray *hotelsDict = [jsonDict objectForKey:@"hotels"];
    
    for (NSDictionary *hotelDetails in hotelsDict) {
        Book *hotel = [[Book alloc] init];
        hotel.hotelName = [hotelDetails objectForKey:@"name"];
        hotel.hotelAddress = [hotelDetails objectForKey:@"street_address"];
        
        [hotelObjectsArray addObject:hotel];
    }
    
    return (NSArray *)hotelObjectsArray;
}

- (void)netTest:(RequestedBooksCompletionBlock)completionBlock;
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ProlificBooksAPI]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
//    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *jsonData;
        NSError *jsonError = nil;
        jsonData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:kNilOptions
                                                                 error:&jsonError];
        NSArray *booksArray = [[NSArray alloc] initWithArray:[self parseBooksResponse:[NSKeyedUnarchiver unarchiveObjectWithData:jsonData]]];

        if (completionBlock) {
            completionBlock(booksArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
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

#pragma mark - PUT Networking
+ (void)putUpdatedBookInfo:(Book *)updatedBook
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"lastCheckedOutBy": updatedBook.lastCheckedOutBy};
    
    [manager PUT:ProlificBooksAPI parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
}

#pragma mark - POST Networking
+ (void)postAddedBook:(Book *)newBook
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"author": newBook.author,
                                 @"categories" : newBook.categories,
                                 @"lastCheckedOutBy" : newBook.lastCheckedOutBy,
                                 @"publisher" : newBook.publisher,
                                 @"title" : newBook.title};
    
    [manager POST:ProlificBooksAPI parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
}


@end
