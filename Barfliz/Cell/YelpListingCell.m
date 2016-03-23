//
//  YelpListingCell.m
//  Barfliz
//
//  Created by User on 11/13/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "YelpListingCell.h"
#import "UIImageView+AFNetworking.h"

@implementation YelpListingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setYelpListing:(YelpListing *)yelpListing
{
    _yelpListing = yelpListing;
    
    self.restaurantTitle.text   = [NSString stringWithFormat:@"%@.%@", yelpListing.index, yelpListing.title];
    NSLog(@"Title %@", yelpListing.title);
    self.addressLabel.text      = [NSString stringWithFormat:@"%@, %@", yelpListing.address, yelpListing.neighborhood];
    self.reviewCount.text       = [NSString stringWithFormat: @"%@ reviews", yelpListing.reviewCount];
    self.categoryLabel.text     = [NSString stringWithFormat: @"%@", yelpListing.categories];
    
    [self.restaurantImage       setImageWithURL: [NSURL URLWithString:yelpListing.listingImageUrl]];
    [self.ratingsImage          setImageWithURL: [NSURL URLWithString:yelpListing.ratingImageUrl]];
}


@end
