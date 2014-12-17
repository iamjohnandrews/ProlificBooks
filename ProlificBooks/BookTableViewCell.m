//
//  BookTableViewCell.m
//  ProlificBooks
//
//  Created by John Andrews on 12/16/14.
//  Copyright (c) 2014 ProlificCodingChallenge. All rights reserved.
//

#import "BookTableViewCell.h"

@implementation BookTableViewCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBook:(Book *)book
{
    _book = book;
    [self updateUI];
}

- (void)updateUI
{
//    self.textLabel.text = self.book.title;
//    self.detailTextLabel.text = self.book.author;

    self.editing = YES;
    self.textLabel.text = self.book.hotelName;
    self.detailTextLabel.text = self.book.hotelAddress;
}

@end
