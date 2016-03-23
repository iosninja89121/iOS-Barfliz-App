//
//  LocationTableViewController.h
//  Barfliz
//
//  Created by User on 11/13/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpListing.h"
#import <CoreLocation/CoreLocation.h>
@interface LocationTableViewController : UITableViewController<UISearchBarDelegate, CLLocationManagerDelegate>
@property YelpListing *tappedItem;
@end
