//
//  FavoriteTabListViewController.h
//  Barfliz
//
//  Created by User on 11/18/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteTabListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
- (IBAction)unwindFavoriteFromAdd:(UIStoryboardSegue *)unwindSegue;
@end
