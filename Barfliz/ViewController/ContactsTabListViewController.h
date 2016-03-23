//
//  ContactsTabListViewController.h
//  Barfliz
//
//  Created by User on 11/16/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTabListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
- (IBAction)unwindContactFromAdd:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindContactFromFavorite:(UIStoryboardSegue *)unwindSegue;
@end
