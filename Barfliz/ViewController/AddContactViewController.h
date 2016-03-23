//
//  AddContactViewController.h
//  Barfliz
//
//  Created by User on 11/17/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendInfo.h"

@interface AddContactViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property NSInteger checkedPos;
@property (nonatomic, strong) PFUser *selContact;
@end
