//
//  YelpListingCell.h
//  Barfliz
//
//  Created by User on 11/13/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpListing.h"

@interface YelpListingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ratingsImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantTitle;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;

@property (nonatomic, strong) YelpListing *yelpListing;

@end
