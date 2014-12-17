//
//  EditBookViewController.h
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDatasource.h"

@interface EditBookViewController : UIViewController <BookDatasource, UIActivityItemSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastCheckedOutLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkoutButtonOutlet;
- (IBAction)checkoutButtonPressed:(id)sender;

@end
