//
//  BookNetworking.m
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "BookNetworking.h"
#import <AFNetworking/AFNetworking.h>

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
@end
